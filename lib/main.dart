import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:only_diary/ui/screens/lock_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();

  /*const password = 'password';
  final passwordBytes = Uint8List.fromList(password.codeUnits);

  final box = await Hive.openBox('test', encryptionCipher: HiveAesCipher(password.codeUnits));
  box.put('test', 123);*/

  /*final dir = await getApplicationDocumentsDirectory();
  print(dir.path);

  var crypt = AesCrypt('pass');
  crypt.setOverwriteMode(AesCryptOwMode.on);

  final path = crypt.encryptTextToFileSync('test', dir.path + '/test');
  print(path);

  crypt = AesCrypt('1234');
  crypt.setOverwriteMode(AesCryptOwMode.on);

  final text = crypt.decryptTextFromFileSync(path);
  print(text);*/


  /*final enc = crypt.aesEncrypt(Uint8List.fromList('test'.codeUnits));
  final dec = String.fromCharCodes(crypt.aesDecrypt(enc));
  print(dec);*/

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
