import 'package:bonsoir/bonsoir.dart';
import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class BroadcastServiceStartedEvent
    extends EventEmiter<BroadcastServiceStartedEvent> {
  late final BonsoirBroadcast _broadcast;

  BroadcastServiceStartedEvent({BonsoirBroadcast? broadcast})
      : _broadcast = broadcast!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setBroadcastStatus(NetworkStatusType.connected);

    print("Broadcast service started!");
  }

  BonsoirBroadcast get broadcast => _broadcast;
}
