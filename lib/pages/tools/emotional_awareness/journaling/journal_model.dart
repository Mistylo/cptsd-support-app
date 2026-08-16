import 'package:isar/isar.dart';

part 'journal_model.g.dart';

/// Database model representing a user's creative journal entry.
/// 
/// Supports multiple journaling intervention formats through flexible
/// JSON content storage and preserves user selected visual
/// customizations for later reconstruction.
@collection
class JournalEntry {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String type; 
  
  late DateTime timestamp;
  
  String? title;

 // Stores user responses as serialized JSON to support different
  // journaling formats while maintaining a unified database model.
  late String contentJson;

  // Stylistic Customizations
  String fontFamily = 'Default'; 
  // Stored as integer value for database compatibility with Flutter Color.
  int backgroundColorValue = 0xFFFFFFFF; // Defaults to clean white paper
  // Optional background texture asset identifier for visual customization.
  String? backgroundPattern; 

  // Stores serialized sticker placement data for recreating
  // the user's customized journal canvas layout.
  String? placedStickersJson;
}