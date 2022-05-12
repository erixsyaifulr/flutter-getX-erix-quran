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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Sesibuk itukah kamu sampai belum membaca Al-Quran',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 250,
            height: 250,
            child: Lottie.asset("assets/lotties/quran-animation.json"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
            child: Text('Mulai'),
          ),
        ],
      ),
    );
  }
}
