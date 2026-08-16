import 'package:isar/isar.dart';

part 'notification_models.g.dart';

/// Data models for the affirmation notification feature.
///
/// This file defines the persistent database schemas used to store:
/// - User-created affirmation content.
/// - Notification preferences and scheduling configuration.

@collection
class Affirmation {
  Id id = Isar.autoIncrement;

  late String text;
  late DateTime createdAt;

  @Index()
  bool isEnabled = true;

  @Index()
  bool isShown = false; 
}

@collection
class NotificationSettings {
  Id id = 0; 

  bool enabled = false;

  int dailyFrequency = 3; 

  // Represented as minutes from midnight
  int quietHoursStart = 1320; 
  int quietHoursEnd = 480;
}