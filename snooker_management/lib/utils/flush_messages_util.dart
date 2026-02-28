import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../main.dart';

class FlushMessagesUtil{
  static void snackBarMessage(String text,String message,BuildContext context){
    mq=MediaQuery.of(context).size;
    Get.showSnackbar(
      GetBar(
        title: text,
        message: message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.symmetric(horizontal: mq.width*0.2),
        borderRadius: 10,
        backgroundColor: Colors.green.withOpacity(0.8),
        barBlur: 20,
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
        boxShadows: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
          )
        ],
        mainButton: TextButton(
          onPressed: () {
            Get.back(); // Dismiss snackbar
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
        ),
        snackStyle: SnackStyle.FLOATING,
        maxWidth:  mq.width * 0.5, // Set width as needed
      ),
    );
  }


  static void easyLoading(){
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom // Set the custom style
      ..textColor = Colors.white // Color of the loading status text
      ..indicatorColor = Colors.white // Color of the loading indicator
      ..progressColor = Colors.white // Progress color of the loading indicator (if applicable)
      ..backgroundColor = Colors.green // Background color of the loading indicator
      ..maskColor = Colors.red; // Mask color of the loading (if applicable)
    EasyLoading.show(status: 'Please Wait...');
  }

}