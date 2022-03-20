import 'package:flutter/material.dart';
import 'package:only_diary/app_config.dart';
import 'package:only_diary/models/app_settings.dart';
import 'package:only_diary/ui/screens/lock_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(appName);
  Hive.registerAdapter(AppSettingsAdapter());
  await Hive.openBox<AppSettings>(AppSettings.boxName);
  runApp(OnlyDiaryApp());
}

class OnlyDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LockScreen(),
    );
  }
}
