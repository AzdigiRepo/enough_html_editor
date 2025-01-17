import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

import '../editor_api.dart';
import '../models.dart';
import 'base.dart';

/// Allows to enter and edit links
///
/// This widget depends on a [HtmlEditorApiWidget] in the widget tree.
class LinkButton extends StatefulWidget {
  /// Creates a new link editor button
  const LinkButton({Key? key}) : super(key: key);

  @override
  _LinkButtonState createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  final _urlController = TextEditingController();
  final _textController = TextEditingController();
  bool _isInLink = false;

  @override
  void dispose() {
    _urlController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final api = HtmlEditorApiWidget.of(context)!.editorApi;
    final buttonColor = _isInLink ? Theme.of(context).colorScheme.secondary : null;
    api.onLinkSettingsChanged = _onLinkSettingsChanged;
    return DensePlatformIconButton(
      icon: const Icon(Icons.link, color: Colors.black),
      onPressed: () => _editLink(api),
      color: buttonColor,
    );
  }

  void _onLinkSettingsChanged(LinkSettings? linkSettings) {
    if (linkSettings != null) {
      _urlController.text = linkSettings.url;
      _textController.text = linkSettings.text;
    }
    setState(() {
      _isInLink = linkSettings != null;
    });
  }

  Future _editLink(HtmlEditorApi api) async {
    var restoreSelectionRange = false;
    if (!_isInLink) {
      final selectedText = await api.storeSelectionRange();
      restoreSelectionRange = selectedText.isNotEmpty;
      _textController.text = selectedText;
      final urlText = selectedText.contains('://') ? selectedText : '';
      _urlController.text = urlText;
    }
    final result = await DialogHelper.showWidgetDialog(
      context,
      LinkEditor(
        urlController: _urlController,
        textController: _textController,
      ),
      defaultActions: DialogActions.okAndCancel,
    );
    if (result == true && _urlController.text.trim().isNotEmpty) {
      // check link validity?
      var url = _urlController.text.trim();
      if (!url.contains(':')) {
        url = 'https://$url';
      }
      var text = _textController.text.trim();
      if (text.isEmpty) {
        text = url;
      }
      if (_isInLink) {
        await api.editCurrentLink(url, text);
      } else {
        if (restoreSelectionRange) {
          await api.restoreSelectionRange();
        }
        await api.insertLink(url, text: text);
      }
    }
  }
}

/// A dialog to enter or edit links
class LinkEditor extends StatefulWidget {
  /// Creates a new link editor
  const LinkEditor({
    Key? key,
    required this.urlController,
    required this.textController,
  }) : super(key: key);

  /// The URL controller
  final TextEditingController urlController;

  /// The text / link name controller
  final TextEditingController textController;

  @override
  _LinkEditorState createState() => _LinkEditorState();
}

class _LinkEditorState extends State<LinkEditor> {
  late String _previewText;

  @override
  void initState() {
    super.initState();
    _previewText = widget.textController.text.isEmpty ? widget.urlController.text : widget.textController.text;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedPlatformTextField(
            controller: widget.urlController,
            decoration: InputDecoration(
              icon: const Icon(Icons.link),
              suffix: IconButton(
                icon: Icon(CommonPlatformIcons.clear),
                onPressed: () => widget.urlController.text = '',
              ),
            ),
            autofocus: true,
            keyboardType: TextInputType.url,
            onChanged: (text) => _updatePreview(),
          ),
          DecoratedPlatformTextField(
            controller: widget.textController,
            decoration: InputDecoration(
              icon: const Icon(Icons.text_fields),
              suffix: DensePlatformIconButton(
                icon: Icon(CommonPlatformIcons.clear),
                onPressed: () => widget.textController.text = '',
              ),
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
            onChanged: (text) => _updatePreview(),
          ),
          const Divider(),
          PlatformTextButton(
            child: Text(_previewText),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(url)));
            },
          ),
        ],
      );

  String get url {
    var text = widget.urlController.text;
    if (!text.contains(':')) {
      text = 'https://$text';
    }
    return text;
  }

  void _updatePreview() {
    setState(() {
      _previewText = widget.textController.text.isNotEmpty ? widget.textController.text : widget.urlController.text;
    });
  }
}
