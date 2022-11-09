import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;
  final String day;
  final _formKey = GlobalKey<FormState>();

  MyTransaction({
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    var date;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey[100],
          child: Row(
            key: _formKey,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.yellow[600]),
                    child: Center(
                      child: Icon(
                        Icons.attach_money_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(transactionName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      )),
                ],
              ),
              Text(
                day +
                    '   ' +
                    (expenseOrIncome == 'expense' ? '-' : '+') +
                    '\฿' +
                    money

                // +
                // (DateFormat("dd/MM/yyyy").format(date.date))
                ,
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:
                      expenseOrIncome == 'expense' ? Colors.red : Colors.green,
                ),
              ),
              MaterialButton(
                color: Colors.red[600],
                child: Text('ลบ', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  //   // _enterTransaction();
                  Navigator.of(context).pop();
                  // }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
