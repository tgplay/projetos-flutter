import 'package:flutter/material.dart';

import '../../core/services/sound_service.dart';
import '../../models/reserve_contribution_model.dart';
import '../../services/reserve_contribution_service.dart';

class AddReserveContributionScreen extends StatefulWidget {
  final String reserveGoalId;
  final ReserveContributionModel? contribution;

  const AddReserveContributionScreen({
    super.key,
    required this.reserveGoalId,
    this.contribution,
  });

  @override
  State<AddReserveContributionScreen> createState() =>
      _AddReserveContributionScreenState();
}

class _AddReserveContributionScreenState
    extends State<AddReserveContributionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ReserveContributionService _reserveContributionService =
      ReserveContributionService();

  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  bool get _isEditing => widget.contribution != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _amountController.text = widget.contribution!.amount.toStringAsFixed(2);
      _descriptionController.text = widget.contribution!.description ?? '';
      _selectedDate = widget.contribution!.contributionDate;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveContribution() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final amount = double.parse(
        _amountController.text.trim().replaceAll(',', '.'),
      );

      final description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim();

      if (_isEditing) {
        await _reserveContributionService.updateContribution(
          contributionId: widget.contribution!.id,
          amount: amount,
          description: description,
          contributionDate: _selectedDate,
        );
      } else {
        await _reserveContributionService.createContribution(
          reserveGoalId: widget.reserveGoalId,
          amount: amount,
          description: description,
          contributionDate: _selectedDate,
        );
      }

      if (!mounted) return;

      if (!_isEditing) SoundService().playReserveContribution();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Aporte atualizado com sucesso.'
                : 'Aporte registrado com sucesso.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('AddReserveContributionScreen _saveContribution error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Erro ao atualizar aporte: $e'
                : 'Erro ao registrar aporte: $e',
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar aporte' : 'Novo aporte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor do aporte',
                  hintText: 'Ex: 250.00',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o valor do aporte.';
                  }

                  final parsedValue = double.tryParse(
                    value.trim().replaceAll(',', '.'),
                  );

                  if (parsedValue == null) {
                    return 'Informe um valor válido.';
                  }

                  if (parsedValue <= 0) {
                    return 'O aporte deve ser maior que zero.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Ex: Aporte do mês',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data do aporte',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDate(_selectedDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveContribution,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isEditing ? 'Salvar alterações' : 'Salvar aporte',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
