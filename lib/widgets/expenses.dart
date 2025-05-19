import 'package:demo3/widgets/charts/chart.dart';
import 'package:demo3/widgets/expenses_list/expenses_list.dart';
import 'package:demo3/models/expense.dart';
import 'package:demo3/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Flutter',
      amount: 19.99,
      date: DateTime.now(),
      category: ExpenseCategory.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 5.45,
      date: DateTime.now(),
      category: ExpenseCategory.leisure,
    ),
  ];

  void addExpense(Expense exp) {
    setState(() {
      _expenses.add(exp);
    });
  }

  void removeExpense(Expense exp) {
    final expenseIndex = _expenses.indexOf(exp);
    setState(() {
      _expenses.remove(exp);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.insert(expenseIndex, exp);
            });
          },
        ),
        content: Text('Expense deleted'),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text("No Expenses"));

    if (_expenses.isNotEmpty) {
      mainContent = ExpensesList(expenses: _expenses, onRemove: removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense tracker'),
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _expenses), 
          Expanded(child: mainContent)
        ],
      ),
    );
  }
}
