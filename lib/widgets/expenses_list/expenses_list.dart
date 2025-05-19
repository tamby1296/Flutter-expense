import 'package:demo3/models/expense.dart';
import 'package:demo3/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses, required this.onRemove});

  final List<Expense> expenses;
  final void Function(Expense) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder:
          (ctx, i) => Dismissible(
            background: Container(
              color: Theme.of(context).colorScheme.error,
              margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
            ),
            key: ValueKey(expenses[i].id),
            onDismissed: (direction) {
              onRemove(expenses[i]);
            },
            child: ExpenseItem(expense: expenses[i]),
          ),
    );
  }
}
