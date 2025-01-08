import 'package:sinque/src/application/events/packetSent.event.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Packet.dart';
import 'package:sinque/src/infra/client/TCPClient.dart';

class PacketService {
  Future<void> sendPacket(
      {required DeviceConnection device, required Packet packet}) async {
    try {
      TCPClient tcpClient = TCPClient(clientDevice: device);

      tcpClient.send(packet, autoConnect: true, autoDisconnect: true);
    } catch (err) {}
  }

  Future<void> sendPacketToAllDevices(Packet packet) async {
    final NetworkDevicesService networkDevicesService = NetworkDevicesService();

    await Future.microtask(() async {
      for (DeviceConnection device in networkDevicesService.state) {
        try {
          TCPClient tcpClient = TCPClient(clientDevice: device);

          tcpClient.send(packet, autoConnect: true, autoDisconnect: true);
        } catch (err) {}
      }
    });

    PacketSentEvent(packet: packet).dispatch();
  }

  Future<void> sendTextToAllDevices(String text) async {
    sendPacketToAllDevices(await Packet.create(
      data: text,
      type: PacketType.textSent,
    ));
  }

  Future<void> ping() async {
    final pingPacket = await Packet.create(
      type: PacketType.ping,
      data: 'ping',
    );

    sendPacketToAllDevices(pingPacket);
  }

  Future<void> singlePing(DeviceConnection device) async {
    final pingPacket = await Packet.create(
      device: device.device,
      network: device.network,
      type: PacketType.ping,
      data: 'ping',
    );

    sendPacket(packet: pingPacket, device: device);
  }

  Future<void> pong(DeviceConnection device) async {
    sendPacket(
      device: device,
      packet: await Packet.create(
        type: PacketType.pong,
        data: 'pong',
      ),
    );
  }

  // void sendText(String text) {
  //   _sendPacketToMulticast(type: PacketType.textSent, data: text);
  // }

  // void sendConnected() {
  //   _sendPacketToMulticast(type: PacketType.userConnected);
  // }

  // void sendDisconnected() {
  //   _sendPacketToMulticast(type: PacketType.userDisconnected);
  // }

  // _sendPacketToMulticast({required PacketType type, String? data}) {
  //   final multicast = AppLocator().multicast;

  //   return multicast.sendPacket(type, data);
  // }
}

// enum PacketSource {
//   UDP,
//   TCP,
//   HTTP,
// }
