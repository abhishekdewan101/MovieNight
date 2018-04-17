import 'package:flutter/material.dart';

class NavigatorUtils {

  static void pushRouteWithSlideAnimation(BuildContext context, Widget builder) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context,_,__) {
          return builder;
        },
        transitionsBuilder: (_,Animation<double> animation,__,Widget child) {
          return new SlideTransition(
              position : new Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero
              ).animate(animation),
              child: child
          );
        }
    ));
  }

  static void showSnackBarWithMessage(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
    )
    );
  }

  static void popTillLoginPage(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

}