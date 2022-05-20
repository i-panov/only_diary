import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:only_diary/app_config.dart';
import 'package:path_provider/path_provider.dart';

class LockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //getApplicationDocumentsDirectory().then((v) => print(v));

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                label: Text('Пароль'),
                prefixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {},
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.lock_open),
                  tooltip: 'Открыть дневник',
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('Выбрать другой дневник'),
                  onPressed: () {
                    FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: [appExt],
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Создать новый дневник'),
                  onPressed: () {
                    FilePicker.platform.saveFile(
                      type: FileType.custom,
                      allowedExtensions: [appExt],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
