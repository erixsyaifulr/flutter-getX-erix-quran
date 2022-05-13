import 'package:get/get.dart';

import 'package:erixquran/app/modules/detail_ayat/bindings/detail_ayat_binding.dart';
import 'package:erixquran/app/modules/detail_ayat/views/detail_ayat_view.dart';
import 'package:erixquran/app/modules/detail_surah/bindings/detail_surah_binding.dart';
import 'package:erixquran/app/modules/detail_surah/views/detail_surah_view.dart';
import 'package:erixquran/app/modules/home/bindings/home_binding.dart';
import 'package:erixquran/app/modules/home/views/home_view.dart';
import 'package:erixquran/app/modules/introduction/bindings/introduction_binding.dart';
import 'package:erixquran/app/modules/introduction/views/introduction_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SURAH,
      page: () => DetailSurahView(),
      binding: DetailSurahBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_AYAT,
      page: () => DetailAyatView(),
      binding: DetailAyatBinding(),
    ),
  ];
}
