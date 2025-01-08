import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/application/services/packet.service.dart';

class ConnectionChecker {
  bool active = true;
  int timeChecker = 5;

  void initialize() {
    print("Connection checker initialized");

    active = true;

    _makeNextExecute();
  }

  void execute() async {
    final networkStatusService = NetworkStatusService();
    final packetService = PacketService();

    try {
      if (active && networkStatusService.state.isConnected()) {
        await packetService.ping();
      }
    } catch (err) {
      print("Error when trying send ping.\nErr: $err");
    } finally {
      _makeNextExecute();
    }
  }

  void _makeNextExecute() {
    if (active) {
      Future.delayed(Duration(seconds: timeChecker), () {
        execute();
      });
    }
  }

  void stop() {
    active = false;
  }
}
