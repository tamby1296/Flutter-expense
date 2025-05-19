import 'package:demo3/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime? _selectedDate;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final amount = double.tryParse(_amountController.text);
    final invalidAmount = amount == null || amount <= 0;

    if (_titleController.text.trim().isEmpty ||
        invalidAmount ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Invalid input'),
              content: Text('Validate data'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(label: Text('Title')),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text('Amount'),
                    prefixText: '\$ ',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _selectedDate == null
                          ? "No date selected"
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              DropdownButton(
                value: _selectedCategory,
                items:
                    ExpenseCategory.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value == null) return;
                    setState(() {
                      _selectedCategory = value;
                    });
                  });
                },
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
