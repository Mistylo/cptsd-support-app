import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inner_studio_models.dart'; 
import 'inner_studio_provider.dart';

// Helper functions for displaying sticker images and managing sticker dialogs
// Handles both built in assets and user-created sticker files
Widget buildSafeStickerImage(UnlockedSticker sticker, {double? height}) {
  final file = File(sticker.imagePath);
  if (sticker.isCustom == true && file.existsSync()) {
    return Image.file(file, fit: BoxFit.contain, height: height, errorBuilder: (_, __, ___) => _missingAsset(height));
  }
  if (sticker.isCustom != true) {
    return Image.asset(sticker.imagePath, fit: BoxFit.contain, height: height, errorBuilder: (_, __, ___) => _missingAsset(height));
  }
  return _missingAsset(height);
}

Widget _missingAsset(double? height) => Container(
  height: height,
  alignment: Alignment.center,
  color: Colors.grey[100],
  child: Icon(Icons.broken_image_rounded, color: Colors.grey[400], size: height != null ? height * 0.3 : 24),
);

// Shows confirmation before deleting a sticker from the collection
void showDeletionDialog(BuildContext context, WidgetRef ref, UnlockedSticker sticker) {
  final message = sticker.isCustom == true
      ? "Are you sure? This action cannot be undone. If you want it back, you will have to re-upload it."
      : "Are you sure? After deleting this historical milestone item, you will not be able to automatically unlock or generate it again.";

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Confirm Asset Deletion", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: Text(message, style: const TextStyle(fontSize: 13, height: 1.4)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
        TextButton(
          onPressed: () async {
            await ref.read(studioProvider.notifier).deleteSticker(sticker.id);
            if (ctx.mounted) {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Sticker permanently removed from library database.")),
              );
            }
          },
          child: const Text("Permanently Erase", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

// Displays detailed information about a selected sticker
void showStickerDetails(BuildContext context, WidgetRef ref, UnlockedSticker sticker) {
  String desc = sticker.isCustom == true
      ? "A personalized token created from your custom media gallery files."
      : sticker.isMilestone == true
          ? "You've unlocked this sticker by doing active training sessions! You are a master of it now."
          : "You've unlocked this sticker with dedicated times of practices with our interactive emotional processing tools.";

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(sticker.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF262626)), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Container(
            height: 140,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFDFBFE), borderRadius: BorderRadius.circular(16)),
            child: buildSafeStickerImage(sticker),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: sticker.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF262626).withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: Text(tag.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF262626))),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
          const SizedBox(height: 12),
          const Text("You can now use this souvenir inside your Journal logs or modify your active tools dashboard presentation profiles with this token.",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.3)),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("Close", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[50], elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            Navigator.pop(dialogContext);
            showDeletionDialog(context, ref, sticker);
          },
          child: const Text("Delete Asset", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

// Main sticker collection page
// Allows users to view, filter, sort and select unlocked stickers
class StickerBook extends ConsumerStatefulWidget {
  final bool isSelectionMode;
  const StickerBook({super.key, this.isSelectionMode = false});

  @override
  ConsumerState<StickerBook> createState() => _StickerBookState();
}

class _StickerBookState extends ConsumerState<StickerBook> {
  bool _sortNewestToOldest = true;
  final Map<String, bool> _selectedTags = {'Milestone': true, 'Progression': true, 'Custom': true};

  @override
  Widget build(BuildContext context) {
    final studioState = ref.watch(studioProvider);
    
    // Process and filter stickers cleanly
    final processedList = studioState.collectedStickers.where((sticker) {
      return sticker.tags.any((tag) {
        final clean = tag.trim();
        if (clean.isEmpty) return false;
        final normalized = clean[0].toUpperCase() + (clean.length > 1 ? clean.substring(1).toLowerCase() : "");
        return _selectedTags[normalized] == true;
      });
    }).toList()
      ..sort((a, b) => _sortNewestToOldest ? b.unlockedAt.compareTo(a.unlockedAt) : a.unlockedAt.compareTo(b.unlockedAt));

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFE),
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? "Select Custom Icon" : "Sticker Collection", 
          style: const TextStyle(color: Color(0xFF262626), fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF262626)),
      ),
      body: Column(
        children: [
          // Filter & Sorting Control Header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Timeline Order:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    DropdownButton<bool>(
                      value: _sortNewestToOldest,
                      underline: const SizedBox(),
                      style: const TextStyle(fontSize: 12, color: Color(0xFF262626), fontWeight: FontWeight.bold),
                      items: const [
                        DropdownMenuItem(value: true, child: Text("Newest ➔ Oldest")),
                        DropdownMenuItem(value: false, child: Text("Oldest ➔ Newest")),
                      ],
                      onChanged: (val) => val != null ? setState(() => _sortNewestToOldest = val) : null,
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _selectedTags.keys.map((key) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _selectedTags[key],
                        activeColor: const Color(0xFF262626),
                        onChanged: (val) => val != null ? setState(() => _selectedTags[key] = val) : null,
                      ),
                      Text(key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  )).toList(),
                ),
              ],
            ),
          ),
          // Grid Content Body
          Expanded(
            child: processedList.isEmpty
                ? Center(child: Text("No structural souvenirs match selected matrix values.", style: TextStyle(color: Colors.grey[400], fontSize: 12)))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.85,
                    ),
                    itemCount: processedList.length,
                    itemBuilder: (context, index) {
                      final sticker = processedList[index];
                      return GestureDetector(
                        onTap: () => widget.isSelectionMode 
                            ? Navigator.pop(context, sticker.imagePath) 
                            : showStickerDetails(context, ref, sticker),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: buildSafeStickerImage(sticker),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
                                child: Text(
                                  sticker.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF262626)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}