
 import 'package:expense_tracker/lib/models/Expence.dart';
import 'package:expense_tracker/lib/widget/New_Expense.dart';
import 'package:expense_tracker/lib/widget/chart/chart.dart';
import 'package:expense_tracker/lib/widget/expense_list/Expenses_list.dart';
import'package:flutter/material.dart';
class Expenses extends StatefulWidget{
  const Expenses({super.key});
   @override
  State<Expenses> createState(){
     return _ExpencesState();
   }
}

class _ExpencesState extends State<Expenses>{
  final List<Expense> _registeredExpenses =[
    Expense(
    title: 'Flutter Course',
      amount: 599.9,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 20.9,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];
  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx)=>  NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex=_registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Expense deleted Successfully'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: (){
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
      ),
    );

  }

  @override
  Widget build(BuildContext context){
  final width= MediaQuery.of(context).size.width;
    Widget mainContent = const Center(child: Text('No expnses found. start adding some!'),
    );

    if(_registeredExpenses.isNotEmpty){
      mainContent=ExpensesList(
      expenses: _registeredExpenses,
      onRemoveExpense: _removeExpense
    );
    }

    return  Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(icon:const Icon(Icons.add),
              onPressed: _openAddExpenseOverlay),
        ],
      ),
     body:width<600
         ? Column(
       children:[
          Chart(expenses: _registeredExpenses),
         Expanded(
             child: mainContent,
         ),
       ],
     )
    : Row(
       children:[
         Expanded(
             child: Chart(
                 expenses: _registeredExpenses
             )
         ),
         Expanded(
           child: mainContent,
         ),
       ],
     )
    );
  }
}