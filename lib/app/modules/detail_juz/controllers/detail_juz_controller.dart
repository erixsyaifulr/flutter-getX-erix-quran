import 'package:erixquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class DetailJuzController extends GetxController {
  int index = 0;

  final player = AudioPlayer();
  Verse? lastVerse;

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

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
