import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data_settings_notifier.dart';

class DataSettingsScreen extends ConsumerWidget {
  const DataSettingsScreen({super.key});

  // Modern low-saturation palette constants
  static const Color backgroundColor = Color(0xFFF8F9FA); 
  static const Color surfaceColor = Colors.white;
  static const Color lavenderAccent = Color(0xFF7C698D); 
  static const Color borderGray = Color(0xFFE9ECEF);
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataSettingsProvider);
    final notifier = ref.read(dataSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        title: const Text(
          'Data & Privacy Settings',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Provides users with the ability to create a secure cloud backup of their
          // application data through Google Drive integration. Displays backup status and
          // triggers asynchronous backup operations through DataSettingsNotifier
          const _SectionHeader(title: 'Data Backup'),
          _ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keep your personal data safely backed up to Google Drive. Your backup allows you to restore your information if you change devices',
                  style: TextStyle(color: textSecondary, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last Backup: ${state.lastBackupDate}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lavenderAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: state.isBackingUp
                          ? null
                          : () async {
                              try {
                                final success = await ref
                                    .read(dataSettingsProvider.notifier)
                                    .performGoogleDriveBackup();

                                if (context.mounted && success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Backup uploaded to Google Drive successfully!'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Backup failed: $e')),
                                  );
                                }
                              }
                            },
                      child: state.isBackingUp
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Backup to Google Drive',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Allows users to recover application data from either a local JSON export or
          // a Google Drive backup. Restoration operations replace existing local records
          // after explicit user confirmation.
          const _SectionHeader(title: 'Restore Data'),
          _ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Restore your previous records from a Google Drive cloud backup or an exported JSON file stored on your device',
                  style: TextStyle(color: textSecondary, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFE8B2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Warning: Restoring data will replace current application data.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Option A: Local JSON File Import
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textPrimary,
                          side: const BorderSide(color: borderGray),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.file_upload_outlined, size: 16, color: textSecondary),
                        label: const Text('Import JSON', style: TextStyle(fontSize: 13)),
                        onPressed: state.isRestoring
                            ? null
                            : () async {
                                try {
                                  final success = await notifier.restoreFromLocalJson();
                                  if (context.mounted && success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data imported successfully from local JSON file!'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Local restore failed: $e')),
                                    );
                                  }
                                }
                              },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Option B: Google Drive Cloud Restore
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: lavenderAccent,
                          side: const BorderSide(color: Color(0xFFD6CDE2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.cloud_download_outlined, size: 16),
                        label: const Text('From Drive', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        onPressed: state.isRestoring
                            ? null
                            : () async {
                                try {
                                  final success = await notifier.performGoogleDriveRestore();
                                  if (context.mounted && success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data restored successfully from Google Drive!'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Drive restore failed: $e')),
                                    );
                                  }
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Provides data portability by allowing users to preview and export their
          // personal application records in a structured JSON format.
          const _SectionHeader(title: 'Export My Data'),
          _ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Export a complete copy of all personal records into a portable JSON file for safe-keeping or transfer',
                  style: TextStyle(color: textSecondary, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textPrimary,
                          side: const BorderSide(color: borderGray),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.code_rounded, size: 16, color: textSecondary),
                        label: const Text('Preview JSON', style: TextStyle(fontSize: 13)),
                        onPressed: () => _handlePreviewAction(context, notifier),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lavenderAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.share_rounded, size: 16),
                        label: const Text(
                          'Share / Save',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        onPressed: state.isExporting
                            ? null
                            : () => _handleShareAction(context, notifier),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          // Provides a permanent data removal option for privacy management. Requires
          // explicit user confirmation before clearing all locally stored records.
          const _SectionHeader(title: 'Danger Zone', isDanger: true),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Permanently remove all personal information stored in this application',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF991B1B),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This includes:\n• Tools Section logs\n• Unlocked stickers',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB91C1C), height: 1.5),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _showDeleteConfirmationDialog(context, notifier),
                    child: const Text(
                      'Delete All Data',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Contains helper methods responsible for coordinating user interactions,
  // including export preview dialogs, sharing workflows, and destructive action
  // confirmations

  void _handlePreviewAction(BuildContext context, DataSettingsNotifier notifier) async {
    final jsonPayload = await notifier.generateFullAppExportPayload();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Full App Export Preview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SelectableText(
                jsonPayload,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close', style: TextStyle(color: lavenderAccent)),
            ),
          ],
        ),
      );
    }
  }

  void _handleShareAction(BuildContext context, DataSettingsNotifier notifier) async {
    await notifier.exportAndShareData();
  }

  void _showDeleteConfirmationDialog(BuildContext context, DataSettingsNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Are you sure?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This action cannot be undone. All local database records across all modules will be permanently erased',
          style: TextStyle(fontSize: 13, color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              await notifier.deleteAllLocalData();
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All local data has been permanently cleared'),
                  ),
                );
              }
            },
            child: const Text(
              'Confirm Delete',
              style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Lightweight UI components used to maintain consistent styling across the
// data management settings interface.
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDanger;

  const _SectionHeader({
    super.key,
    required this.title,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: isDanger ? const Color(0xFFDC2626) : const Color(0xFF495057),
        ),
      ),
    );
  }
}

// Provides a reusable card container following the application's visual design
// system for settings panels.
class _ModernCard extends StatelessWidget {
  final Widget child;

  const _ModernCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DataSettingsScreen.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DataSettingsScreen.borderGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}