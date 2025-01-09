// ignore_for_file: prefer_final_fields

import 'package:sinque/src/domain/Device.dart';
import 'package:uuid/uuid.dart';

class SyncedItem {
  String _uuid = '';
  String _type = '';
  String _content = '';
  late Device _device;

  DateTime _syncedAt = DateTime.now();

  SyncedItem({
    required String type,
    required String content,
    required device,
    String? uuid,
    DateTime? syncedAt,
  })  : _type = type,
        _content = content,
        _device = device,
        _uuid = uuid ?? Uuid().v4(),
        _syncedAt = syncedAt ?? DateTime.now();

  bool equals(SyncedItem item) {
    return uuid == item.uuid;
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': _uuid,
      'type': _type.toString(),
      'content': _content.toString(),
      'device': device.toMap(),
      'syncedAt': syncedAt.toIso8601String(),
    };
  }

  static SyncedItem decode<T>(dynamic object) {
    return SyncedItem(
      uuid: object['uuid'],
      type: object['type'],
      content: object['content'],
      device: Device.decode(object['device']),
      syncedAt: DateTime.tryParse(object['syncedAt']),
    );
  }

  String get uuid => _uuid;
  String get type => _type;
  String get content => _content;
  Device get device => _device;
  DateTime get syncedAt => _syncedAt;
}
