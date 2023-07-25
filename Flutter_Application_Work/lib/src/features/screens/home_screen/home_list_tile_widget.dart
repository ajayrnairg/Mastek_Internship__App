import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../controllers/home_screen_controller.dart';

class HomeListTileWidget extends StatelessWidget {
  const HomeListTileWidget({
    super.key,
    required this.tileLeading,
    required this.tileTitle,
    required this.controller,
    required this.isDarkMode,
  });

  final String tileLeading,tileTitle;
  final HomeScreenController controller;
  final bool isDarkMode;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10.0),
      tileColor: isDarkMode ? gTileColorDark : gTileColorLight,

      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1.0, color: gDarkPurple,),
        borderRadius: BorderRadius.circular(gBorderRadius),
      ),
      leading: Image(
        image: AssetImage(tileLeading),
        color: isDarkMode ? gPrimaryColor : gSecondaryColor,
      ),
      title: Align(
          alignment: Alignment.centerLeft,
          child: Text(tileTitle, style: Theme.of(context).textTheme.titleLarge)),
      onTap: () {controller.goToPageFunc(key);},
    );
  }
}