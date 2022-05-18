import 'package:erixquran/app/constant/color.dart';
import 'package:erixquran/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/detail_surah.dart' as detailSurah;
import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final Surah surah = Get.arguments;
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar() {
      return AppBar(
        title: Text('SURAH ${surah.name!.transliteration!.id?.toUpperCase()}'),
        centerTitle: true,
      );
    }

    Widget surahInformation() {
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

    Widget listSurah() {
      return FutureBuilder<detailSurah.DetailSurah>(
        future: controller.getDetailSurah(surah.number.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('Data Kosong'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data?.verses?.length ?? 0,
            itemBuilder: (context, index) {
              if (snapshot.data!.verses!.isEmpty) {
                return SizedBox();
              }
              detailSurah.Verse verse = snapshot.data!.verses![index];
              return Column(
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
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.bookmark_add_outlined)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.play_arrow)),
                            ],
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
                      style:
                          TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
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
        },
      );
    }

    Widget body() {
      return ListView(
        padding: EdgeInsets.all(20),
        children: [
          surahInformation(),
          SizedBox(height: 20),
          listSurah(),
        ],
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }
}
