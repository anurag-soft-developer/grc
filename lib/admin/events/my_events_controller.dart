import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyEventsController extends GetxController {
  final ScrollController scrollController = ScrollController();

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
