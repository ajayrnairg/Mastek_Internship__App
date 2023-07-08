import 'package:flutter/material.dart';

import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';


class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(gAccountName, style: Theme.of(context).textTheme.headlineMedium,),
            accountEmail: Text(gAccountEmail, style: Theme.of(context).textTheme.titleMedium,),
            currentAccountPicture: CircleAvatar(
              foregroundImage: AssetImage(gUser_icon_2_image),
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.language),
                title: Text(gLanguages, style: Theme.of(context).textTheme.titleSmall,),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(gSettings, style: Theme.of(context).textTheme.titleSmall,),
              ),
              ListTile(
                leading: Icon(Icons.help_center),
                title: Text(gHelpCenter, style: Theme.of(context).textTheme.titleSmall,),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(gLogOut, style: Theme.of(context).textTheme.titleSmall,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
