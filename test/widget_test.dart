import 'dart:convert';

import 'package:erixquran/app/data/models/surah.dart';
import 'package:http/http.dart' as http;

void main() async {
  var res = await http.get(Uri.parse("https://api.quran.sutanlab.id/surah"));
  print(res.body);
  List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];

  Surah surah = Surah.fromJson(data[0]);
}
