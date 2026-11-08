import 'package:flutter/material.dart';

import 'items_controller.dart';
import 'lost_item.dart';

class ItemFormPage extends StatefulWidget {
  const ItemFormPage({super.key, required this.controller});

  final ItemsController controller;

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  ItemStatus? _status;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _status == null) {
      if (_status == null) setState(() {});
      return;
    }

    final saved = await widget.controller.addItem(
      name: _nameController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      status: _status!,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? 'Falha ao salvar.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Cadastrar objeto')),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  controller: _nameController,
                  maxLength: 60,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nome do objeto',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe o nome do objeto.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  maxLength: 200,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe a descrição.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Local',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe o local.'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ItemStatus>(
                  initialValue: _status,
                  decoration: const InputDecoration(
                    labelText: 'Situação',
                    border: OutlineInputBorder(),
                  ),
                  items: ItemStatus.values
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ))
                      .toList(),
                  onChanged: widget.controller.isSaving
                      ? null
                      : (value) => setState(() => _status = value),
                  validator: (value) => value == null
                      ? 'Selecione se o objeto foi perdido ou encontrado.'
                      : null,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: widget.controller.isSaving ? null : _submit,
                  icon: widget.controller.isSaving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                      widget.controller.isSaving ? 'Salvando...' : 'Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
