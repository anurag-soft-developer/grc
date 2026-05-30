import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void changeTab(int index) {
    if (index >= 0) _currentIndex.value = index;
  }
}
