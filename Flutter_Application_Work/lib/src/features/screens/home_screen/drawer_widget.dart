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
            accountName: Text(gAccountName),
            accountEmail: Text(gAccountEmail),
            currentAccountPicture: CircleAvatar(
              foregroundImage: AssetImage(gUser_icon_2_image),
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.language),
                title: Text(gLanguages),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(gSettings),
              ),
              ListTile(
                leading: Icon(Icons.help_center),
                title: Text(gHelpCenter),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(gLogOut),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
