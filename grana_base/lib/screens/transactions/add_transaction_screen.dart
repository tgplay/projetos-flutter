import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/category_model.dart';
import '../../models/transaction_model.dart';
import '../../services/category_service.dart';
import '../../services/transaction_service.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final CategoryService _categoryService = CategoryService();
  final TransactionService _transactionService = TransactionService();

  bool _isLoading = false;
  String _type = 'expense';
  DateTime _selectedDate = DateTime.now();
  CategoryModel? _selectedCategory;
  List<CategoryModel> _categories = [];

  bool get _isEditMode => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    _setupInitialValues();
  }

  void _setupInitialValues() {
    final transaction = widget.transaction;

    if (transaction != null) {
      _type = transaction.type;
      _selectedDate = transaction.transactionDate;
      _amountController.text = transaction.amount.toString();
      _descriptionController.text = transaction.description ?? '';
    }

    _loadCategories(initialCategoryId: transaction?.categoryId);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories({String? initialCategoryId}) async {
    setState(() {
      _isLoading = true;
      _selectedCategory = null;
    });

    try {
      final categories = await _categoryService.getCategoriesByType(_type);

      if (!mounted) return;

      CategoryModel? selected;

      if (initialCategoryId != null) {
        for (final category in categories) {
          if (category.id == initialCategoryId) {
            selected = category;
            break;
          }
        }
      }

      setState(() {
        _categories = categories;
        _selectedCategory = selected;
      });
    } catch (e) {
      if (!mounted) return;

      debugPrint('Erro ao carregar categorias: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar categorias')),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _openCreateCategoryDialog() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) =>
          _CreateCategoryDialog(type: _type, categoryService: _categoryService),
    );

    if (created == true) {
      await _loadCategories();
    }
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma categoria')));
      return;
    }

    final rawAmount = _amountController.text.trim().replaceAll(',', '.');
    final amount = double.tryParse(rawAmount);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe um valor válido')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditMode) {
        await _transactionService.updateTransaction(
          transactionId: widget.transaction!.id,
          categoryId: _selectedCategory!.id,
          type: _type,
          amount: amount,
          transactionDate: _selectedDate,
          description: _descriptionController.text,
        );
      } else {
        await _transactionService.createTransaction(
          categoryId: _selectedCategory!.id,
          type: _type,
          amount: amount,
          transactionDate: _selectedDate,
          description: _descriptionController.text,
        );
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      debugPrint('Erro ao salvar transação: $e');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar transação: $e')));
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar transação' : 'Nova transação'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'expense',
                      label: Text('Despesa'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                    ButtonSegment<String>(
                      value: 'income',
                      label: Text('Receita'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: _isLoading
                      ? null
                      : (value) async {
                          setState(() {
                            _type = value.first;
                            _selectedCategory = null;
                          });
                          await _loadCategories();
                        },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory?.id,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  onChanged: _isLoading || _categories.isEmpty
                      ? null
                      : (value) {
                          final category = _categories.firstWhere(
                            (item) => item.id == value,
                          );

                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                  validator: (_) {
                    if (_selectedCategory == null) {
                      return 'Selecione uma categoria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : _openCreateCategoryDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Nova categoria'),
                  ),
                ),
                if (_categories.isEmpty && !_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nenhuma categoria cadastrada para esse tipo.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    hintText: 'Ex.: 150.75',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Informe o valor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _isLoading ? null : _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data da transação',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dateFormat.format(_selectedDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            _isEditMode
                                ? 'Salvar alterações'
                                : 'Salvar transação',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateCategoryDialog extends StatefulWidget {
  final String type;
  final CategoryService categoryService;

  const _CreateCategoryDialog({
    required this.type,
    required this.categoryService,
  });

  @override
  State<_CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<_CreateCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.categoryService.createCategory(
        name: _nameController.text,
        type: widget.type,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('Erro ao criar categoria: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao criar categoria: $e')));
    } finally {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeLabel = widget.type == 'income' ? 'receita' : 'despesa';

    return AlertDialog(
      title: const Text('Nova categoria'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Nome da categoria',
            hintText:
                'Ex.: ${widget.type == 'income' ? 'Salário' : 'Alimentação'}',
          ),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) {
              return 'Informe o nome da categoria';
            }
            if (text.length < 2) {
              return 'Informe pelo menos 2 caracteres';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveCategory,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Salvar $typeLabel'),
        ),
      ],
    );
  }
}
