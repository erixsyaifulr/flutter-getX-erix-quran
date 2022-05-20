import 'package:erixquran/app/data/models/juz.dart' as juz;
import 'package:erixquran/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constant/colors.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final juz.Juz detailJuz = Get.arguments["juz"];
  final List<Surah> allSurahInJuz = Get.arguments["surah"];
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar() {
      return AppBar(
        title: Text('JUZ ${detailJuz.juz}'),
        centerTitle: true,
      );
    }

    Widget body() {
      return ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: detailJuz.verses?.length ?? 0,
        itemBuilder: (context, index) {
          if (detailJuz.verses?.length == 0) {
            return Center(
              child: Text('Tidak ada data'),
            );
          }
          juz.Verses verse = detailJuz.verses![index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: appPurplueLight2.withOpacity(0.15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/frame.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(child: Text("${verse.number?.inSurah}")),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.bookmark_add_outlined)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.play_arrow)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 10),
                child: Text(
                  "${verse.text!.arab}",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${verse.text!.transliteration!.en}",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${verse.translation!.id}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }
}
