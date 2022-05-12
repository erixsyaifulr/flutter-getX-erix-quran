import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/surah.dart';

class HomeController extends GetxController {
  Future<List<Surah>> getAllSurah() async {
    var res = await http.get(Uri.parse("https://api.quran.sutanlab.id/surah"));
    List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];
    if (data.isEmpty) {
      return [];
    }
    return data.map((e) => Surah.fromJson(e)).toList();
  }
}
