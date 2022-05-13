import 'dart:convert';

import 'package:erixquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DetailSurahController extends GetxController {
  Future<DetailSurah> getDetailSurah(String id) async {
    var res =
        await http.get(Uri.parse("https://api.quran.sutanlab.id/surah/$id"));
    Map<String, dynamic> data =
        (jsonDecode(res.body) as Map<String, dynamic>)["data"];
    return DetailSurah.fromJson(data);
  }
}
