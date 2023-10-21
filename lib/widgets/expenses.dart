
import 'package:flutter/material.dart';
class ExpensesWidget extends StatelessWidget {

  final double total;

  ExpensesWidget({Key key, this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("\$${total.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32.0,
          ),
        ),
        Text("Total gastado",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}