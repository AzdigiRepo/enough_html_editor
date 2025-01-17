import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import 'base.dart';

/// Controls the base format settings bold, italic, underlined and strikethrough
///
/// This widget depends on a [HtmlEditorApiWidget] in the widget tree.
class BaseFormatButtons extends StatefulWidget {
  /// Creates new base formatting controls
  const BaseFormatButtons({Key? key}) : super(key: key);

  @override
  _BaseFormatButtonsState createState() => _BaseFormatButtonsState();
}

class _BaseFormatButtonsState extends State<BaseFormatButtons> {
  final isSelected = [false, false, false, false];

  void _onFormatSettingsChanged(FormatSettings formatSettings) {
    setState(() {
      isSelected[0] = formatSettings.isBold;
      isSelected[1] = formatSettings.isItalic;
      isSelected[2] = formatSettings.isUnderline;
      isSelected[3] = formatSettings.isStrikeThrough;
    });
  }

  @override
  Widget build(BuildContext context) {
    final api = HtmlEditorApiWidget.of(context)!.editorApi..onFormatSettingsChanged = _onFormatSettingsChanged;

    return CupertinoMultipleSegmentedControl(
      children: [
        Icon(CommonPlatformIcons.bold, color: Colors.black),
        Icon(CommonPlatformIcons.italic, color: Colors.black),
        Icon(CommonPlatformIcons.underlined, color: Colors.black),
        Icon(CommonPlatformIcons.strikethrough, color: Colors.black),
      ],
      borderColor: const Color(0xFFbdbdbd),
      onPressed: (index) {
        switch (index) {
          case 0:
            api.formatBold();
            break;
          case 1:
            api.formatItalic();
            break;
          case 2:
            api.formatUnderline();
            break;
          case 3:
            api.formatStrikeThrough();
            break;
        }
        setState(() {
          isSelected[index] = !isSelected[index];
        });
      },
      isSelected: isSelected,
    );
  }
}
