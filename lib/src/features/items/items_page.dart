import 'package:flutter/material.dart';

import 'item_form_page.dart';
import 'items_controller.dart';
import 'lost_item.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key, required this.controller});

  final ItemsController controller;

  Future<void> _openForm(BuildContext context) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ItemFormPage(controller: controller),
      ),
    );
    if (!context.mounted) return;
    if (saved == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Achados e Perdidos'),
          actions: [
            IconButton(
              tooltip: 'Atualizar lista',
              onPressed: controller.isLoading ? null : controller.loadItems,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: _buildBody(context),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(context),
          icon: const Icon(Icons.add),
          label: const Text('Cadastrar objeto'),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading && controller.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.errorMessage != null && controller.items.isEmpty) {
      return _MessageState(
        message: controller.errorMessage!,
        actionLabel: 'Tentar novamente',
        onAction: controller.loadItems,
      );
    }
    if (controller.items.isEmpty) {
      return const _MessageState(
        message: 'Nenhum objeto cadastrado ainda.',
      );
    }

    return RefreshIndicator(
      onRefresh: controller.loadItems,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        itemCount:
            controller.items.length + (controller.errorMessage == null ? 0 : 1),
        itemBuilder: (context, index) {
          if (controller.errorMessage != null && index == 0) {
            return MaterialBanner(
              leading: const Icon(Icons.error_outline),
              content: Text(controller.errorMessage!),
              actions: [
                TextButton(
                  onPressed: controller.loadItems,
                  child: const Text('Tentar novamente'),
                ),
              ],
            );
          }

          final itemIndex = index - (controller.errorMessage == null ? 0 : 1);
          return _ItemCard(item: controller.items[itemIndex]);
        },
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});

  final LostItem item;

  @override
  Widget build(BuildContext context) {
    final isLost = item.status == ItemStatus.lost;
    final color = isLost ? Colors.deepOrange : Colors.green;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.name,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Chip(
                  label: Text(item.status.label),
                  avatar:
                      Icon(isLost ? Icons.search : Icons.check_circle_outline),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: color.withValues(alpha: 0.35)),
                  backgroundColor: color.withValues(alpha: 0.08),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.description),
            const SizedBox(height: 8),
            Text('Local: ${item.location}'),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
