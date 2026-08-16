import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio_models.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio_provider.dart';
import 'package:cptsd_app/pages/tools/tools_page.dart';
import 'package:cptsd_app/pages/tools/emotional_awareness/journaling/journal_model.dart';
import 'package:cptsd_app/pages/tools/emotional_awareness/journaling/journal_provider.dart';
import 'package:cptsd_app/pages/profile/affirmation_notifications/notification_models.dart';
import 'package:cptsd_app/pages/profile/security/pin_lock_page.dart';

/// Provides access to the Isar database through Riverpod
/// The actual database instance is added in main() after it is opened
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError(
    'Database was not initialized before app boot.',
  );
});

/// Custom HTTP settings used when making network requests
/// The certificate callback rejects certificates that are not trusted
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(
      SecurityContext? context) {
    final client =
        super.createHttpClient(context);

    client.badCertificateCallback =
        (X509Certificate cert,
            String host,
            int port) {
      debugPrint(
        "Certificate check: $host",
      );
      // Do not accept invalid certificates
      return false;
    };
    return client;
  }
}

Future<void> main() async {
  // Make sure Flutter is ready before using platform services
  WidgetsFlutterBinding.ensureInitialized();

  // Apply the custom HTTP certificate settings
  HttpOverrides.global =
      MyHttpOverrides();

  // Load timezone information for scheduled notifications
  tz.initializeTimeZones();

  // Load environment variables such as the Claude API key
  await dotenv.load(
    fileName: ".env",
  );

  // Get the application's local documents directory
  // and use it to store the Isar database
  final dir =
      await getApplicationDocumentsDirectory();

  // Open the local database and register all collections
  // used by the application
  final isarInstance =
      await Isar.open(
    [
      UnlockedStickerSchema,
      StudioStateDataSchema,
      JournalEntrySchema,
      AffirmationSchema,
    ],
    directory: dir.path,
  );

  // Start the application and provide the Isar instance
  // to the rest of the app through Riverpod
  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(
          isarInstance,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'CPTSD Support App',
      debugShowCheckedModeBanner:
          false,
      theme:
          ThemeData(
        useMaterial3:
            true,
        brightness:
            Brightness.light,
      ),

      // The PIN lock is shown before the main Tools page
      // If no PIN has been configured, the user can enter the app directly
      home:
          const PinLockPage(
        childOnUnlock:
          ToolsPage(),
      ),
    );
  }
}