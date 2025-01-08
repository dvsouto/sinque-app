import 'package:bonsoir/bonsoir.dart';
import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class DiscoveryServiceStartedEvent
    extends EventEmiter<DiscoveryServiceStartedEvent> {
  late final BonsoirDiscovery _discovery;

  DiscoveryServiceStartedEvent({BonsoirDiscovery? discovery})
      : _discovery = discovery!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setDiscoveryStatus(NetworkStatusType.connected);

    print("Discovery service started!");
  }

  BonsoirDiscovery get discovery => _discovery;
}
