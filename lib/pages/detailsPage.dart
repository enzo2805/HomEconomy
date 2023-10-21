import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home/firebase/querys.dart';
import 'package:home/login_state.dart';
import 'package:provider/provider.dart';

class DetailsParams {
  final String categoryName;
  final int month;
  final int year;

  DetailsParams(this.categoryName, this.month, this.year);
}

class DetailsPage extends StatefulWidget {
  final DetailsParams params;

  const DetailsPage({Key key, this.params}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int currentYear;

  @override
  Widget build(BuildContext context) {
    currentYear = widget.params.year;
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget child) {
        var user = Provider.of<LoginState>(context, listen: false).currentUser().uid;
        var _query = getCategoryExpenses(
            user,
            widget.params.month,
            widget.params.categoryName,
            currentYear
        );

        return Scaffold(
            appBar: AppBar(
              title: Text(widget.params.categoryName),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _query,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                if (data.hasData) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var document = data.data.docs[index];

                      return Dismissible(
                        key: Key(document.id),
                        onDismissed: (direction) {
                          deleteExpense(user, document.id);
                        },
                        child: ListTile(
                          leading: Stack(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: 40,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 8,
                                child: Text(
                                  document["day"].toString(),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                          title: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\$${document["value"]}",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: data.data.docs.length,
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ));
      },
    );
  }
}