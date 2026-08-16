import 'package:flutter/material.dart';
import 'tools_page.dart';
import 'package:cptsd_app/pages/inner_studio/sticker_book.dart';

// This file implements the settings panel for the Tools page.
//
// The settings view allows users to personalise their experience by
// changing display themes, layouts, grouping methods, and individual
// tool preferences.
class ToolsSettingsView extends StatelessWidget {
  final dynamic currentTheme;
  final bool isCategorized;
  final LayoutType currentLayout;
  final Map<String, ToolMetaConfig> toolsRegistry;

  final ValueChanged<bool> onCategorizedChanged;
  final ValueChanged<LayoutType> onLayoutChanged;
  final Function(String) onThemeChanged;
  final Function(String toolKey, bool isActive, bool isPinned, String? customIconPath) onToolConfigUpdated;

  const ToolsSettingsView({
    super.key,
    required this.currentTheme,
    required this.isCategorized,
    required this.currentLayout,
    required this.toolsRegistry,
    required this.onCategorizedChanged,
    required this.onLayoutChanged,
    required this.onThemeChanged,
    required this.onToolConfigUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = currentTheme.isDarkMode == true;
    final Color foreground = isDark ? Colors.white : const Color(0xFF211F1F);
    final Color subtitleColor = isDark ? Colors.white60 : Colors.black38;
    final Color surfaceColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA);
    final Color accent = currentTheme.accentColor ?? const Color(0xFF757575);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(color: surfaceColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 8),
          Text('Customization', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: foreground)),
          const SizedBox(height: 20),

          // Allows users to switch between light and dark appearance modes
          Text('DISPLAY MODE', style: TextStyle(fontSize: 11, color: subtitleColor, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildModeTab("Cloud (Default)", !isDark, () => onThemeChanged("Cloud"), foreground, accent, subtitleColor, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildModeTab("Midnight (Dark)", isDark, () => onThemeChanged("Midnight"), foreground, accent, subtitleColor, isDark)),
            ],
          ),
          const SizedBox(height: 24),

          // Allows users to select different accent colours
          // to personalise the visual appearance of the application.
          Text('COLOR SCHEME', style: TextStyle(fontSize: 11, color: subtitleColor, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildThemeBubble("Lavender", const Color(0xFFDFD1F4), foreground, isDark),
              _buildThemeBubble("Ocean", const Color(0xFFC5E5F3), foreground, isDark),
              _buildThemeBubble("Rose", const Color(0xFFF4D1DC), foreground, isDark),
              _buildThemeBubble("Forest", const Color(0xFFD5E8D4), foreground, isDark),
            ],
          ),
          const SizedBox(height: 24),

          // Users can choose different layouts and decide whether
          // tools should be grouped into therapeutic categories.
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showLayoutSubMenu(context, surfaceColor, foreground),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Icon(Icons.dashboard_customize_outlined, color: accent, size: 22),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Layout Style', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: foreground)),
                            Text(currentLayout.name.toUpperCase(), style: TextStyle(fontSize: 11, color: subtitleColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Grouping', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: foreground)),
                          Text('By context', style: TextStyle(fontSize: 11, color: subtitleColor)),
                        ],
                      ),
                      Switch.adaptive(value: isCategorized, activeColor: accent, onChanged: onCategorizedChanged),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Users can disable unused tools, pin frequently accessed tools,
          // or customise tool icons through the sticker selection feature.
          Text('MANAGE APPLICATION SUB-TOOLS', style: TextStyle(fontSize: 11, color: subtitleColor, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: toolsRegistry.entries.map((entry) => _buildToolRow(context, entry.key, entry.value, foreground, subtitleColor, accent, isDark)).toList(),
            ),
          ),
        ],
      ),
    );
  }

// Creates a selectable button for switching between
// different display modes.
  Widget _buildModeTab(String label, bool isSelected, VoidCallback onTap, Color foreground, Color accent, Color subtitleColor, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? accent : (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8F9FA)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? Colors.transparent : subtitleColor.withOpacity(0.2)),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : foreground)),
      ),
    );
  }

  // Creates a circular colour selector used for changing
  // the application's accent colour.
  Widget _buildThemeBubble(String name, Color color, Color foreground, bool isDark) {
    bool isActive = currentTheme.accentName == name;
    return GestureDetector(
      onTap: () => onThemeChanged(name),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: isActive ? (isDark ? Colors.white : Colors.black87) : Colors.transparent, width: 2.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: foreground)),
        ],
      ),
    );
  }

// Each row provides controls for enabling/disabling the tool,
// pinning it for quick access, and changing its icon
  Widget _buildToolRow(BuildContext context, String name, ToolMetaConfig config, Color foreground, Color subtitleColor, Color accent, bool isDark) {
    final bool hasCustomIcon = config.customIconPath?.isNotEmpty ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w500, color: config.isActive ? foreground : subtitleColor))),
          if (config.isActive)
            IconButton(
              icon: Icon(Icons.add_photo_alternate_outlined, size: 18, color: accent),
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const StickerBook(isSelectionMode: true)));
                if (result is String) onToolConfigUpdated(name, config.isActive, config.isPinned, result);
              },
            ),
          if (config.isActive && hasCustomIcon)
            IconButton(
              icon: const Icon(Icons.restart_alt_rounded, size: 18, color: Colors.redAccent),
              onPressed: () => onToolConfigUpdated(name, config.isActive, config.isPinned, null),
            ),
          IconButton(
            icon: Icon(config.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined, size: 18, color: config.isPinned ? accent : subtitleColor.withOpacity(0.5)),
            onPressed: config.isActive ? () => onToolConfigUpdated(name, config.isActive, !config.isPinned, config.customIconPath) : null,
          ),
          Switch.adaptive(
            value: config.isActive,
            activeColor: accent,
            onChanged: (val) => onToolConfigUpdated(name, val, val ? config.isPinned : false, config.customIconPath),
          ),
        ],
      ),
    );
  }

  // Displays available layout options in a separate
// bottom sheet to keep the main settings page simple.
  void _showLayoutSubMenu(BuildContext context, Color surfaceColor, Color foreground) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.list, color: foreground),
              title: Text("Single Column (List)", style: TextStyle(color: foreground)),
              onTap: () { onLayoutChanged(LayoutType.list); Navigator.pop(context); },
            ),
            ListTile(
              leading: Icon(Icons.grid_view, color: foreground),
              title: Text("Grid Cards Layout", style: TextStyle(color: foreground)),
              onTap: () { onLayoutChanged(LayoutType.grid); Navigator.pop(context); },
            ),
            ListTile(
              leading: Icon(Icons.blur_circular, color: foreground),
              title: Text("Geometric Wheel Layout", style: TextStyle(color: foreground)),
              onTap: () { onLayoutChanged(LayoutType.geometric); Navigator.pop(context); },
            ),
          ],
        ),
      ),
    );
  }
}