import 'package:flutter/material.dart';

import '../models.dart';
import 'base.dart';

/// Controls the align format settings left, right, center and justify
///
/// This widget depends on a [HtmlEditorApiWidget] in the widget tree.
class AlignDropdown extends StatefulWidget {
  /// Creates a text alignment dropdown
  const AlignDropdown({Key? key}) : super(key: key);

  @override
  _AlignDropdownState createState() => _AlignDropdownState();
}

class _AlignDropdownState extends State<AlignDropdown> {
  ElementAlign _currentAlignFormat = ElementAlign.left;

  @override
  Widget build(BuildContext context) {
    final api = HtmlEditorApiWidget.of(context)!.editorApi..onAlignSettingsChanged = _onAlignSettingsChanged;

    return Container(
      width: 40,
      alignment: Alignment.center,
      child: DropdownButton<ElementAlign>(
        items: const [
          DropdownMenuItem<ElementAlign>(child: Icon(Icons.format_align_left), value: ElementAlign.left),
          DropdownMenuItem<ElementAlign>(child: Icon(Icons.format_align_center), value: ElementAlign.center),
          DropdownMenuItem<ElementAlign>(child: Icon(Icons.format_align_right), value: ElementAlign.right),
          DropdownMenuItem<ElementAlign>(child: Icon(Icons.format_align_justify), value: ElementAlign.justify),
        ],
        icon: const SizedBox(),
        underline: const SizedBox(),
        onChanged: (value) {
          final align = value ?? ElementAlign.left;
          setState(() {
            _currentAlignFormat = align;
          });
          switch (align) {
            case ElementAlign.left:
              api.formatAlignLeft();
              break;
            case ElementAlign.center:
              api.formatAlignCenter();
              break;
            case ElementAlign.right:
              api.formatAlignRight();
              break;
            case ElementAlign.justify:
              api.formatAlignJustify();
              break;
          }
        },
        selectedItemBuilder: (context) => const [
          Icon(Icons.format_align_left),
          Icon(Icons.format_align_center),
          Icon(Icons.format_align_right),
          Icon(Icons.format_align_justify),
        ],
        value: _currentAlignFormat,
      ),
    );
  }

  void _onAlignSettingsChanged(ElementAlign align) {
    setState(() {
      _currentAlignFormat = align;
    });
  }
}
