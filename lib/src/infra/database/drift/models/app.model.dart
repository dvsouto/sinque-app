import 'package:drift/drift.dart';

class AppModel extends Table {
  TextColumn get uuid => text().named('uuid')();
  // TextColumn get address => text().named('address')();
  // TextColumn get hostname => text().named('hostname')();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}
