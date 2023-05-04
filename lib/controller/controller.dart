import 'package:riverpod_app/service/service.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_app/model/model.dart';

class Controller extends ChangeNotifier {
  PageController pageController = PageController(initialPage: 0);
  bool? isLoading;
  List<UserModelData?> users = [];
  List<UserModelData?> saved = [];

  void getData() {
    Service.fetch().then((value) {
      if (value != null) {
        users = value.data!;
        isLoading = true;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  void addSaved(UserModelData model) {
    saved.add(model);
    users.remove(model);
    notifyListeners();
  }

  void deleted(UserModelData model) {
    saved.remove(model);
    users.add(model);
    notifyListeners();
  }

  notSavedButton() {
    pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInExpo);
  }

  savedButton() {
    pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInExpo);
  }
}
