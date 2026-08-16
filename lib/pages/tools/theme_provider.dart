// Provides the shared theme state used across the application tools section.
import 'package:cptsd_app/resources.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stores and manages the current visual theme configuration.
///
/// Riverpod is used to allow different tool pages to access and update
/// theme settings while maintaining a shared application-wide state.
final appThemeProvider = StateProvider<ToolThemeData>((ref) {
  // Sets the default appearance when the application starts.
  // The Cloud theme provides the initial visual style before any
  // user customisation is applied.
  return const ToolThemeData(
    accentName: "Cloud",
    themeMode: AppCanvasMode.defaultCloud,
  );
});