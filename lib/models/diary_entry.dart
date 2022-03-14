import 'package:io_extends/io_extends.dart';

class DiaryEntry {
  final DateTime time;
  final int mood;
  final String text;

  DiaryEntry({
    required this.time,
    required this.mood,
    required this.text,
  }) {
    if (mood < 0 || mood > 10) {
      throw ArgumentError.value(mood, 'mood');
    }
  }

  factory DiaryEntry.read(Reader reader) => DiaryEntry(
    time: reader.readDateTime(),
    mood: reader.readUint8(),
    text: reader.readString(reader.readUint32()),
  );

  void write(Writer writer) => writer
    ..writeDateTime(time)
    ..writeUint8(mood)
    ..writeUint32(text.length)
    ..writeString(text);
}
