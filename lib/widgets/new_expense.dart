import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget{
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense>{
  final _titleController = TextEditingController();
  Category _selectedCategory = Category.leisure;
  final _amountController = TextEditingController();
  DateTime ? _selecteDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final  pickedDate = await showDatePicker(
      context: context,
      initialDate: now, 
      firstDate: firstDate, 
      lastDate: now
      );
      setState(() {
        _selecteDate = pickedDate;
      });
  }

  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if(_titleController.text.trim().isEmpty
       || amountIsInvalid || _selecteDate == null){
        showDialog(
          context: context, 
          builder: (ctx) => AlertDialog(
            title: const Text('Invalid input'),
            content: const Text('Pleas make sure a valid title, amount, date and category was entered.'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(ctx);
              }, 
              child: const Text('OK')
              )
            ],
          )
        );
        return;
       }

       widget.onAddExpense(
        Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selecteDate!,
          category: _selectedCategory
        ),
       );
       Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text('Title')
                ),
              ),
              Row(
                children: [
                Expanded(
                  child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount')
                  ),
                            ),
                ),
              const SizedBox(width: 16,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Text(
                      _selecteDate == null
                      ? 'No date selected'
                      : formatter.format(_selecteDate!)
                    ),
                    IconButton(
                      onPressed: _presentDatePicker, 
                      icon: const Icon(
                        Icons.calendar_month
                      )
                    )
                  ],
                ),
              )
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values.map(
                      (Category) => DropdownMenuItem(
                        value: Category,
                        child: Text(
                          Category.name.toUpperCase(),
                          ),
                        )
                    ).toList(), 
                    onChanged: (value){
                      if(value == null){
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    child: const Text('Cancle')
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitExpenseData();
                    }, 
                    child: const Text('Save Expense')
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}