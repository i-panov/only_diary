import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  DateTime get date => DateUtils.dateOnly(this);

  DateTime get tomorrow => DateUtils.addDaysToDate(this, 1);
}
