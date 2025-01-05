import 'package:event_bus/event_bus.dart';
import 'package:sinque/src/core/appLocator.dart';

abstract class EventEmiter<T> {
  void listen();

  void dispatch() {
    final EventBus eventBus = AppLocator().eventBus;

    eventBus.fire(this);
  }
}
