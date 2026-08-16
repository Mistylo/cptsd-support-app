import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';
import 'package:cptsd_app/main.dart';
import 'notification_models.dart';

/// Affirmation Management Interface
///
/// Provides users with controls to create, edit, enable/disable, and remove
/// personalized affirmation messages used by the notification system
class ManageAffirmationsPage extends ConsumerStatefulWidget {
  const ManageAffirmationsPage({super.key});

  @override
  ConsumerState<ManageAffirmationsPage> createState() => _ManageAffirmationsPageState();
}

class _ManageAffirmationsPageState extends ConsumerState<ManageAffirmationsPage> {
  // Cached affirmation list displayed by the UI.
  // Data is loaded from local Isar storage during initialization
  List<Affirmation> _affirmations = [];
  // Prevents rendering incomplete data while asynchronous database loading occurs
  bool _isLoading = true;
  // Shared local database instance provided through Riverpod dependency injection
  late final Isar _isar = ref.read(isarProvider);

  @override
  void initState() {
    super.initState();
    _loadAffirmations();
  }

  /// Loads affirmation records from local storage.
  Future<void> _loadAffirmations() async {
    final list = await _isar.affirmations.where().sortByCreatedAtDesc().findAll();
    setState(() {
      _affirmations = list;
      _isLoading = false;
    });
  }

  /// Creates a new affirmation or updates an existing one
  Future<void> _saveAffirmation(String text, [Affirmation? existing]) async {
    if (text.trim().isEmpty) return;
    await _isar.writeTxn(() async {
      final item = existing ?? (Affirmation()..createdAt = DateTime.now());
      item.text = text.trim();
      item.isEnabled = existing?.isEnabled ?? true;
      item.isShown = false;
      await _isar.affirmations.put(item);
    });
    _loadAffirmations();
  }

  /// Toggles whether an affirmation is available for notification delivery
  Future<void> _toggleAffirmation(Affirmation item) async {
    await _isar.writeTxn(() async {
      item.isEnabled = !item.isEnabled;
      await _isar.affirmations.put(item);
    });
    _loadAffirmations();
  }

  /// Permanently removes an affirmation from local storage.
  Future<void> _deleteAffirmation(Affirmation item) async {
    await _isar.writeTxn(() async => await _isar.affirmations.delete(item.id));
    _loadAffirmations();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.foregroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Manage Affirmations', style: TextStyle(color: theme.foregroundColor, fontWeight: FontWeight.w700, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.add_rounded, color: theme.foregroundColor), onPressed: () => _showDialog()),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [theme.topColor, theme.bottomColor])),
        child: SafeArea(
          child: _isLoading
              ? Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(theme.accentColor)))
              : _affirmations.isEmpty
                  ? Center(child: Text('No affirmations yet', style: TextStyle(color: theme.foregroundColor.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.w600)))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      itemCount: _affirmations.length,
                      itemBuilder: (context, index) {
                        final item = _affirmations[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.foregroundColor.withOpacity(0.04))),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(item.text, style: TextStyle(color: item.isEnabled ? theme.foregroundColor : theme.foregroundColor.withOpacity(0.4), fontSize: 14, fontWeight: FontWeight.w500, decoration: item.isEnabled ? TextDecoration.none : TextDecoration.lineThrough)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch.adaptive(activeColor: theme.accentColor, value: item.isEnabled, onChanged: (_) => _toggleAffirmation(item)),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert_rounded, color: theme.foregroundColor.withOpacity(0.4)),
                                  onSelected: (val) => val == 'edit' ? _showDialog(existing: item) : _deleteAffirmation(item),
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }

  void _showDialog({Affirmation? existing}) {
    final controller = TextEditingController(text: existing?.text ?? '');
    final theme = ref.read(appThemeProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(existing == null ? 'New Affirmation' : 'Edit Affirmation', style: TextStyle(color: theme.foregroundColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 3,
                autofocus: true,
                style: TextStyle(color: theme.foregroundColor),
                decoration: InputDecoration(
                  hintText: 'Type your gentle reminder here...',
                  hintStyle: TextStyle(color: theme.foregroundColor.withOpacity(0.3)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.foregroundColor.withOpacity(0.1)), borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.accentColor), borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: theme.accentColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                onPressed: () {
                  _saveAffirmation(controller.text, existing);
                  Navigator.pop(ctx);
                },
                child: const Text('Save Affirmation', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}