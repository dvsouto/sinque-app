import 'package:bonsoir/bonsoir.dart';
import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class DiscoveryServiceStoppedEvent
    extends EventEmiter<DiscoveryServiceStoppedEvent> {
  late final BonsoirDiscovery _discovery;

  DiscoveryServiceStoppedEvent({BonsoirDiscovery? discovery})
      : _discovery = discovery!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setDiscoveryStatus(NetworkStatusType.idle);

    print("Discovery service stoped.");
  }

  BonsoirDiscovery get discovery => _discovery;
}
