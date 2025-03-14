import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/features/screens/welcome_screen/welcome_screen.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';
import '../../../utils/services/auth.dart';


class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.isDarkMode
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: gDarkPurple),
            accountName: Text(gAccountUserName, style: Theme.of(context).textTheme.headlineMedium,),
            accountEmail: Text(gAccountEmail, style: Theme.of(context).textTheme.titleMedium,),
            currentAccountPicture: (gUser_icon_image != null) ?
            ClipOval(
                child: Image.network(
                  gUser_icon_image!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )):
            ClipOval(
                child: Image.asset(
                  gUser_icon_2_image!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )),
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(gLanguages, style: Theme.of(context).textTheme.titleSmall,),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(gSettings, style: Theme.of(context).textTheme.titleSmall,),
              ),
              ListTile(
                leading: const Icon(Icons.help_center),
                title: Text(gHelpCenter, style: Theme.of(context).textTheme.titleSmall,),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(gLogOut, style: Theme.of(context).textTheme.titleSmall,),
                onTap: (){
                  AuthMethods().signOut().then((value){
                    Get.offAll(()=> const WelcomeScreen());
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen() ));
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
