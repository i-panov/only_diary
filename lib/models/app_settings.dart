import 'package:hive/hive.dart';
import 'package:only_diary/app_config.dart';

part 'app_settings.g.dart';

@HiveType(typeId: AppHiveTypes.appSettings)
class AppSettings extends HiveObject {
  @HiveField(0)
  String lastPath;

  @HiveField(1)
  Map<String, DateTime> synchronizations; // provider : sync time

  AppSettings({
    required this.lastPath,
    required this.synchronizations,
  });

  static const boxName = 'app_settings';

  static Box<AppSettings> get openedBox => Hive.box<AppSettings>(boxName);
}
