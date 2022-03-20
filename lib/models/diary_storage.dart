import 'dart:typed_data';
import 'package:io_extends/io_extends.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:only_diary/models/diary_entry.dart';

class DiaryStorage {
  static const signature = 'only_diary';

  final DateTime updatedAt;
  final List<DiaryEntry> entries;

  DiaryStorage({
    required this.updatedAt,
    required this.entries,
  });

  static Future<DiaryStorage> load({
    required String path,
    required String password,
  }) async {
    final crypt = AesCrypt(password);
    final reader = MemoryReader(await crypt.decryptDataFromFile(path));

    if (reader.readString(signature.length) != signature) {
      throw FormatException('invalid format', path, 0);
    }

    final updatedAt = reader.readDateTime();
    final count = reader.readUint32();
    final entries = Iterable.generate(count, (_) => DiaryEntry.read(reader)).toList();
    return DiaryStorage(updatedAt: updatedAt, entries: entries);
  }

  Future<void> save({
    required String path,
    required String password,
  }) async {
    final crypt = AesCrypt(password);
    crypt.setOverwriteMode(AesCryptOwMode.on);
    await crypt.encryptDataToFile(serialize(), path);
  }

  Uint8List serialize() {
    final writer = MemoryWriter();
    writer.writeString(signature);
    writer.writeDateTime(updatedAt);
    writer.writeUint32(entries.length);
    entries.forEach((e) => e.write(writer));
    return writer.bytes;
  }
}
