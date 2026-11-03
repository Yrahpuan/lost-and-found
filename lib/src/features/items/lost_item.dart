import 'package:cloud_firestore/cloud_firestore.dart';

enum ItemStatus {
  lost('lost', 'Perdido'),
  found('found', 'Encontrado');

  const ItemStatus(this.value, this.label);

  final String value;
  final String label;

  static ItemStatus fromValue(Object? value) =>
      ItemStatus.values.firstWhere((status) => status.value == value);
}

class LostItem {
  const LostItem({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final String location;
  final ItemStatus status;
  final DateTime createdAt;

  factory LostItem.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final timestamp = data['createdAt'];
    if (timestamp is! Timestamp) {
      throw const FormatException('Data de cadastro inválida.');
    }

    return LostItem(
      id: document.id,
      name: data['name'] as String,
      description: data['description'] as String,
      location: data['location'] as String,
      status: ItemStatus.fromValue(data['status']),
      createdAt: timestamp.toDate(),
    );
  }
}
