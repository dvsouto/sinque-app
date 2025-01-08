import 'package:bonsoir/bonsoir.dart';
import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class BroadcastServiceOpeningEvent
    extends EventEmiter<BroadcastServiceOpeningEvent> {
  late final BonsoirBroadcast _broadcast;

  BroadcastServiceOpeningEvent({BonsoirBroadcast? broadcast})
      : _broadcast = broadcast!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setBroadcastStatus(NetworkStatusType.connecting);

    print("Starting broadcast service...");
  }

  BonsoirBroadcast get broadcast => _broadcast;
}
