import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/domain/Packet.dart';

class PongSentEvent extends EventEmiter<PongSentEvent> {
  final Packet? _packet;

  PongSentEvent({Packet? packet}) : _packet = packet;

  @override
  void listen() {
    // listen sent pong
    // print("@ping");
  }

  Packet get packet => _packet!;
}
