import 'dart:convert';

import 'package:erixquran/app/constant/endpoints.dart';
import 'package:erixquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class DetailSurahController extends GetxController {
  Future<DetailSurah> getDetailSurah(String id) async {
    var res = await http.get(Uri.parse(Endpoint.getSurahUrl + "/$id"));
    Map<String, dynamic> data =
        (jsonDecode(res.body) as Map<String, dynamic>)["data"];
    return DetailSurah.fromJson(data);
  }

  RxString audioState = "stop".obs;
  final player = AudioPlayer();

  Future<void> playAudion(String? url) async {
    if (url != null) {
      try {
        await player.stop();
        await player.setUrl(url);
        audioState.value = "playing";
        await player.play();
        audioState.value = "stop";
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

  Future<void> pauseAudion() async {
    try {
      await player.pause();
      audioState.value = "pause";
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

  Future<void> resumeAudion() async {
    try {
      audioState.value = "playing";
      await player.play();
      audioState.value = "stop";
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

  Future<void> stopAudion() async {
    try {
      await player.stop();
      audioState.value = "stop";
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
