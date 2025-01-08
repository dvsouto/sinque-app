import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sinque/src/application/services/packet.service.dart';
import 'package:sinque/src/presentation/themes/appTheme.dart';
import 'package:sinque/src/shared/device.util.dart';

class InputTextDialog extends StatefulWidget {
  const InputTextDialog({super.key});

  static show(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 0,
            ),
            child: InputTextDialog(),
          );
        },
      );
    }
    // }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: InputTextDialog(),
        );
      },
    );
  }

  @override
  State<InputTextDialog> createState() => _InputTextDialogState();
}

class _InputTextDialogState extends State<InputTextDialog> {
  final TextEditingController _controller = TextEditingController();

  void handleSendText() {
    final text = _controller.text;
    final PacketService packetService = PacketService();

    if (text != '') {
      packetService.sendTextToAllDevices(text);

      Navigator.pop(context);
    }
  }

  void handlePasteFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    print('clipboard: $clipboardData');
    if (clipboardData?.text != null && clipboardData?.text != '') {
      setState(() {
        _controller.text = clipboardData!.text!;
      });
    }
  }

  void handleCancel() {
    _controller.clear();

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtil.isMobile();
    double modalWidth = isMobile
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.75;

    double modalBorderRadius = 16.0;

    return Container(
      height: isMobile ? 245 : 225,
      width: modalWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(modalBorderRadius),
          topRight: Radius.circular(modalBorderRadius),
          bottomLeft:
              isMobile ? Radius.zero : Radius.circular(modalBorderRadius),
          bottomRight:
              isMobile ? Radius.zero : Radius.circular(modalBorderRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 6.0, left: 14.0, right: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(Icons.title),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 16.0),
                              child: Text(
                                "Sync text",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _controller,
                              builder: (context, value, child) {
                                final canPaste = _controller.text.isEmpty;

                                return Visibility(
                                  visible: canPaste,
                                  child: ElevatedButton(
                                    onPressed: () => handlePasteFromClipboard(),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      backgroundColor: AppTheme.light,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.content_paste,
                                          color: Colors.white.withAlpha(200),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 6.0),
                                          child: Text(
                                            "Paste from clipboard",
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withAlpha(200),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            iconSize: 18.0,
                            constraints:
                                BoxConstraints(maxHeight: 36, maxWidth: 36),
                            onPressed: () => handleCancel(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: TextFormField(
                    controller: _controller,
                    autofocus: true,
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => handleSendText(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                    decoration: InputDecoration(
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      hintText: "Enter the text to send",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size.fromHeight(38.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: isMobile
                          ? BorderRadius.zero
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(modalBorderRadius),
                            ),
                    ),
                    backgroundColor: AppTheme.danger,
                  ),
                  onPressed: () => handleCancel(),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 60,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    final bool canSend = _controller.text.isNotEmpty;

                    return ElevatedButton(
                      onPressed: canSend ? () => handleSendText() : null,
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(38.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: isMobile
                              ? BorderRadius.zero
                              : BorderRadius.only(
                                  bottomRight:
                                      Radius.circular(modalBorderRadius),
                                ),
                        ),
                        disabledBackgroundColor: AppTheme.disabledBackground,
                        disabledIconColor: AppTheme.disabledText,
                        iconColor: Colors.white,
                        backgroundColor: AppTheme.success,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 6.0),
                            child: Icon(Icons.send, size: 16.0),
                          ),
                          Text(
                            "Send",
                            style: TextStyle(
                              color: canSend
                                  ? Colors.white
                                  : AppTheme.disabledText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
