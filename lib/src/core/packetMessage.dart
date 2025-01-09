import 'package:sinque/src/domain/EmptyMessage.dart';
import 'package:sinque/src/domain/Packet.dart';
import 'package:sinque/src/domain/SyncedItemsMessage.dart';
import 'package:sinque/src/domain/TextMessage.dart';

class PacketMessage<T> {
  Map<String, dynamic> encodeMessage() {
    throw UnimplementedError("Method encodeMessage() not implemented!");
  }

  T decodeMessage(dynamic data) {
    throw UnimplementedError("Method encodeMessage() of $T not implemented!");
  }

  static T applyDecode<T extends PacketMessage>({
    required PacketType packetType,
    required dynamic data,
  }) {
    switch (packetType) {
      case PacketType.textSent:
        return TextMessage().decodeMessage(data) as T;
      case PacketType.sync:
        return SyncedItemsMessage().decodeMessage(data) as T;
      case PacketType.ping:
      case PacketType.pong:
      case PacketType.userConnected:
      case PacketType.userDisconnected:
        return EmptyMessage().decodeMessage(data) as T;
      default:
        throw UnimplementedError("Packet $T needs a decode implementation!");
    }
  }
}
