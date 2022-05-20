import 'dart:convert';

import 'package:erixquran/app/constant/endpoints.dart';
import 'package:erixquran/app/data/models/detail_ayat.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DetailAyatController extends GetxController {
  Future<DetailAyat> getDetailSurah(String id, String ayat) async {
    var res = await http.get(Uri.parse(Endpoint.getSurahUrl + "/$id/$ayat"));
    Map<String, dynamic> data =
        (jsonDecode(res.body) as Map<String, dynamic>)["data"];
    return DetailAyat.fromJson(data);
  }
}
