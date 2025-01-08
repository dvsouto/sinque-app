import 'package:bonsoir/bonsoir.dart';
import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class BroadcastServiceStoppedEvent
    extends EventEmiter<BroadcastServiceStoppedEvent> {
  late final BonsoirBroadcast _broadcast;

  BroadcastServiceStoppedEvent({BonsoirBroadcast? broadcast})
      : _broadcast = broadcast!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setBroadcastStatus(NetworkStatusType.idle);

    print("Broadcast service stoped.");
  }

  BonsoirBroadcast get broadcast => _broadcast;
}
