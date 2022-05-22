import 'package:hive/hive.dart';
import 'package:only_diary/app_config.dart';

part 'app_settings.g.dart';

enum ProviderType { file }

@HiveType(typeId: AppHiveTypes.appSettings)
class AppSettings extends HiveObject {
  @HiveField(0)
  String? lastPath;

  @HiveField(1)
  Map<ProviderType, DateTime> synchronizations; // provider : sync time

  AppSettings({
    this.lastPath,
    Map<ProviderType, DateTime>? synchronizations,
  }): synchronizations = synchronizations ?? Map();

  static const boxName = 'app_settings';
  static const defaultBoxKey = 'default';

  static Box<AppSettings> get openedBox => Hive.box<AppSettings>(boxName);

  static AppSettings get current => openedBox.get(defaultBoxKey) ?? AppSettings();
}
