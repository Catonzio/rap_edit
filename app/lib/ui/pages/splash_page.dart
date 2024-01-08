import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: ElevatedButton(
          onPressed: () => Get.find<SplashController>().goHome(),
          child: const Text("Go Home")),
    )));
  }
}
