import 'package:flutter/foundation.dart';

import 'items_repository.dart';
import 'lost_item.dart';

class ItemsController extends ChangeNotifier {
  ItemsController({String? startupError, ItemsDataSource? repository})
      : _repository = repository ?? ItemsRepository(),
        _startupError = startupError {
    if (startupError == null) loadItems();
  }

  final ItemsDataSource _repository;
  final String? _startupError;
  List<LostItem> items = const [];
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  Future<void> loadItems() async {
    if (_startupError != null) {
      errorMessage = 'Não foi possível iniciar a conexão com a nuvem. '
          'Confira a configuração do Firebase.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      items = await _repository.fetchItems();
    } catch (_) {
      errorMessage = 'Não foi possível carregar os registros. Tente novamente.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addItem({
    required String name,
    required String description,
    required String location,
    required ItemStatus status,
  }) async {
    if (isSaving) return false;
    isSaving = true;
    notifyListeners();
    try {
      await _repository.addItem(
        name: name,
        description: description,
        location: location,
        status: status,
      );
      await loadItems();
      return true;
    } catch (_) {
      errorMessage = 'Não foi possível salvar o registro. Tente novamente.';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
