import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/constants/sizes.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/screens/home_screen/drawer_widget.dart';
import 'package:rough_app/src/features/screens/home_screen/home_list_tile_widget.dart';
import 'package:rough_app/src/utils/services/notification_services.dart';

import '../../../constants/colors.dart';
import '../../../utils/helperfunctions/sharedpref_helper.dart';
import '../../controllers/home_screen_controller.dart';




class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // final displayName;

  @override
  Widget build(BuildContext context) {
    final homeScreenController = Get.put(HomeScreenController());
    var size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi-Language Mentor"),
        backgroundColor: isDarkMode ? gDarkPurple : gDarkPurple,
      ),
      drawer: DrawerWidget(isDarkMode: isDarkMode),
      body: SingleChildScrollView(

        child: Column(
          children: [
            UserDetailContainer(isDarkMode: isDarkMode),
            Padding(
              padding: const EdgeInsets.all(gSmallSpace),
              child: Center(
                child: Text(gHomeText,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(gSmallSpace),
              child: Center(
                child: ListView(
                  // itemExtent: 80.0,
                  reverse: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: HomeListTileWidget(
                        key: Key(gChat[0]),
                        tileLeading: gChat_icon_image,
                        tileTitle: gChat,
                        controller: homeScreenController,
                        isDarkMode: isDarkMode,

                      ),
                    ),
                    const SizedBox(height: gSmallSpace),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: HomeListTileWidget(
                        key: Key(gGroupChat[0]),
                        tileLeading: gGroupChat_icon_image,
                        tileTitle: gGroupChat,
                        controller: homeScreenController,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    const SizedBox(height: gSmallSpace),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: HomeListTileWidget(
                        key: Key(gDirectChat[0]),
                        tileLeading: gDirectChat_icon_image,
                        tileTitle: gDirectChat,
                        controller: homeScreenController,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    const SizedBox(height: gSmallSpace),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: HomeListTileWidget(
                        key: Key(gTranslate[0]),
                        tileLeading: gTranslate_icon_image,
                        tileTitle: gTranslate,
                        controller: homeScreenController,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class UserDetailContainer extends StatefulWidget {
  const UserDetailContainer({super.key, required this.isDarkMode});

  final bool isDarkMode;
  @override
  State<UserDetailContainer> createState() => _UserDetailContainerState();
}

class _UserDetailContainerState extends State<UserDetailContainer> {
  NotificationServices notificationServices = NotificationServices();

 getMyInfo() async{
   gAccountID = (await SharedPreferenceHelper().getUserId())!;
    gAccountEmail = (await SharedPreferenceHelper().getUserEmail())!;
    gAccountName = (await SharedPreferenceHelper().getDisplayName())!;
    gAccountUserName = (await SharedPreferenceHelper().getUserName())!;
    gUser_icon_image = await SharedPreferenceHelper().getUserProfileUrl();
    setState(() {

    });
  }


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getMyInfo();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseMessagingInit(context);
    notificationServices.interactWithNotification(context);
    notificationServices.getDeviceToken().then((value) {
      print("token:");
      print(value);
    });
    notificationServices.hasTokenRefreshed();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(gSmallSpace),
      child: Container(
          padding: const EdgeInsets.all(gSmallSpace),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(gBorderRadius),
            color: widget.isDarkMode ? gDarkPurple : gDarkPurple,
          ),
          // color: Colors.blue,
          child: Center(
            child: Column(children: [
              (gUser_icon_image != null) ?
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


              const SizedBox(height: gSmallSpace),
              Text("$gWelcome, $gAccountName",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: gSmallSpace),
            ]),
          )),
    );
  }
}

