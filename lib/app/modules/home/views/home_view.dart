import 'package:erixquran/app/constant/color.dart';
import 'package:erixquran/app/data/models/surah.dart';
import 'package:erixquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    Widget lastRead() {
      return Container(
        height: 150,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            appPurplueLight1,
            appPurplueDark,
          ]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Get.toNamed(Routes.LAST_READ);
            },
            child: Stack(children: [
              Positioned(
                bottom: -30,
                right: 0,
                child: Opacity(
                  opacity: 0.6,
                  child: Container(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      "assets/images/quran-logo.png",
                      color: appWhite,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book_rounded, color: appWhite),
                        SizedBox(width: 10),
                        Text("Terakhir dibaca",
                            style: TextStyle(color: appWhite)),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Al Fatihah",
                            style: TextStyle(color: appWhite, fontSize: 20)),
                        SizedBox(height: 5),
                        Text("Juz 1 | Ayat 5",
                            style: TextStyle(color: appWhite)),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      );
    }

    Widget tabBar() {
      return TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: appPurplueLight1,
        ),
        labelColor: appWhite,
        unselectedLabelColor: appPurplue,
        tabs: [
          Tab(
            child: Text("Surah"),
          ),
          Tab(
            child: Text("Juz"),
          ),
          Tab(
            child: Text("Bookmark"),
          ),
        ],
      );
    }

    Widget surahTabBarView() {
      return FutureBuilder<List<Surah>>(
        future: controller.getAllSurah(),
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
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Surah surah = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${surah.number}"),
                ),
                trailing: Text("${surah.name?.short}"),
                title: Text("${surah.name?.transliteration?.id}"),
                subtitle: Text(
                    "${surah.numberOfVerses} Ayat | ${surah.revelation?.id}"),
                onTap: () {
                  Get.toNamed(Routes.DETAIL_SURAH, arguments: surah);
                },
              );
            },
          );
        },
      );
    }

    Widget tabBarView() {
      return Expanded(
        child: TabBarView(
          children: [
            surahTabBarView(),
            Center(
              child: Text("Juz"),
            ),
            Center(
              child: Text("Bookmark"),
            ),
          ],
        ),
      );
    }

    Widget body() {
      return DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamu'alaikum",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              lastRead(),
              SizedBox(height: 20),
              tabBar(),
              tabBarView(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Al-Quran App'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ],
        ),
        body: body());
  }
}
