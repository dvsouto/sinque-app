import 'package:sinque/src/core/packetMessage.dart';

class EmptyMessage extends PacketMessage<EmptyMessage> {
  EmptyMessage();

  @override
  Map<String, String> encodeMessage() {
    return {};
  }

  @override
  EmptyMessage decodeMessage(dynamic data) {
    return EmptyMessage();
  }
}
