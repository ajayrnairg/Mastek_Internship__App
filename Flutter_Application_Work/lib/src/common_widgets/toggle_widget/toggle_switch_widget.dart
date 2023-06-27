import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ToggleSwitchWidget extends StatelessWidget {
  const ToggleSwitchWidget({
    super.key,
    required this.size,
    required this.selectedLang1,
    required this.selectedLang2,
  });

  final Size size;
  final String selectedLang1;
  final String selectedLang2;

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      initialLabelIndex: 0,
      minWidth: size.width * 0.95,
      minHeight: 40,
      totalSwitches: 2,
      cornerRadius: 5,
      inactiveBgColor: Colors.white,
      inactiveFgColor: Colors.black,
      borderColor: [Colors.blue],
      borderWidth: 2,
      fontSize: 24,
      labels: [selectedLang1, selectedLang2],
      onToggle: (index) {
        var languageNumber = index;
        debugPrint('switched to language: $languageNumber');
      },
    );
  }
}
