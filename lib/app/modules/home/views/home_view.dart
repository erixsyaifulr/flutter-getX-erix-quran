import 'package:erixquran/app/constant/colors.dart';
import 'package:erixquran/app/data/models/detail_surah.dart' as detail;
import 'package:erixquran/app/data/models/surah.dart';
import 'package:erixquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) controller.isDark.value = true;

    PreferredSizeWidget appBar() {
      return AppBar(
        title: Text('Al-Quran App'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      );
    }

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

    Widget tabBarTitle() {
      return Obx(() => TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: appPurplueLight1,
            ),
            labelColor: appWhite,
            unselectedLabelColor:
                controller.isDark.isTrue ? appWhite : appPurplueDark,
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
          ));
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
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/frame.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(child: Text(surah.number.toString())),
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

    Widget juzTabBarView() {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.getAllJuz(),
        builder: (context, snapshpt) {
          if (snapshpt.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshpt.hasData) {
            return Center(
              child: Text('Data Kosong'),
            );
          }
          return ListView.builder(
            itemCount: snapshpt.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> dataPerJuz = snapshpt.data![index];
              return ListTile(
                leading: Container(
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
                title: Text("Juz ${index + 1}"),
                isThreeLine: true,
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Mulai dari ${(dataPerJuz['start']['surah'] as detail.DetailSurah).name?.transliteration?.id} | ayat ${(dataPerJuz['start']['verse'] as detail.Verse).number?.inSurah}"),
                    Text(
                        "Sampai ${(dataPerJuz['start']['surah'] as detail.DetailSurah).name?.transliteration?.id} | ayat ${(dataPerJuz['end']['verse'] as detail.Verse).number?.inSurah}"),
                  ],
                ),
                onTap: () {
                  Get.toNamed(Routes.DETAIL_JUZ, arguments: dataPerJuz);
                },
              );
            },
          );
        },
      );
    }

    Widget bookmarkTabBarView() {
      return GetBuilder<HomeController>(
        builder: (cnt) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: cnt.getBookMark(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data?.length == 0) {
                return Center(
                  child: Text("Bookmark tidak tersedia"),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snapshot.data![index];
                  return ListTile(
                      onTap: () {},
                      leading: Container(
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
                      title: Text(
                          "${data['surah'].toString().replaceAll("+", "'")}"),
                      subtitle:
                          Text("Ayat ${data['ayat']} - via ${data['via']}"),
                      trailing: IconButton(
                        onPressed: () {
                          cnt.deleteBookMark(data['id']);
                        },
                        icon: Icon(Icons.delete),
                      ));
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
            juzTabBarView(),
            bookmarkTabBarView(),
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
              tabBarTitle(),
              tabBarView(),
            ],
          ),
        ),
      );
    }

    Widget changeThemeButton() {
      return FloatingActionButton(
        onPressed: () => controller.changeTheme(),
        child: Obx(() => Icon(
              Icons.color_lens,
              color: controller.isDark.isTrue ? appPurplueDark : appWhite,
            )),
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: body(),
      floatingActionButton: changeThemeButton(),
    );
  }
}
