import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home/widgets/expenses.dart';
import 'package:home/widgets/graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:home/widgets/list_widget.dart';

enum GraphType {
  LINES,
  PIE
}

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;
  final GraphType graphType;
  final int month;
  final int year;

  MonthWidget({Key key, this.graphType, this.documents, @required this.month, this.year, days})
      :
        total = documents.map((doc) => doc['value'])
            .fold(0.0, (a, b) => a + b),
        perDay = List.generate(days, (int index) {
          return documents.where((doc) => doc['day'] == (index + 1))
              .map((doc) => doc['value'])
              .fold(0.0, (a, b) => a + b);
        }),

        categories = documents.fold({}, (Map<String, double> map, document) {
          if (!map.containsKey(document['category'])) {
            print(document['category']);
            map[document['category']] = 0.0;
          }

          map[document['category']] += document['value'];
          return map;
        }),
        super(key: key);

  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          ExpensesWidget(total: widget.total,),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 8.0,
          ),
          ListWidget(widget.total, widget.categories, context, widget.month, widget.year),
        ],
      ),
    );
  }

  Widget _graph() {
    if (widget.graphType == GraphType.LINES){
      return Container(
        height: 180.0,
        child: LineGraphWidget(
          data: widget.perDay,
          type: 'month',
        ),
      );
    } else {
      var perCategory = widget.categories.keys.map((name) => widget.categories[name] / widget.total).toList();
      var names = widget.categories.keys.toList();
      return Container(
        height: 180.0,
        child: PieGraphWidget(
          data: perCategory,
          name: names
        ),
      );
    }
  }

}
