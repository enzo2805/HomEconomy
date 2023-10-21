import 'package:home/firebase/querys.dart';
import 'package:home/login_state.dart';
import 'package:home/widgets/category_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String category = "";
  int value = 0;

  String dateStr = "hoy";
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: GestureDetector(
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(Duration(hours: 24*30)),
              lastDate: DateTime.now(),
            ).then((newDate) {
              if (newDate != null) {
                setState(() {
                  date = newDate;
                  dateStr = "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
                });
              }
            });
          },
          child: Text(
            "Categoría ($dateStr)",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
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
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 100.0,
      child: CategorySelectionWidget(
        categories: {
          "Ropa": FontAwesomeIcons.tshirt,
          "Servicios": FontAwesomeIcons.moneyBill,
          "Seguros": FontAwesomeIcons.lock,
          "Limpieza": FontAwesomeIcons.pumpSoap,
          "Despensa": FontAwesomeIcons.shoppingCart,
          "Alimentos": FontAwesomeIcons.shoppingBag,
          "Comedores y \nRestaurantes" : Icons.restaurant_menu,
          "Alcohol": FontAwesomeIcons.glassMartini,
          "Entretenimiento": FontAwesomeIcons.tv,
          "Mantenimiento": FontAwesomeIcons.tools,
          "Salud": Icons.local_hospital,
          "Combustible": FontAwesomeIcons.gasPump,
          "Transporte": Icons.directions_bus,
          "Viajes": Icons.airplanemode_active,
          "Otros": Icons.all_inclusive,
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = value / 100.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Text(
        "\$${realValue.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 50.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (text == ",") {
            value = value * 100;
          } else {
            value = value * 10 + int.parse(text);
          }
        });
      },
      child: Container(
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _numpad() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var height = constraints.biggest.height / 4;

            return Table(
              border: TableBorder.all(
                color: Colors.grey,
                width: 1.0,
              ),
              children: [
                TableRow(children: [
                  _num("1", height),
                  _num("2", height),
                  _num("3", height),
                ]),
                TableRow(children: [
                  _num("4", height),
                  _num("5", height),
                  _num("6", height),
                ]),
                TableRow(children: [
                  _num("7", height),
                  _num("8", height),
                  _num("9", height),
                ]),
                TableRow(children: [
                  _num(",", height),
                  _num("0", height),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        value = value ~/ 10;
                      });
                    },
                    child: Container(
                      height: height,
                      child: Center(
                        child: Icon(
                          Icons.backspace,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            );
          }),
    );
  }

  Widget _submit() {
    return Builder(builder: (BuildContext context) {
      return Hero(
        tag: "add_button",
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: MaterialButton(
            child: Text(
              "Agregar gasto",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onPressed: () {
              var user = Provider.of<LoginState>(context, listen: false).currentUser();
              if (value > 0 && category != "") {
                var data;
                var misString = category.replaceAll("\n", "");
                data={
                  "category": misString,
                  "value": value / 100.0,
                  "month": date.month,
                  "day": date.day,
                  "year": date.year
                };
                setExpenses(user.uid, data);

                Navigator.of(context).pop();
              } else {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Selecciona un monto y categoría válidos")));
              }
            },
          ),
        ),
      );
    });
  }
}