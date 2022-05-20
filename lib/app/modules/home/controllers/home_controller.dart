import 'dart:convert';

import 'package:erixquran/app/constant/endpoints.dart';
import 'package:erixquran/app/data/models/juz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/surah.dart';

class HomeController extends GetxController {
  RxBool isDark = false.obs;
  List<Surah> allSurah = [];
  Future<List<Surah>> getAllSurah() async {
    var res = await http.get(Uri.parse(Endpoint.getSurahUrl));
    List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];
    if (data.isEmpty) {
      return [];
    }
    allSurah = data.map((e) => Surah.fromJson(e)).toList();
    return allSurah;
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> allJuz = [];
    for (int i = 1; i <= 30; i++) {
      var res = await http.get(Uri.parse(Endpoint.getDetailJuzUrl + "$i"));
      Map<String, dynamic> data =
          (jsonDecode(res.body) as Map<String, dynamic>)["data"];
      Juz juz = Juz.fromJson(data);
      allJuz.add(juz);
    }
    return allJuz;
  }
}
