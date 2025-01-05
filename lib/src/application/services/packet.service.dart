import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/domain/UDPPacket.dart';

class PacketService {
  void sendText(String text) {
    _sendPacketToMulticast(type: UDPPacketType.textSent, data: text);
  }

  void sendConnected() {
    _sendPacketToMulticast(type: UDPPacketType.userConnected);
  }

  void sendDisconnected() {
    _sendPacketToMulticast(type: UDPPacketType.userDisconnected);
  }

  _sendPacketToMulticast({required UDPPacketType type, String? data}) {
    final multicast = AppLocator().multicast;

    return multicast.sendPacket(type, data);
  }
}

// enum PacketSource {
//   UDP,
//   TCP,
//   HTTP,
// }
