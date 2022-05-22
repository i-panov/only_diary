import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:io_extends/io_extends.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:only_diary/models/diary_entry.dart';

class DiaryStorage {
  static const signature = 'only_diary';

  final DiaryMetaInfo metaInfo;

  DateTime _updatedAt;
  DateTime get updatedAt => _updatedAt;

  final List<DiaryEntry> _entries;
  UnmodifiableListView get entries => UnmodifiableListView(_entries);

  int get todayEntryIndex => _entries.indexWhere((e) => DateUtils.isSameDay(e.date, DateTime.now()));

  DiaryEntry? get todayEntry {
    final index = todayEntryIndex;
    return index < 0 ? null : _entries[index];
  }

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

  /// Редактировать можно только текущий день.
  /// Если для него не создана запись то она автоматически создастся.
  Future<void> setCurrentDay({required int mood, required String text}) async {
    final entry = DiaryEntry(date: DateTime.now(), mood: mood, text: text);
    final index = todayEntryIndex;

    if (index < 0) {
      _entries.add(entry);
    } else {
      _entries[index] = entry;
    }

    await save();
  }

  /// Можно удалить любую запись по дню.
  Future<void> removeEntry(DateTime date) async {
    _entries.removeWhere((e) => DateUtils.isSameDay(e.date, date));
    await save();
  }

  Future<void> save() async {
    _updatedAt = DateTime.now();
    await metaInfo.encrypt(_serialize());
  }

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
