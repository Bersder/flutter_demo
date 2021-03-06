import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class ToastUtil {
  /// 需先初始化后才能使用

  ToastUtil._();

  static CancelFunc showText({
    @required String text,
    Duration duration = const Duration(seconds: 2),
  }) {
    return BotToast.showText(
      text: text,
      duration: duration,
      contentColor: Colors.black45,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    );
  }
}
