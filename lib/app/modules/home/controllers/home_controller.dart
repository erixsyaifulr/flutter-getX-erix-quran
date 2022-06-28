import 'dart:convert';

import 'package:erixquran/app/constant/endpoints.dart';
import 'package:erixquran/app/data/db/bookmart.dart';
import 'package:erixquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../../constant/colors.dart';
import '../../../data/models/surah.dart';

class HomeController extends GetxController {
  RxBool isDark = false.obs;
  List<Surah> allSurah = [];
  DatabaseManager database = DatabaseManager.instance;

  void changeTheme() {
    Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme);
    isDark.toggle();
    final box = GetStorage();
    if (Get.isDarkMode)
      box.remove("themeDark");
    else
      box.write("themeDark", true);
  }

  Future<List<Surah>> getAllSurah() async {
    var res = await http.get(Uri.parse(Endpoint.getSurahUrl));
    List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];
    if (data.isEmpty) {
      return [];
    }
    allSurah = data.map((e) => Surah.fromJson(e)).toList();
    return allSurah;
  }

  Future<List<Map<String, dynamic>>> getAllJuz() async {
    int juz = 1;
    List<Map<String, dynamic>> arrayOfVerse = [];
    List<Map<String, dynamic>> allJuz = [];

    for (int i = 1; i <= 144; i++) {
      var res = await http.get(Uri.parse(Endpoint.getSurahUrl + "/$i"));
      Map<String, dynamic> rawData = jsonDecode(res.body)["data"];
      DetailSurah data = DetailSurah.fromJson(rawData);
      if (data.verses != null) {
        data.verses!.forEach((element) {
          if (element.meta?.juz == juz) {
            arrayOfVerse.add({
              "surah": data,
              "verse": element,
            });
          } else {
            allJuz.add({
              "juz": juz,
              "start": arrayOfVerse[0],
              "end": arrayOfVerse[arrayOfVerse.length - 1],
              "verses": arrayOfVerse,
            });
            juz++;
            arrayOfVerse = [];
            arrayOfVerse.add({
              "surah": data,
              "verse": element,
            });
          }
        });
      }
    }

    allJuz.add({
      "juz": juz,
      "start": arrayOfVerse[0],
      "end": arrayOfVerse[arrayOfVerse.length - 1],
      "verses": arrayOfVerse,
    });

    return allJuz;
  }

  Future<List<Map<String, dynamic>>> getBookMark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmark =
        await db.query("bookmark", where: "last_read = 0");
    return allBookmark;
  }

  void deleteBookMark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");
    update();
    Get.snackbar("Berhasil", "Bookmark telah dihapus");
  }
}
