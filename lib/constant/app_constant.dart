import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._privateConstructor();
  static final AppConstants _instance = AppConstants._privateConstructor();
  static AppConstants get instance => _instance;

  final title = const TextStyle(
    fontFamily: 'Gugi',
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  final contentF = const TextStyle(
    fontFamily: '나눔고딕',
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  final primaryColor = const Color(0xFFFFA463);
}
