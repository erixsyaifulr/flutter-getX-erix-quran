import 'package:erixquran/app/constant/color.dart';
import 'package:erixquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Erix Quran Apps',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Sesibuk itukah kamu sampai belum membaca Al-Quran ?',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 70),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 250,
              height: 250,
              child: Lottie.asset("assets/lotties/quran-animation.json"),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Get.isDarkMode ? appWhite : appPurplue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
            child: Text(
              'GET STARTED',
              style:
                  TextStyle(color: Get.isDarkMode ? appPurplueDark : appWhite),
            ),
          ),
        ],
      ),
    );
  }
}
