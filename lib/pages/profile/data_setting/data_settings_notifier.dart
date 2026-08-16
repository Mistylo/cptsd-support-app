import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cptsd_app/pages/tools/emotional_awareness/journaling/journal_provider.dart';

import 'package:cptsd_app/main.dart';
import 'package:cptsd_app/pages/tools/emotional_awareness/journaling/journal_model.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio_models.dart';

// Represents the current status of user data operations, including backup,
// restoration, exporting processes, and connected cloud account information.
// This state is consumed by the UI to provide feedback during asynchronous tasks.
class DataSettingsState {
  final bool isBackingUp;
  final bool isRestoring;
  final bool isExporting;
  final String? lastBackupDate;
  final String? googleAccountEmail;

  DataSettingsState({
    this.isBackingUp = false,
    this.isRestoring = false,
    this.isExporting = false,
    this.lastBackupDate = 'Never',
    this.googleAccountEmail,
  });

  DataSettingsState copyWith({
    bool? isBackingUp,
    bool? isRestoring,
    bool? isExporting,
    String? lastBackupDate,
    String? googleAccountEmail,
  }) {
    return DataSettingsState(
      isBackingUp: isBackingUp ?? this.isBackingUp,
      isRestoring: isRestoring ?? this.isRestoring,
      isExporting: isExporting ?? this.isExporting,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      googleAccountEmail: googleAccountEmail ?? this.googleAccountEmail,
    );
  }
}

// Handles all data management operations for the application, including:
// - Local data export and import
// - Google Drive backup and restoration
// - Database reset functionality
class DataSettingsNotifier extends StateNotifier<DataSettingsState> {
  final Isar _isar;
  final Ref _ref;
  late final GoogleSignIn _googleSignIn;

  static const String _backupFileName = 'cptsd_app_backup.json';

  DataSettingsNotifier(this._isar,  this._ref,) : super(DataSettingsState()) {
  _googleSignIn = GoogleSignIn(
    params: GoogleSignInParams(
      clientId: dotenv.env['WINDOWS_CLIENT_ID'] ?? '',
      clientSecret: dotenv.env['WINDOWS_CLIENT_SECRET'] ?? '',
      redirectPort: 8000,
      timeout: const Duration(seconds: 30),
      scopes: [
        drive.DriveApi.driveAppdataScope,
      ],
    ),
  );
}

// Serialises local application data into JSON format and securely uploads the
// backup file to Google's application specific storage area (appDataFolder).
// OAuth authentication is used to ensure users maintain ownership and control
// over their stored data.
Future<bool> performGoogleDriveBackup() async {
  state = state.copyWith(isBackingUp: true);
  await _googleSignIn.signOut();
  try {
    // Force cancellation after 20 seconds if user abandons/closes browser
    final credentials = await _googleSignIn.signIn().timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        // Returns null if user never completed the OAuth flow
        return null; 
      },
    );
    print('Google credentials: $credentials');

    if (credentials == null) {
      return false;
    }
    final http.Client? client =
        await _googleSignIn.authenticatedClient;

    if (client == null) {
      throw Exception('Failed to obtain authenticated HTTP client.');
    }
    final driveApi = drive.DriveApi(client);

    final String jsonPayload = await generateFullAppExportPayload();
    final List<int> fileBytes = utf8.encode(jsonPayload);
    final Stream<List<int>> mediaStream = Stream.value(fileBytes);

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_backupFileName' and trashed = false",
    );

    final media = drive.Media(mediaStream, fileBytes.length);

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      final existingFileId = fileList.files!.first.id!;
      await driveApi.files.update(
        drive.File(),
        existingFileId,
        uploadMedia: media,
      );
    } else {
      final driveFile = drive.File()
        ..name = _backupFileName
        ..parents = ['appDataFolder'];

      await driveApi.files.create(
        driveFile,
        uploadMedia: media,
      );
    }

    final now = DateTime.now();
    final formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour}:${now.minute.toString().padLeft(2, '0')}";

    state = state.copyWith(lastBackupDate: formattedDate);
    return true;

  } catch (e,stackTrace) {
  print(e);
  print(stackTrace);
  return false;
  } finally {
    // This will now ALWAYS run after 20 seconds max
    state = state.copyWith(isBackingUp: false);
  }
}

// Retrieves the user's backup file from Google Drive, deserialises the stored
// JSON data, and restores application records into the local Isar database.
// Database reconstruction is handled through a shared restoration pipeline.
Future<bool> performGoogleDriveRestore() async {
  state = state.copyWith(isRestoring: true);

  try {
    
    final credentials = await _googleSignIn.signIn().timeout(
      const Duration(seconds: 20),
      onTimeout: () => null,
    );

    if (credentials == null) {
      return false;
    }

    final http.Client? client = await _googleSignIn.authenticatedClient;
    if (client == null) {
      throw Exception('Failed to obtain authenticated HTTP client.');
    }

    final driveApi = drive.DriveApi(client);

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_backupFileName' and trashed = false",
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception('No backup file found in your Google Drive app storage.');
    }

    final fileId = fileList.files!.first.id!;

    final drive.Media downloadedMedia = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final List<int> bytes = [];
    await downloadedMedia.stream.forEach(bytes.addAll);
    final String jsonContent = utf8.decode(bytes);

    await _applyRestoredPayloadToIsar(jsonContent);
    await _ref.read(journalProvider.notifier).loadEntries();
    return true;

  } catch (e) {
    return false;
  } finally {
    state = state.copyWith(isRestoring: false);
  }
}

  // Allows users to restore previously exported application data from a local
  // JSON backup file, supporting data portability without requiring cloud storage.
  Future<bool> restoreFromLocalJson() async {
    state = state.copyWith(isRestoring: true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        state = state.copyWith(isRestoring: false);
        return false;
      }

      final file = File(result.files.single.path!);
      final String jsonString = await file.readAsString();

      await _applyRestoredPayloadToIsar(jsonString);

      state = state.copyWith(isRestoring: false);
      return true;
    } catch (e) {
      state = state.copyWith(isRestoring: false);
      rethrow;
    }
  }

// Converts application records into a structured JSON representation that can
// be saved, shared, or transferred between compatible application instances
  Future<String> generateFullAppExportPayload() async {
    state = state.copyWith(isExporting: true);

    try {
      final journals = await _isar.journalEntrys.where().findAll();
      final stickers = await _isar.unlockedStickers.where().findAll();

      final Map<String, dynamic> exportMap = {
        "export_metadata": {
          "app_name": "CPTSD Companion",
          "app_version": "1.0.0",
          "exported_at": DateTime.now().toIso8601String(),
          "storage_type": "Isar Local Database",
        },
        "journal_entries": journals
            .map((j) => {
                  "id": j.id,
                  "type": j.type,
                  "timestamp": j.timestamp.toIso8601String(),
                  "title": j.title,
                  "content_json": j.contentJson,
                  "font_family": j.fontFamily,
                  "background_color": j.backgroundColorValue,
                  "placed_stickers_json": j.placedStickersJson,
                })
            .toList(),
        "stickers": stickers
            .map((s) => {
                  "id": s.id,
                  "name": s.name,
                  "image_path": s.imagePath,
                  "unlocked_at": s.unlockedAt.toIso8601String(),
                  "is_custom": s.isCustom,
                  "is_milestone": s.isMilestone,
                  "tags": s.tags,
                })
            .toList(),
      };

      return const JsonEncoder.withIndent('  ').convert(exportMap);
    } finally {
      state = state.copyWith(isExporting: false);
    }
  }

  Future<void> exportAndShareData() async {
    final jsonPayload = await generateFullAppExportPayload();

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/cptsd_app_full_export.json';
    final file = File(filePath);
    await file.writeAsString(jsonPayload);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'CPTSD Companion - Full Personal Data Export',
    );
  }

  Future<void> deleteAllLocalData() async {

  await _isar.writeTxn(() async {
    await _isar.clear();
  });


  // refresh UI providers
  await _ref.read(journalProvider.notifier).loadEntries();

}

  // Converts exported JSON data back into Isar database models and restores
  // application state within a transaction to maintain data consistency
  Future<void> _applyRestoredPayloadToIsar(String jsonString) async {
    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    final List<dynamic> rawJournals = decoded['journal_entries'] ?? [];
    final List<dynamic> rawStickers = decoded['stickers'] ?? [];

    await _isar.writeTxn(() async {
      await _isar.clear();

      for (final item in rawJournals) {
        final entry = JournalEntry()
          ..id = item['id']
          ..type = item['type']
          ..timestamp = DateTime.parse(item['timestamp'])
          ..title = item['title']
          ..contentJson = item['content_json']
          ..fontFamily = item['font_family']
          ..backgroundColorValue = item['background_color']
          ..placedStickersJson = item['placed_stickers_json'];

        await _isar.journalEntrys.put(entry);
      }

      for (final item in rawStickers) {
        final sticker = UnlockedSticker()
          ..id = item['id']
          ..name = item['name']
          ..imagePath = item['image_path']
          ..unlockedAt = DateTime.parse(item['unlocked_at'])
          ..isCustom = item['is_custom'] ?? false
          ..isMilestone = item['is_milestone'] ?? false
          ..tags = List<String>.from(item['tags'] ?? []);

        await _isar.unlockedStickers.put(sticker);
      }
    });
  }
}

// Provides a centralized instance of DataSettingsNotifier and injects the
// Isar database dependency for application-wide data management operations
final dataSettingsProvider =
    StateNotifierProvider<DataSettingsNotifier, DataSettingsState>((ref) {

  final isar = ref.watch(isarProvider);

  return DataSettingsNotifier(
    isar,
    ref,
  );
});