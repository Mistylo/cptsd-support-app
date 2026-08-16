import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:cptsd_app/main.dart'; // Imports your global isarProvider
import 'journal_model.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio_provider.dart';

/// Represents the current journaling module state, including
/// stored entries and loading status
class JournalState {
  final List<JournalEntry> entries;
  final bool isLoading;

  JournalState({
    required this.entries,
    this.isLoading = false,
  });

  JournalState copyWith({
    List<JournalEntry>? entries,
    bool? isLoading,
  }) {
    return JournalState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Handles journal related operations including loading,
/// saving, updating, and deleting entries while synchronizing
/// UI state with local persistence.
class JournalNotifier extends StateNotifier<JournalState> {
  final Isar _isar;
  final Ref _ref;

  JournalNotifier(this._isar, this._ref) : super(JournalState(entries: [])) {
    loadEntries();
  }

  // Fetch all saved journals, newest first
  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true);
    final results = await _isar.journalEntrys.where().sortByTimestampDesc().findAll();
    state = state.copyWith(entries: results, isLoading: false);
  }

  // Create a new journal entry or update an existing entry,
  // including user content and visual customization settings.
  Future<void> saveJournal({
    Id? id,
    required String type,
    required Map<String, dynamic> content,
    required String fontFamily,
    required int backgroundColor,
    String? backgroundPattern,
    required List<Map<String, dynamic>> placedStickers,
  }) async {
    // JSON serialization allows different journaling formats and
    // canvas configurations to share the same database model
    final entry = JournalEntry()
      ..type = type
      ..timestamp = DateTime.now()
      ..contentJson = jsonEncode(content)
      ..fontFamily = fontFamily
      ..backgroundColorValue = backgroundColor
      ..backgroundPattern = backgroundPattern
      ..placedStickersJson = jsonEncode(placedStickers);

    if (id != null) {
      entry.id = id;
    }

    await _isar.writeTxn(() async {
      await _isar.journalEntrys.put(entry);
    });

    // Refresh the local list state
    await loadEntries();

    // Update the progress tracking system when a new journaling
   // activity is completed.
    if (id == null) {
      await _ref.read(studioProvider.notifier).completeActivity(
        StudioNotifier.actJournaling, 
        _getReadableTypeName(type),
      );
    }
  }

  // Delete a journal
  Future<void> deleteJournal(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.journalEntrys.delete(id);
    });
    await loadEntries();
  }

  // Convert internal journal identifiers into user facing activity names
  String _getReadableTypeName(String type) {
    switch (type) {
      case 'free_writing': return 'Free Writing Journal';
      case 'moment_of_calm': return 'Moment of Calm';
      default: return 'Journaling';
    }
  }
}

// Provides journal state management with automatic dependency injection
// for local database access.
final journalProvider = StateNotifierProvider<JournalNotifier, JournalState>((ref) {
  final isar = ref.watch(isarProvider);
  return JournalNotifier(isar, ref);
});