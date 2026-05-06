import 'package:flutter/material.dart';

import '../../models/reserve_goal_model.dart';
import '../../services/reserve_goal_service.dart';

class AddReserveGoalScreen extends StatefulWidget {
  final ReserveGoalModel? reserveGoal;

  const AddReserveGoalScreen({super.key, this.reserveGoal});

  @override
  State<AddReserveGoalScreen> createState() => _AddReserveGoalScreenState();
}

class _AddReserveGoalScreenState extends State<AddReserveGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ReserveGoalService _reserveGoalService = ReserveGoalService();

  bool _isSaving = false;

  bool get _isEditing => widget.reserveGoal != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _targetAmountController.text = widget.reserveGoal!.targetAmount
          .toStringAsFixed(2);
      _descriptionController.text = widget.reserveGoal!.description ?? '';
    }
  }

  @override
  void dispose() {
    _targetAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveReserveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final targetAmount = double.parse(
        _targetAmountController.text.replaceAll(',', '.'),
      );

      final description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim();

      if (_isEditing) {
        await _reserveGoalService.updateReserveGoal(
          reserveGoalId: widget.reserveGoal!.id,
          targetAmount: targetAmount,
          description: description,
        );
      } else {
        await _reserveGoalService.createReserveGoal(
          targetAmount: targetAmount,
          description: description,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Meta de reserva atualizada com sucesso.'
                : 'Meta de reserva criada com sucesso.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('AddReserveGoalScreen _saveReserveGoal error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Erro ao atualizar meta de reserva: $e'
                : 'Erro ao salvar meta de reserva: $e',
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar meta de reserva' : 'Nova meta de reserva',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _targetAmountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor da meta',
                  hintText: 'Ex: 5000.00',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o valor da meta.';
                  }

                  final parsedValue = double.tryParse(
                    value.trim().replaceAll(',', '.'),
                  );

                  if (parsedValue == null) {
                    return 'Informe um valor válido.';
                  }

                  if (parsedValue <= 0) {
                    return 'O valor da meta deve ser maior que zero.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Ex: Reserva de emergência',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveReserveGoal,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Salvar alterações' : 'Salvar meta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
