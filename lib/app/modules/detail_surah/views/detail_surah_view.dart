import 'package:erixquran/app/constant/colors.dart';
import 'package:erixquran/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../data/models/detail_surah.dart' as detailSurah;
import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar() {
      return AppBar(
        title: Text('SURAH ${Get.arguments["name"].toString().toUpperCase()}'),
        centerTitle: true,
      );
    }

    Widget surahInformation(detailSurah.DetailSurah surah) {
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

    Widget listSurah(snapshot) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: snapshot.data?.verses?.length ?? 0,
        itemBuilder: (context, index) {
          if (snapshot.data!.verses!.isEmpty) {
            return SizedBox();
          }
          detailSurah.Verse verse = snapshot.data!.verses![index];
          return AutoScrollTag(
            key: ValueKey(index + 2),
            index: index + 2,
            controller: controller.scrollC,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: appPurplueLight2.withOpacity(0.15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
                          child: Center(child: Text("${index + 1}")),
                        ),
                        GetBuilder<DetailSurahController>(
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
                                            await cnt.addBookmark(true,
                                                snapshot.data!, verse, index);
                                            homeC.update();
                                          },
                                          child: Text("Last Read"),
                                          style: ElevatedButton.styleFrom(
                                              primary: appPurplue),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            cnt.addBookmark(false,
                                                snapshot.data!, verse, index);
                                          },
                                          child: Text("Bookmark"),
                                          style: ElevatedButton.styleFrom(
                                              primary: appPurplue),
                                        ),
                                      ]);
                                },
                                icon: Icon(Icons.bookmark_add_outlined),
                              ),
                              (verse.audioState == "stop")
                                  ? IconButton(
                                      onPressed: () {
                                        cnt.playAudion(verse);
                                      },
                                      icon: Icon(Icons.play_arrow),
                                    )
                                  : Row(
                                      children: [
                                        (verse.audioState == "playing")
                                            ? IconButton(
                                                onPressed: () {
                                                  cnt.pauseAudion(verse);
                                                },
                                                icon: Icon(Icons.pause),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  cnt.resumeAudion(verse);
                                                },
                                                icon: Icon(Icons.play_arrow),
                                              ),
                                        IconButton(
                                          onPressed: () {
                                            cnt.stopAudion(verse);
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
            ),
          );
        },
      );
    }

    Widget body() {
      return FutureBuilder<detailSurah.DetailSurah>(
        future: controller.getDetailSurah(Get.arguments["number"].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (!snapshot.hasData)
            return Center(
              child: Text('Data Kosong'),
            );

          if (Get.arguments["bookmark"] != null) {
            bookmark = Get.arguments["bookmark"];
            controller.scrollC.scrollToIndex(bookmark!["index_ayat"] + 2,
                preferPosition: AutoScrollPosition.begin);
          }
          detailSurah.DetailSurah surah = snapshot.data!;

          return ListView(
            controller: controller.scrollC,
            padding: EdgeInsets.all(20),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: surahInformation(surah),
              ),
              AutoScrollTag(
                key: ValueKey(1),
                index: 1,
                controller: controller.scrollC,
                child: SizedBox(height: 20),
              ),
              listSurah(snapshot),
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
