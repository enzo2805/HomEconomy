
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home/widgets/expenses.dart';
import 'package:home/widgets/graph_widget.dart';
import 'package:home/widgets/list_widget.dart';
import 'package:home/widgets/month_widget.dart';

class YearPage extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perMonth;
  final Map<String, double> categories;


  YearPage({Key key, this.documents})
      :
        total = documents.map((doc) => doc['value'])
            .fold(0.0, (a, b) => a + b),
        perMonth = List.generate(12, (int index) {
          return documents.where((doc) => doc['month'] == (index + 1))
              .map((doc) => doc['value'])
              .fold(0.0, (a, b) => a + b);
        }),

        categories = documents.fold({}, (Map<String, double> map, document) {
          if (!map.containsKey(document['category'])) {
            map[document['category']] = 0.0;
          }

          map[document['category']] += document['value'];
          return map;
        }),
        super(key: key);

  @override
  _YearPageState createState() => _YearPageState();
}

class _YearPageState extends State<YearPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: <Widget>[
                  ExpensesWidget(total: widget.total,),
                  Container(
                    height: 200.0,
                    child: FractionallySizedBox(
                      widthFactor: .9,
                      child: LineGraphWidget(
                        data: widget.perMonth,
                        type: 'year',
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.blueAccent.withOpacity(0.15),
                    height: 8.0,
                  ),
                  ListWidget(widget.total, widget.categories, context, null, null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
