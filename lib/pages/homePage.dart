import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home/firebase/querys.dart';
import 'package:home/login_state.dart';
import 'package:home/pages/yearPage.dart';
import 'package:home/utils.dart';
import 'package:home/widgets/month_widget.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:home/widgets/appDrawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller;
  int currentPage = DateTime.now().month-1;
  int currentYear = DateTime.now().year;
  Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES;

  DateTime date = DateTime.now();
  String dateStr = "${DateTime.now().year.toString()}";

  Widget _bottomAction(IconData icon, Function callback){
    return InkWell(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: Colors.white,
          )
      ),
      onTap: callback,
      splashColor: Colors.blue,
      radius: 20,
    );
  }

  @override
  void initState(){
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget child) {
        var user = Provider.of<LoginState>(context, listen: false).currentUser();
        _query = getExpenses(user.uid, currentPage, date.year);
        return Scaffold(
          appBar: AppBar(
            title: Text('HEY!'),
          ),
          drawer: AppDrawer(),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              color: Colors.blue,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomAction(FontAwesomeIcons.chartLine, () {
                    setState(() {
                      currentType = GraphType.LINES;
                    });
                  }),
                  _bottomAction(FontAwesomeIcons.chartPie, () {
                    setState(() {
                      currentType = GraphType.PIE;
                    });
                  }),
                  SizedBox(width: 32.0),
                  _bottomAction(FontAwesomeIcons.calendarCheck, () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => new AlertDialog(
                          title: new Text("Selecciona el año"),
                          content: NumberPicker.integer(
                              initialValue: date.year,
                              minValue: DateTime.now().year-5,
                              maxValue: DateTime.now().year,
                              onChanged: (newDate){
                                setState(() {
                                  date = DateTime(newDate);
                                  dateStr = "${date.year.toString()}";
                                });
                              }
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Aceptar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        )
                    );
                  }),
                  _bottomAction(Icons.score, () async {
                    QuerySnapshot data = await getExpensesPerYear(user.uid, date.year);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YearPage(documents: data.docs,)),
                    );
                  })
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            heroTag: "add_button",
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/add');
            },
          ),
          body: _body(),
        );
      }
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.connectionState == ConnectionState.active) {
                if (data.data.docs.length > 0){
                  return MonthWidget(
                    days: daysInMonth(currentPage + 1),
                    documents: data.data.docs,
                    graphType: currentType,
                    month: currentPage,
                    year: date.year,
                  );
                }else {
                  return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                            'assets/no_data.png'
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: SizedBox(
                            height: 80
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          "No se encontraron datos.",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                );
                }
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Column(
        children: [
          Text(
            name,
            style: position == currentPage ? selected : unselected,
          ),
          Text(
            '($dateStr)',
            style: position == currentPage ?
            TextStyle(
              fontWeight: selected.fontWeight,
              color: selected.color,
              fontSize: 16
            ) :
            TextStyle(
                fontWeight: unselected.fontWeight,
                color: unselected.color,
                fontSize: 16
            ),
          )
        ],
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(50.0),
      child: PageView(
        onPageChanged: (newPage) {
          var user = Provider.of<LoginState>(context, listen: false).currentUser();
          setState(() {
            currentPage = newPage;
            _query = getExpenses(user.uid, currentPage, date.year);
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }
}