import 'package:sinque/src/core/packetMessage.dart';

class TextMessage extends PacketMessage<TextMessage> {
  final String text;

  TextMessage({this.text = ''});

  @override
  Map<String, String> encodeMessage() {
    return {'text': text};
  }

  @override
  TextMessage decodeMessage(dynamic data) {
    return TextMessage(text: data['text']);
  }
}
