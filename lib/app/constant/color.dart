import 'package:flutter/material.dart';

const appPurplue = Color(0XFF431AA1);
const appPurplueDark = Color(0XFF1E0771);
const appPurplueLight1 = Color(0XFF9345F2);
const appPurplueLight2 = Color(0XFFB9A2DB);
const appWhite = Color(0XFFFFFFFF);
const appBlack = Color(0XFF000000);
const appOrange = Color(0XFFE6704A);
const appGrey = Colors.grey;

ThemeData lightTheme = ThemeData(
  primaryColor: appPurplue,
  scaffoldBackgroundColor: appWhite,
  appBarTheme: AppBarTheme(backgroundColor: appPurplue),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: appPurplueDark),
    bodyText2: TextStyle(color: appPurplueDark),
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: appPurplueLight2,
  scaffoldBackgroundColor: appPurplueDark,
  appBarTheme: AppBarTheme(backgroundColor: appPurplueDark),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: appWhite),
    bodyText2: TextStyle(color: appWhite),
  ),
);
