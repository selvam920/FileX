import 'dart:async';
import 'dart:io';

import 'package:filex/screens/main_screen/main_screen.dart';
import 'package:filex/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTimeout() {
    return Timer(Duration(seconds: 2), () => checkPermission());
  }

  checkPermission() async {
    bool hasAccess = false;
    if (Platform.isAndroid) {
      if (await Permission.storage.isPermanentlyDenied) openAppSettings();
      hasAccess = await Permission.storage.isGranted;
      if (!hasAccess) hasAccess = await Permission.storage.request().isGranted;

      if (await Permission.accessMediaLocation.isPermanentlyDenied)
        openAppSettings();
      hasAccess = await Permission.accessMediaLocation.isGranted;
      if (!hasAccess)
        hasAccess = await Permission.accessMediaLocation.request().isGranted;

      if (!await Permission.manageExternalStorage.isRestricted) {
        if (await Permission.manageExternalStorage.isPermanentlyDenied)
          openAppSettings();
        hasAccess = await Permission.manageExternalStorage.isGranted;
        if (!hasAccess) {
          hasAccess =
              await Permission.manageExternalStorage.request().isGranted;
        }
      }

      if (hasAccess) {
        Navigate.pushPageReplacement(context, MainScreen());
      } else {
        Dialogs.showToast('Please Grant Storage Permissions');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness:
            Theme.of(context).primaryColor == ThemeConfig.darkTheme.primaryColor
                ? Brightness.light
                : Brightness.dark,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Feather.folder,
              color: Theme.of(context).accentColor,
              size: 70.0,
            ),
            SizedBox(height: 20.0),
            Text(
              '${AppStrings.appName}',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
