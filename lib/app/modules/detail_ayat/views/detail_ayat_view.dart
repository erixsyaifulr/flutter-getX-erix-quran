import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_ayat_controller.dart';

class DetailAyatView extends GetView<DetailAyatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailAyatView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DetailAyatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
