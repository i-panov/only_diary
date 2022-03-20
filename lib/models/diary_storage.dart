import 'dart:typed_data';
import 'package:io_extends/io_extends.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:only_diary/models/diary_entry.dart';

class DiaryStorage {
  static const signature = 'only_diary';

  final _DiaryMetaInfo _metaInfo;
  final DateTime updatedAt;
  final List<DiaryEntry> entries;

  DiaryStorage._(this._metaInfo, {
    required this.updatedAt,
    required this.entries,
  });

  static Future<DiaryStorage> load({
    required String path,
    required String password,
  }) async {
    final metaInfo = _DiaryMetaInfo(path: path, password: password);
    final reader = MemoryReader(await metaInfo.decrypt());

    if (reader.readString(signature.length) != signature) {
      throw FormatException('invalid signature', path, 0);
    }

    final updatedAt = reader.readDateTime();
    final count = reader.readUint32();
    final entries = Iterable.generate(count, (_) => DiaryEntry.read(reader)).toList();
    return DiaryStorage._(metaInfo, updatedAt: updatedAt, entries: entries);
  }

  Future<void> save() => _metaInfo.encrypt(_serialize());

  Uint8List _serialize() {
    final writer = MemoryWriter();
    writer.writeString(signature);
    writer.writeDateTime(updatedAt);
    writer.writeUint32(entries.length);
    entries.forEach((e) => e.write(writer));
    return writer.bytes;
  }
}

class _DiaryMetaInfo {
  final String path;
  final AesCrypt crypt;

  _DiaryMetaInfo({
    required this.path,
    required String password,
  }): crypt = AesCrypt(password) {
    crypt.setOverwriteMode(AesCryptOwMode.on);
  }

  Future<Uint8List> decrypt() => crypt.decryptDataFromFile(path);

  Future<String> encrypt(Uint8List data) => crypt.encryptDataToFile(data, path);
}
