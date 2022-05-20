import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:io_extends/io_extends.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:only_diary/extensions/datetime_extensions.dart';
import 'package:only_diary/models/diary_entry.dart';

class DiaryStorage {
  static const signature = 'only_diary';

  final DiaryMetaInfo metaInfo;

  DateTime _updatedAt;
  DateTime get updatedAt => _updatedAt;

  final List<DiaryEntry> _entries;
  UnmodifiableListView get entries => UnmodifiableListView(_entries);

  DiaryEntry? get todayEntry => _entries.firstWhereOrNull((e) => DateUtils.isSameDay(e.date, DateTime.now()));

  DiaryStorage._(this.metaInfo, {
    required DateTime updatedAt,
    required List<DiaryEntry> entries,
  }): _updatedAt = updatedAt, _entries = entries;

  static Future<DiaryStorage> load({
    required String path,
    required String password,
  }) async {
    final metaInfo = DiaryMetaInfo(path: path, password: password);
    final reader = MemoryReader(await metaInfo.decrypt());

    if (reader.readString(signature.length) != signature) {
      throw FormatException('invalid signature', path, 0);
    }

    final updatedAt = reader.readDateTime();
    final count = reader.readUint32();
    final entries = Iterable.generate(count, (_) => DiaryEntry.read(reader)).toList();
    return DiaryStorage._(metaInfo, updatedAt: updatedAt, entries: entries);
  }

  Future<void> setEntry(DiaryEntry entry) async {
    if (entry.date.isAfter(DateTime.now().tomorrow.date)) {
      throw ArgumentError.value(entry.date, 'entry.date', 'Entry in future');
    }

    if (DateUtils.isSameDay(entry.date, DateTime.now())) {
      final _todayEntry = todayEntry;
    }

    // todo: поиск и обновление записи, либо добавление сегодняшней записи

    _updatedAt = DateTime.now();
    await metaInfo.encrypt(_serialize());;
  }

  // Future<void> save() => metaInfo.encrypt(_serialize());

  Uint8List _serialize() {
    final writer = MemoryWriter();
    writer.writeString(signature);
    writer.writeDateTime(updatedAt);
    writer.writeUint32(entries.length);
    entries.forEach((e) => e.write(writer));
    return writer.bytes;
  }
}

class DiaryMetaInfo {
  final String path;
  final AesCrypt _crypt;

  DiaryMetaInfo({
    required this.path,
    required String password,
  }): _crypt = AesCrypt(password) {
    _crypt.setOverwriteMode(AesCryptOwMode.on);
  }

  Future<Uint8List> decrypt() => _crypt.decryptDataFromFile(path);

  Future<String> encrypt(Uint8List data) => _crypt.encryptDataToFile(data, path);
}
