import 'package:erixquran/app/data/models/detail_surah.dart' as detail;
import 'package:erixquran/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../constant/colors.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final Map<String, dynamic> detailJuz = Get.arguments["juz"];
  Map<String, dynamic>? bookmark;
  final homeC = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    if (Get.arguments["bookmark"] != null) {
      bookmark = Get.arguments["bookmark"];
      controller.scrollC.scrollToIndex(bookmark!["index_ayat"],
          preferPosition: AutoScrollPosition.begin);
    }

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

    List<Widget> allAyat =
        List.generate((detailJuz["verses"] as List).length, (index) {
      Map<String, dynamic> verse = detailJuz["verses"][index];

      detail.DetailSurah surah = verse["surah"];
      detail.Verse verseDetail = verse["verse"];

      return AutoScrollTag(
        index: index,
        controller: controller.scrollC,
        key: ValueKey(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (verseDetail.number?.inSurah == 1)
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
                                child: Text("${verseDetail.number?.inSurah}")),
                          ),
                          SizedBox(width: 10),
                          Text(
                              "${surah.name!.transliteration!.id?.toUpperCase()}"),
                        ],
                      ),
                      GetBuilder<DetailJuzController>(
                        builder: (cnt) => Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.defaultDialog(
                                    title: "Bookmark",
                                    middleText: "Pilih jenis bookmark",
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await cnt.addBookmark(
                                              true, surah, verseDetail, index);
                                          homeC.update();
                                        },
                                        child: Text("Last Read"),
                                        style: ElevatedButton.styleFrom(
                                            primary: appPurplue),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          cnt.addBookmark(
                                              false, surah, verseDetail, index);
                                        },
                                        child: Text("Bookmark"),
                                        style: ElevatedButton.styleFrom(
                                            primary: appPurplue),
                                      ),
                                    ]);
                              },
                              icon: Icon(Icons.bookmark_add_outlined),
                            ),
                            (verseDetail.audioState == "stop")
                                ? IconButton(
                                    onPressed: () {
                                      cnt.playAudion(verseDetail);
                                    },
                                    icon: Icon(Icons.play_arrow),
                                  )
                                : Row(
                                    children: [
                                      (verseDetail.audioState == "playing")
                                          ? IconButton(
                                              onPressed: () {
                                                cnt.pauseAudion(verseDetail);
                                              },
                                              icon: Icon(Icons.pause),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                cnt.resumeAudion(verseDetail);
                                              },
                                              icon: Icon(Icons.play_arrow),
                                            ),
                                      IconButton(
                                        onPressed: () {
                                          cnt.stopAudion(verseDetail);
                                        },
                                        icon: Icon(Icons.stop),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
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
          ),
        ),
      );
    });

    Widget body() {
      return ListView(
        padding: EdgeInsets.all(20),
        children: allAyat,
        controller: controller.scrollC,
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }
}
