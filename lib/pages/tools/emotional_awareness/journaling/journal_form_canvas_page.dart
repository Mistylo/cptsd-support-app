import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'journal_model.dart';
import 'journal_provider.dart';
import 'package:cptsd_app/pages/inner_studio/sticker_book.dart'; 

// Journal form canvas page for creating, previewing, and editing journal entries
class JournalFormCanvasPage extends ConsumerStatefulWidget {
  final String journalType;
  final JournalEntry? existingEntry;

  const JournalFormCanvasPage({
    super.key,
    required this.journalType,
    this.existingEntry,
  });

  @override
  ConsumerState<JournalFormCanvasPage> createState() => _JournalFormCanvasPageState();
}

class _JournalFormCanvasPageState extends ConsumerState<JournalFormCanvasPage> {
  // Controls journal creation, preview, and read only viewing states
  bool _isCanvasPreviewMode = false;
  bool _isReadOnlyView = false;
  bool _isFormValid = false; 

  // Text controllers for different journal formats
  final TextEditingController _freeTextController = TextEditingController();
  final TextEditingController _q1Controller = TextEditingController();
  final TextEditingController _q2Controller = TextEditingController();
  final TextEditingController _q3Controller = TextEditingController();

  // User selected visual customisation settings for the journal canvas
  String _selectedFont = 'Default';
  int _selectedColorValue = 0xFFFFFFFF;
  String? _selectedPattern;

  // Stores sticker placement data and the currently selected sticker
  List<Map<String, dynamic>> _placedStickers = [];
  int _selectedStickerIndex = -1; 

  final List<int> _paperColors = [
    0xFFFFFFFF,
    0xFFFFF9E6, 
    0xFFF0F4F8,
    0xFFEAFAF1, 
    0xFFF5EEF8, 
  ];

  final List<String> _fonts = ['Default', 'Serif', 'Monospace', 'Handwriting'];

  @override
  void initState() {
    super.initState();
    _freeTextController.addListener(_validateFormInputs);
    _q1Controller.addListener(_validateFormInputs);
    _q2Controller.addListener(_validateFormInputs);
    _q3Controller.addListener(_validateFormInputs);

    // Restore saved journal data when viewing or editing an existing entry
    if (widget.existingEntry != null) {
      _isReadOnlyView = true;
      _isCanvasPreviewMode = true; 
      _parseSavedEntryData(widget.existingEntry!);
    }
    _validateFormInputs();
  }

  void _validateFormInputs() {
    bool valid = false;
    if (widget.journalType == 'free_writing') {
      valid = _freeTextController.text.trim().isNotEmpty;
    } else {
      // Guided journals require completion of essential reflection prompts
      valid = _q1Controller.text.trim().isNotEmpty && _q3Controller.text.trim().isNotEmpty;
    }

    if (_isFormValid != valid) {
      setState(() {
        _isFormValid = valid;
      });
    }
  }

  // Restore saved content and canvas customisation settings into the editor
  void _parseSavedEntryData(JournalEntry entry) {
    _selectedFont = entry.fontFamily;
    _selectedColorValue = entry.backgroundColorValue;
    _selectedPattern = entry.backgroundPattern;

    if (entry.placedStickersJson != null) {
      _placedStickers = List<Map<String, dynamic>>.from(jsonDecode(entry.placedStickersJson!));
    }

    final content = jsonDecode(entry.contentJson) as Map<String, dynamic>;
    if (entry.type == 'free_writing') {
      _freeTextController.text = content['body'] ?? '';
    } else {
      _q1Controller.text = content['q1'] ?? '';
      _q2Controller.text = content['q2'] ?? '';
      _q3Controller.text = content['q3'] ?? '';
    }
  }
  
  // Convert current journal input into a JSON structure for storage
  Map<String, dynamic> _packageCurrentContent() {
    if (widget.journalType == 'free_writing') {
      return {'body': _freeTextController.text};
    } else {
      return {
        'q1': _q1Controller.text,
        'q2': _q2Controller.text,
        'q3': _q3Controller.text,
      };
    }
  }

  // Generate text styling based on the user's selected journal font
  TextStyle _getAppliedTextStyle({double fontSize = 15, Color color = Colors.black87}) {
    switch (_selectedFont) {
      case 'Serif':
        return TextStyle(fontFamily: 'Georgia', fontSize: fontSize, color: color, height: 1.5);
      case 'Monospace':
        return TextStyle(fontFamily: 'Courier', fontSize: fontSize - 1, color: color, height: 1.4);
      case 'Handwriting':
        return TextStyle(fontFamily: 'Caveat', fontSize: fontSize + 4, color: color, height: 1.2, fontWeight: FontWeight.w500);
      default:
        return TextStyle(fontSize: fontSize, color: color, height: 1.4);
    }
  }

  @override
  void dispose() {
    _freeTextController.removeListener(_validateFormInputs);
    _q1Controller.removeListener(_validateFormInputs);
    _q2Controller.removeListener(_validateFormInputs);
    _q3Controller.removeListener(_validateFormInputs);
    _freeTextController.dispose();
    _q1Controller.dispose();
    _q2Controller.dispose();
    _q3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = _getReadableTitle();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Color(0xFF262626), fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF262626)),
          onPressed: () {
            // Return from canvas preview before leaving the journal editor
            if (_isCanvasPreviewMode && !_isReadOnlyView) {
              setState(() => _isCanvasPreviewMode = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (_isReadOnlyView)
            IconButton(
              icon: const Icon(Icons.edit_note, size: 26, color: Color(0xFF262626)),
              tooltip: "Edit Journal",
              onPressed: () {
                setState(() {
                  _isReadOnlyView = false;
                  _isCanvasPreviewMode = false;
                });
              },
            )
          else if (_isCanvasPreviewMode)
            TextButton(
              onPressed: () {
                // Persist the completed journal entry with current canvas customisations
                ref.read(journalProvider.notifier).saveJournal(
                      id: widget.existingEntry?.id,
                      type: widget.journalType,
                      content: _packageCurrentContent(),
                      fontFamily: _selectedFont,
                      backgroundColor: _selectedColorValue,
                      backgroundPattern: _selectedPattern,
                      placedStickers: _placedStickers,
                    );
                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
        ],
      ),
      body: _isCanvasPreviewMode ? _buildCanvasCanvasView() : _buildInteractiveFormFields(),
    );
  }

  String _getReadableTitle() {
    switch (widget.journalType) {
      case 'free_writing': return 'Free Writing Journal';
      case 'moment_of_calm': return 'Moment of Calm';
      default: return 'Journal Entry';
    }
  }

  // Build input interface based on the selected journal type
  Widget _buildInteractiveFormFields() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.journalType == 'free_writing') ...[
            const Text("Use this space to freely express yourself. Write as much or as little as you would like.",
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
            const SizedBox(height: 20),
            TextField(
              controller: _freeTextController,
              maxLines: 15,
              decoration: InputDecoration(
                hintText: "Start writing here...",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ] else ...[
            _buildGuidedQuestionBlock(1, _getQuestionText(1), _q1Controller),
            const SizedBox(height: 20),
            _buildGuidedQuestionBlock(2, _getQuestionText(2), _q2Controller),
            const SizedBox(height: 20),
            _buildGuidedQuestionBlock(3, _getQuestionText(3), _q3Controller),
          ],
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid ? const Color.fromARGB(255, 226, 216, 228) : Colors.grey[300],
                foregroundColor: _isFormValid ? const Color.fromARGB(255, 82, 82, 82) : Colors.black38,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
              ),
              onPressed: _isFormValid 
                  ? () => setState(() => _isCanvasPreviewMode = true) 
                  : null, 
              child: const Text("Next: Decorate Canvas", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // Display an individual reflection prompt and response field
  Widget _buildGuidedQuestionBlock(int num, String question, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tap here to express...",
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  String _getQuestionText(int index) {
    if (index == 1) return "What made you feel calm, safe, or comfortable today?";
    if (index == 2) return "Where were you when this happened? (Optional)";
    return "How did this moment make you feel?";
  }

  // Render the editable journal canvas with text and decorative elements
  Widget _buildCanvasCanvasView() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _selectedStickerIndex = -1;
                      });
                    },
                    child: Container(
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: Color(_selectedColorValue),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: _buildCanvasTextContent(),
                          ),
                          ..._placedStickers.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final data = entry.value;

                            return _InteractiveSticker(
                              key: ValueKey(idx),
                              data: data,
                              isSelected: _selectedStickerIndex == idx && !_isReadOnlyView,
                              isReadOnly: _isReadOnlyView,
                              canvasWidth: constraints.maxWidth,
                              canvasHeight: constraints.maxHeight,
                              onSelect: () {
                                setState(() => _selectedStickerIndex = idx);
                              },
                              onDelete: () {
                                setState(() {
                                  _placedStickers.removeAt(idx);
                                  _selectedStickerIndex = -1;
                                });
                              },
                              onPositionUpdate: (dx, dy) {
                                setState(() {
                                  _placedStickers[idx]['dx'] = dx;
                                  _placedStickers[idx]['dy'] = dy;
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (!_isReadOnlyView) _buildCustomizationDocks(),
      ],
    );
  }

  Widget _buildCanvasTextContent() {
    if (widget.journalType == 'free_writing') {
      return Text(
        _freeTextController.text.isEmpty ? "Empty free writing canvas." : _freeTextController.text,
        style: _getAppliedTextStyle(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCanvasQABlock(_getQuestionText(1), _q1Controller.text),
        _buildCanvasQABlock(_getQuestionText(2), _q2Controller.text),
        _buildCanvasQABlock(_getQuestionText(3), _q3Controller.text),
      ],
    );
  }

  Widget _buildCanvasQABlock(String q, String a) {
    if (a.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q, style: _getAppliedTextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(a, style: _getAppliedTextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCustomizationDocks() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.text_fields, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _fonts.map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(f, style: const TextStyle(fontSize: 12)),
                          selected: _selectedFont == f,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedFont = f);
                          },
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.palette_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _paperColors.map((colorVal) => GestureDetector(
                        onTap: () => setState(() => _selectedColorValue = colorVal),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 32,
                          decoration: BoxDecoration(
                            color: Color(colorVal),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColorValue == colorVal ? const Color.fromARGB(255, 88, 83, 89) : Colors.grey[300]!,
                              width: _selectedColorValue == colorVal ? 2 : 1,
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                )
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.face_retouching_natural, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[50],
                      foregroundColor: const Color.fromARGB(255, 77, 73, 82),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.auto_stories_outlined, size: 18),
                    label: const Text("Open Sticker Book", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: () async {
                      final String? selectedStickerPath = await showModalBottomSheet<String>(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (BuildContext context) {
                          return const SizedBox(
                            height: 450,
                            child: StickerBook(isSelectionMode: true), 
                          );
                        },
                      );

                      if (selectedStickerPath != null) {
                        setState(() {
                          _placedStickers.add({
                            'imagePath': selectedStickerPath,
                            'dx': 0.4, 
                            'dy': 0.4,
                          });
                          _selectedStickerIndex = _placedStickers.length - 1;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A movable sticker overlay displayed on the journal canvas.
/// Supports positioning, selection, and deletion during editing mode.
class _InteractiveSticker extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isSelected;
  final bool isReadOnly;
  final double canvasWidth;
  final double canvasHeight;
  final VoidCallback onSelect;
  final VoidCallback onDelete;
  final Function(double dx, double dy) onPositionUpdate;

  const _InteractiveSticker({
    super.key,
    required this.data,
    required this.isSelected,
    required this.isReadOnly,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.onSelect,
    required this.onDelete,
    required this.onPositionUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final String path = data['imagePath'] ?? '';
    final bool isAssetPath = path.startsWith('assets/');

    double dx = (data['dx'] ?? 0.0).toDouble();
    double dy = (data['dy'] ?? 0.0).toDouble();

    return Positioned(
      left: dx * canvasWidth,
      top: dy * canvasHeight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSelect,
        onPanUpdate: isReadOnly
            ? null
            : (details) {
                onSelect();
                double newDx = dx + (details.delta.dx / canvasWidth);
                double newDy = dy + (details.delta.dy / canvasHeight);

                onPositionUpdate(
                  newDx.clamp(-0.1, 0.95),
                  newDy.clamp(-0.1, 0.95),
                );
              },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: isSelected
                    ? Border.all(color: const Color.fromARGB(255, 148, 135, 150).withOpacity(0.6), width: 1.5)
                    : Border.all(color: Colors.transparent, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: isAssetPath
                  ? Image.asset(
                      path,
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.stars, color: Color.fromARGB(255, 191, 178, 194), size: 48),
                    )
                  : Image.file(
                      File(path),
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image_rounded, color: Color.fromARGB(255, 29, 25, 25), size: 48),
                    ),
            ),
            if (isSelected)
              Positioned(
                right: -8,
                top: -8,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDelete,
                  child: Container(
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 97, 93, 92), shape: BoxShape.circle),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}