import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/constants/sizes.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/screens/home_screen/drawer_widget.dart';
import 'package:rough_app/src/features/screens/home_screen/home_list_tile_widget.dart';

import '../../controllers/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = Get.put(HomeScreenController());
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Multi-Language Mentor"),
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(gSmallSpace),
              child: Container(
                  padding: EdgeInsets.all(gSmallSpace),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(gBorderRadius),
                    color: Colors.blue,
                  ),
                  // color: Colors.blue,
                  child: Center(
                    child: Column(children: [
                      CircleAvatar(
                        foregroundImage: AssetImage(gUser_icon_2_image),
                        radius: 75.0,
                      ),
                      SizedBox(height: gSmallSpace),
                      Text(gWelcome + ", " + gAccountName,
                          style: Theme.of(context).textTheme.headlineMedium),
                      SizedBox(height: gSmallSpace),
                    ]),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(gSmallSpace),
              child: Container(
                child: Center(
                  child: Text(gHomeText, style: Theme.of(context).textTheme.titleSmall),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(gSmallSpace),
              child: Container(
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

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
