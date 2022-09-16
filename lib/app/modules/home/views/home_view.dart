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

    Widget loadingContainer() {
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
            onTap: () {},
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
                        Text("Loading...",
                            style: TextStyle(color: appWhite, fontSize: 20)),
                        SizedBox(height: 5),
                        Text("", style: TextStyle(color: appWhite)),
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

    Widget lastRead() {
      return GetBuilder<HomeController>(builder: (cnt) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: cnt.getLastRead(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingContainer();
            }
            Map<String, dynamic>? lastRead = snapshot.data;
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
                    if (lastRead != null) {
                      switch (lastRead["bookmark_by"]) {
                        case "juz":
                          if (controller.allJuzIsAvailable.isTrue) {
                            Map<String, dynamic> dataMapPerJuz =
                                controller.allJuz[lastRead['juz'] - 1];
                            Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                              "juz": dataMapPerJuz,
                              "bookmark": lastRead
                            });
                          } else {
                            Get.snackbar("Oops !", "Data juz belum tersedia");
                          }
                          break;
                        default:
                          Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                            "name": lastRead['surah']
                                .toString()
                                .replaceAll("+", "'"),
                            "number": lastRead['number_surah'],
                            "bookmark": lastRead
                          });
                      }
                    }
                  },
                  onLongPress: () {
                    if (lastRead != null)
                      Get.defaultDialog(
                        title: "Konfirmasi",
                        middleText:
                            "Apakah anda yakin akan menghapus data terakhir baca ?",
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(),
                              child: Text("Cancel")),
                          ElevatedButton(
                              onPressed: () => cnt.deleteBookMark(
                                  lastRead['id'],
                                  isLastRead: true),
                              child: Text("Yakin")),
                        ],
                      );
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
                              if (lastRead != null)
                                Text(
                                    "${lastRead['surah'].toString().replaceAll("+", "'")}",
                                    style: TextStyle(
                                        color: appWhite, fontSize: 20)),
                              SizedBox(height: 5),
                              Text(
                                  lastRead == null
                                      ? "Belum ada data"
                                      : "Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
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
          },
        );
      });
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
                  Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                    "name": surah.name!.transliteration!.id,
                    "number": surah.number,
                  });
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
            controller.allJuzIsAvailable.value = false;
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshpt.hasData) {
            return Center(
              child: Text('Data Kosong'),
            );
          }
          controller.allJuzIsAvailable.value = true;
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
                  Get.toNamed(Routes.DETAIL_JUZ,
                      arguments: {"juz": dataPerJuz});
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
                    onTap: () {
                      switch (data["bookmark_by"]) {
                        case "juz":
                          if (controller.allJuzIsAvailable.isTrue) {
                            Map<String, dynamic> dataMapPerJuz =
                                controller.allJuz[data['juz'] - 1];
                            Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                              "juz": dataMapPerJuz,
                              "bookmark": data
                            });
                          } else {
                            Get.snackbar("Oops !", "Data juz belum tersedia");
                          }

                          break;
                        default:
                          Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                            "name":
                                data['surah'].toString().replaceAll("+", "'"),
                            "number": data['number_surah'],
                            "bookmark": data
                          });
                      }
                    },
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
                    subtitle: Text(
                        "Ayat ${data['ayat']} - via ${data['bookmark_by']}"),
                    trailing: IconButton(
                      onPressed: () {
                        cnt.deleteBookMark(data['id']);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  );
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
