import 'package:bonsoir/bonsoir.dart';
import 'package:sinque/src/application/core/eventEmmiter.dart';
import 'package:sinque/src/application/services/networkStatus.service.dart';
import 'package:sinque/src/domain/NetworkStatus.dart';

class DiscoveryServiceOpeningEvent
    extends EventEmiter<DiscoveryServiceOpeningEvent> {
  late final BonsoirDiscovery _discovery;

  DiscoveryServiceOpeningEvent({BonsoirDiscovery? discovery})
      : _discovery = discovery!;

  @override
  void listen() {
    final networkStatusService = NetworkStatusService();

    networkStatusService.setDiscoveryStatus(NetworkStatusType.connecting);

    print("Starting discovery service...");
  }

  BonsoirDiscovery get discovery => _discovery;
}
