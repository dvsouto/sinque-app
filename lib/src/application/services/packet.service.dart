import 'package:sinque/src/application/events/packetSent.event.dart';
import 'package:sinque/src/application/services/networkDevices.service.dart';
import 'package:sinque/src/application/services/syncedItem.service.dart';
import 'package:sinque/src/domain/DeviceConnection.dart';
import 'package:sinque/src/domain/Packet.dart';
import 'package:sinque/src/domain/SyncedItemsMessage.dart';
import 'package:sinque/src/domain/TextMessage.dart';
import 'package:sinque/src/infra/client/TCPClient.dart';

class PacketService {
  /// Send packet to device
  Future<void> sendPacket({
    required DeviceConnection device,
    required Packet packet,
    bool autoConnect = true,
    bool autoDisconnect = true,
  }) async {
    try {
      TCPClient tcpClient = TCPClient(clientDevice: device);

      tcpClient.send(
        [packet],
        autoConnect: autoConnect,
        autoDisconnect: autoDisconnect,
      );
    } catch (err) {}
  }

  /// Send many packets to device
  Future<void> sendPackets({
    required DeviceConnection device,
    required List<Packet> packets,
  }) async {
    try {
      TCPClient tcpClient = TCPClient(clientDevice: device);

      tcpClient.send(
        packets,
        autoConnect: true,
        autoDisconnect: true,
      );
    } catch (err) {}
  }

  /// Send packet to all devices
  Future<void> sendPacketToAllDevices(Packet packet) async {
    final NetworkDevicesService networkDevicesService = NetworkDevicesService();

    await Future.microtask(() async {
      for (DeviceConnection device in networkDevicesService.state) {
        // i dont know how the list have received 'this' device, but this line resolves the problem of send ping to 'this' device and/or add to connected list
        if (device.network.itsMe()) {
          continue;
        }

        try {
          TCPClient tcpClient = TCPClient(clientDevice: device);

          tcpClient.send([packet], autoConnect: true, autoDisconnect: true);
        } catch (err) {}
      }
    });

    PacketSentEvent(packet: packet).dispatch();
  }

  /// Send text packet to all devices
  Future<void> sendTextToAllDevices(String text) async {
    sendPacketToAllDevices(await Packet.create(
      data: TextMessage(text: text),
      type: PacketType.textSent,
    ));
  }

  /// Send ping to all devices
  Future<void> ping() async {
    final pingPacket = await Packet.create(
      type: PacketType.ping,
    );

    sendPacketToAllDevices(pingPacket);
  }

  /// Send ping to unique device
  Future<void> singlePing(DeviceConnection device) async {
    final pingPacket = await Packet.create(
      type: PacketType.ping,
    );

    // print("device: ${device.encode()}");

    return await sendPacket(
      packet: pingPacket,
      device: device,
    );
  }

  /// Send pong to device
  Future<void> pong(DeviceConnection device) async {
    sendPacket(
      device: device,
      packet: await Packet.create(
        type: PacketType.pong,
      ),
    );
  }

  /// Sync list
  Future<void> sync(DeviceConnection device) async {
    final syncedItemService = SyncedItemService();
    final items = syncedItemService.state;

    if (items.isNotEmpty) {
      final packet = await Packet.create(
        type: PacketType.sync,
        data: SyncedItemsMessage(
          itens: items,
        ),
      );

      return await sendPacket(packet: packet, device: device);
    }
  }

  /// Send ping and list
  Future<void> pingAndSync(DeviceConnection device) async {
    final syncedItemService = SyncedItemService();
    final items = syncedItemService.state;

    final pingPacket = await Packet.create(type: PacketType.ping);

    if (items.isEmpty) {
      return await sendPacket(packet: pingPacket, device: device);
    }

    final syncPacket = await Packet.create(
      type: PacketType.sync,
      data: SyncedItemsMessage(
        itens: items,
      ),
    );

    return await sendPackets(packets: [pingPacket, syncPacket], device: device);
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
