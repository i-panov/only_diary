import 'package:io_extends/io_extends.dart';

class DiaryEntry {
  final DateTime date;
  final int mood;
  final String text;

  DiaryEntry({
    required this.date,
    required this.mood,
    required this.text,
  }) {
    if (mood < 0 || mood > 10) {
      throw ArgumentError.value(mood, 'mood');
    }
  }

  factory DiaryEntry.read(Reader reader) => DiaryEntry(
    date: reader.readDateTime(),
    mood: reader.readUint8(),
    text: reader.readString(reader.readUint32()),
  );

  void write(Writer writer) => writer
    ..writeDateTime(date)
    ..writeUint8(mood)
    ..writeUint32(text.length)
    ..writeString(text);
}
