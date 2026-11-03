import 'package:cloud_firestore/cloud_firestore.dart';

import 'lost_item.dart';

abstract interface class ItemsDataSource {
  Future<List<LostItem>> fetchItems();

  Future<void> addItem({
    required String name,
    required String description,
    required String location,
    required ItemStatus status,
  });
}

class ItemsRepository implements ItemsDataSource {
  static const _operationTimeout = Duration(seconds: 15);

  ItemsRepository({FirebaseFirestore? firestore})
      : _providedFirestore = firestore;

  final FirebaseFirestore? _providedFirestore;
  FirebaseFirestore get _firestore =>
      _providedFirestore ?? FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection('items');

  @override
  Future<List<LostItem>> fetchItems() async {
    final snapshot = await _items
        .get(const GetOptions(source: Source.server))
        .timeout(_operationTimeout);
    final items = snapshot.docs.map(LostItem.fromDocument).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<void> addItem({
    required String name,
    required String description,
    required String location,
    required ItemStatus status,
  }) async {
    // Check the server first so a request made while offline does not remain
    // queued in the Firestore client while the form waits indefinitely.
    await _items
        .limit(1)
        .get(const GetOptions(source: Source.server))
        .timeout(_operationTimeout);

    await _items.add({
      'name': name.trim(),
      'description': description.trim(),
      'location': location.trim(),
      'status': status.value,
      'createdAt': FieldValue.serverTimestamp(),
    }).timeout(_operationTimeout);
  }
}
