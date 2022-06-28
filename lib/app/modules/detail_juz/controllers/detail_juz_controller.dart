import 'package:erixquran/app/constant/colors.dart';
import 'package:erixquran/app/data/db/bookmart.dart';
import 'package:erixquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';

class DetailJuzController extends GetxController {
  int index = 0;

  final player = AudioPlayer();
  Verse? lastVerse;
  DatabaseManager database = DatabaseManager.instance;

  Future<void> playAudion(Verse? verse) async {
    if (verse?.audio?.primary != null) {
      try {
        if (lastVerse == null) {
          lastVerse = verse;
        }
        lastVerse!.audioState = "stop";

        lastVerse = verse; // if last verse is not empty
        lastVerse!.audioState = "stop";
        update();

        await player.stop();
        await player.setUrl(verse!.audio!.primary.toString());
        verse.audioState = "playing";
        update();
        await player.play();
        verse.audioState = "stop";
        update();
        await player.stop();
      } on PlayerException catch (e) {
        Get.defaultDialog(title: "Oops !", middleText: "${e.message}");
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
            title: "Oops !", middleText: "Connection aborted: ${e.message}");
      } catch (e) {
        print(e);
      }
    } else {
      Get.defaultDialog(title: "Oops !", middleText: "Audio tidak tersedia");
    }
  }

  Future<void> pauseAudion(Verse verse) async {
    try {
      await player.pause();
      verse.audioState = "pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(title: "Oops !", middleText: "${e.message}");
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Oops !", middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Oops !", middleText: "Audio tidak dapat dipause");
    }
  }

  Future<void> resumeAudion(Verse? verse) async {
    try {
      verse?.audioState = "playing";
      update();
      await player.play();
      verse?.audioState = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(title: "Oops !", middleText: "${e.message}");
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Oops !", middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Oops !", middleText: "Audio tidak dapat dipause");
    }
  }

  Future<void> stopAudion(Verse verse) async {
    try {
      await player.stop();
      verse.audioState = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(title: "Oops !", middleText: "${e.message}");
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Oops !", middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "Oops !", middleText: "Audio tidak dapat dipause");
    }
  }

  Future<void> addBookmark(
      bool lastRead, DetailSurah surah, Verse verse, int index) async {
    Database db = await database.db;
    bool flagExist = false;

    if (lastRead) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query("bookmark",
          columns: [
            "surah",
            "ayat",
            "juz",
            "bookmark_by",
            "index_ayat",
            "last_read"
          ],
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "+")}' and ayat = ${verse.number!.inSurah!} and juz = ${verse.meta!.juz!} and bookmark_by = 'surah' and index_ayat = ${index} and last_read = 0");
      if (checkData.isNotEmpty) {
        flagExist = true;
      }
    }

    if (!flagExist) {
      await db.insert("bookmark", {
        "surah": "${surah.name!.transliteration!.id!.replaceAll("'", "+")}",
        "ayat": "${verse.number!.inSurah!}",
        "juz": "${verse.meta!.juz!}",
        "bookmark_by": "juz",
        "index_ayat": index,
        "last_read": lastRead ? 1 : 0
      });
      Get.back();
      Get.snackbar("Berhasil", "Berhasil menambah bookmark",
          colorText: appWhite);
    } else {
      Get.back();
      Get.snackbar("Oops !", "Bookmark telah tersedia untuk ayat tersebut",
          colorText: appWhite);
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
