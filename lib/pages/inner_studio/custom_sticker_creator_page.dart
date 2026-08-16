import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'inner_studio_provider.dart';

/// Available clipping shapes for transforming user selected images
/// into collectible custom sticker
enum CustomShape { original, circle, triangle, star, hexagon, heart, squircle }

class CustomStickerCreatorPage extends ConsumerStatefulWidget {
  const CustomStickerCreatorPage({super.key});

  @override
  ConsumerState<CustomStickerCreatorPage> createState() => _CustomStickerCreatorPageState();
}

class _CustomStickerCreatorPageState extends ConsumerState<CustomStickerCreatorPage> {
    // Stores the temporary user-selected image before sticker generation
  File? _pickedImage;
  // Controls the visual mask applied to the selected image
  CustomShape _selectedShape = CustomShape.original;
  // Used by RepaintBoundary to capture the final edited sticker as an image
  final GlobalKey _boundaryKey = GlobalKey();
  // Prevents duplicate save operations while image processing is running
  bool _isSaving = false;

  /// Opens the device gallery and allows the user to select an image.
  ///
  /// The image resolution is limited before loading into memory
  /// to reduce processing cost during sticker generation
  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 800, maxHeight: 800);
    if (image != null) setState(() => _pickedImage = File(image.path));
  }

  /// Captures the customized sticker preview as a PNG image,
  /// stores it locally, and registers it in the sticker collection.
  ///
  /// Workflow:
  /// 1. Capture widget rendering through RepaintBoundary.
  /// 2. Convert rendered output into PNG bytes.
  /// 3. Save image locally inside application documents storage.
  /// 4. Store metadata through StudioNotifier and Isar database
  Future<void> _saveCustomSticker() async {
    if (_pickedImage == null || _isSaving) return; // Avoid saving when no image exists or a previous save is processing
    setState(() => _isSaving = true);

    try {
       // Access the rendered widget area containing the clipped image
      final boundary = _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
       // Convert widget rendering into a high-resolution image
      final image = await boundary.toImage(pixelRatio: 3.0);
      // Encode image data into PNG format for local storage
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/custom_${DateTime.now().millisecondsSinceEpoch}.png';
      
      await File(path).writeAsBytes(byteData!.buffer.asUint8List());
      // Register sticker metadata inside the persistent sticker system
      await ref.read(studioProvider.notifier).awardSpecialSticker(
        name: "Custom Sticker", assetPath: path, tags: ['Custom'], isCustom: true,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sticker added to your book!")));
        Navigator.pop(context);
      }
    } finally {
      // Restore UI state regardless of success or failure
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFE),
      appBar: AppBar(
        title: const Text("Edit Sticker", style: TextStyle(color: Color(0xFF262626), fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF262626)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: _pickedImage == null
                  ? GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 220, height: 220,
                        decoration: const BoxDecoration(color: Color(0xFFF2F0F4), shape: BoxShape.circle),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 48, color: Color(0xFF262626)),
                            SizedBox(height: 8),
                            Text("Select Photo", style: TextStyle(color: Color(0xFF262626), fontSize: 13, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    )
                    // RepaintBoundary isolates this widget subtree,
                    // allowing the final sticker design to be exported
                    // independently from the surrounding UI
                  : RepaintBoundary(
                      key: _boundaryKey,
                      child: Container(
                        width: 220, height: 220, color: Colors.transparent,
                        child: ClipPath(
                          clipper: CreatorShapeClipper(_selectedShape),
                          child: InteractiveViewer(
                            boundaryMargin: const EdgeInsets.all(100),
                            minScale: 0.5, maxScale: 4.0, clipBehavior: Clip.none,
                            child: Image.file(_pickedImage!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (_pickedImage != null) ...[
            const Text("Pinch to zoom / Drag to position photo", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: CustomShape.values.length,
                itemBuilder: (context, index) {
                  final shape = CustomShape.values[index];
                  final isSelected = _selectedShape == shape;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(shape.name.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      selected: isSelected,
                      selectedColor: const Color(0xFF262626),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF262626)),
                      onSelected: (val) => setState(() => _selectedShape = shape),
                    ),
                  );
                },
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: _pickedImage == null || _isSaving ? null : _saveCustomSticker,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: const Color(0xFF262626),
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Bake & Save Custom Sticker", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom clipper responsible for converting the selected shape
/// into a Flutter Path object.
/// The generated path is used by ClipPath to mask the user's image
/// before exporting the final sticker
class CreatorShapeClipper extends CustomClipper<Path> {
  final CustomShape shape;
  CreatorShapeClipper(this.shape);

  // Generates different geometric paths depending on the selected
  // sticker shape while keeping the clipping logic independent
  // from UI components
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width, h = size.height;

    switch (shape) {
      case CustomShape.circle:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case CustomShape.triangle:
        path.moveTo(w / 2, 0);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        break;
      case CustomShape.star:
        double cx = w / 2, cy = h / 2, outer = w / 2, inner = w / 4, angle = -math.pi / 2;
        path.moveTo(cx + outer * math.cos(angle), cy + outer * math.sin(angle));
        for (int i = 0; i < 10; i++) {
          angle += math.pi / 5;
          path.lineTo(cx + (i % 2 == 0 ? inner : outer) * math.cos(angle), cy + (i % 2 == 0 ? inner : outer) * math.sin(angle));
        }
        path.close();
        break;
      case CustomShape.hexagon:
        path.moveTo(w * 0.5, 0);
        path.lineTo(w, h * 0.25);
        path.lineTo(w, h * 0.75);
        path.lineTo(w * 0.5, h);
        path.lineTo(0, h * 0.75);
        path.lineTo(0, h * 0.25);
        path.close();
        break;
      case CustomShape.heart:
        path.moveTo(w * 0.5, h * 0.25);
        path.cubicTo(w * 0.5, h * 0.22, w * 0.4, 0, w * 0.25, 0);
        path.cubicTo(w * 0.1, 0, 0, h * 0.15, 0, h * 0.4);
        path.cubicTo(0, h * 0.65, w * 0.4, h * 0.85, w * 0.5, h);
        path.cubicTo(w * 0.6, h * 0.85, w, h * 0.65, w, h * 0.4);
        path.cubicTo(w, h * 0.15, w * 0.9, 0, w * 0.75, 0);
        path.cubicTo(w * 0.6, 0, w * 0.5, h * 0.22, w * 0.5, h * 0.25);
        path.close();
        break;
      case CustomShape.squircle:
        path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(w * 0.3)));
        break;
      case CustomShape.original:
        path.addRect(Rect.fromLTWH(0, 0, w, h));
        break;
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CreatorShapeClipper oldClipper) => oldClipper.shape != shape;
}