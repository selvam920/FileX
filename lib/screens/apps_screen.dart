import 'package:device_apps/device_apps.dart';
import 'package:filex/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../utils/gridviewfixedheight.dart';

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int widthCard = 300;
    int countRow = width ~/ widthCard;

    return Scaffold(
      appBar: AppBar(
        title: Text('Installed Apps'),
      ),
      body: FutureBuilder<List<Application>>(
        future: DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true,
          includeSystemApps: true,
          includeAppIcons: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Application>? data = snapshot.data;
            // Sort the App List on Alphabetical Order
            data!
              ..sort((app1, app2) => app1.appName
                  .toLowerCase()
                  .compareTo(app2.appName.toLowerCase()));
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisSpacing: 20,
                      crossAxisCount: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? 1
                          : countRow,
                      height: 70),
              itemCount: data.length,
              itemBuilder: (ctx, int index) {
                Application app = data[index];
                return ListTile(
                  leading: app is ApplicationWithIcon
                      ? Image.memory(app.icon, height: 40, width: 40)
                      : null,
                  title: Text(app.appName),
                  subtitle: Text('${app.packageName}'),
                  onTap: () => DeviceApps.openApp(app.packageName),
                );
              },
            );
          }
          return CustomLoader();
        },
      ),
    );
  }
}
