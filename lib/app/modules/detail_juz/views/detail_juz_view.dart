import 'package:erixquran/app/data/models/detail_surah.dart' as detail;
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constant/colors.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final Map<String, dynamic> detailJuz = Get.arguments;
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar() {
      return AppBar(
        title: Text('JUZ ${detailJuz["juz"]}'),
        centerTitle: true,
      );
    }

    Widget surahInformation(
        Map<String, dynamic> verse, detail.DetailSurah surah) {
      return GestureDetector(
        onTap: () {
          Get.defaultDialog(
            title: "Tafsir",
            content: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                "${surah.tafsir!.id ?? 'Tafsir tidak tersedia'}",
                textAlign: TextAlign.justify,
              ),
            ),
          );
        },
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                appPurplueLight1,
                appPurplueDark,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "${surah.name!.transliteration!.id?.toUpperCase()}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: appWhite),
                ),
                SizedBox(height: 5),
                Text(
                  "( ${surah.name!.translation!.id?.toUpperCase()} )",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: appWhite),
                ),
                SizedBox(height: 10),
                Text(
                  "${surah.numberOfVerses} Ayat | ${surah.revelation!.id}",
                  style: TextStyle(color: appWhite),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget body() {
      return ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: (detailJuz["verses"] as List).length,
        itemBuilder: (context, index) {
          if (detailJuz["verses"].length == 0) {
            return Center(
              child: Text('Tidak ada data'),
            );
          }

          Map<String, dynamic> verse = detailJuz["verses"][index];

          detail.DetailSurah surah = verse["surah"];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if ((verse["verse"] as detail.Verse).number?.inSurah == 1)
                Column(
                  children: [
                    surahInformation(verse, surah),
                    SizedBox(height: 20),
                  ],
                ),
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                            child: Center(
                                child: Text(
                                    "${(verse["verse"] as detail.Verse).number?.inSurah}")),
                          ),
                          SizedBox(width: 10),
                          Text(
                              "${surah.name!.transliteration!.id?.toUpperCase()}"),
                        ],
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
                  "${(verse["verse"] as detail.Verse).text?.arab}",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${(verse["verse"] as detail.Verse).text?.transliteration?.en}",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${(verse["verse"] as detail.Verse).translation?.id}",
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
