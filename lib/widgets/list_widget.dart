
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home/pages/detailsPage.dart';

class ListWidget extends StatelessWidget {

  final double total;
  final Map<String, double> categories;
  final BuildContext context;
  final int month;
  final int year;


  ListWidget(this.total, this.categories, this.context, this.month, this.year);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = categories.keys.elementAt(index);
          var data = categories[key];
          var tot = total;
          IconData customIcon;
          switch (key){
            case 'Ropa':{
              customIcon = FontAwesomeIcons.shoppingCart;
              break;
            }
            case 'Alcohol':{
              customIcon = FontAwesomeIcons.glassMartini;
              break;
            }
            case 'Servicios':{
              customIcon = FontAwesomeIcons.wallet;
              break;
            }
            case 'Alimentos':{
              customIcon = FontAwesomeIcons.shoppingBag;
              break;
            }
            case 'Limpieza':{
              customIcon = FontAwesomeIcons.pumpSoap;
              break;
            }
            case 'Despensa':{
              customIcon = FontAwesomeIcons.shoppingCart;
              break;
            }
            case 'Entretenimiento':{
              customIcon = FontAwesomeIcons.tv;
              break;
            }
            case 'Mantenimiento':{
              customIcon = FontAwesomeIcons.tools;
              break;
            }
            case 'Salud':{
              customIcon = Icons.local_hospital;
              break;
            }
            case 'Combustible':{
              customIcon = FontAwesomeIcons.gasPump;
              break;
            }
            case 'Seguros':{
              customIcon = FontAwesomeIcons.lock;
              break;
            }
            case 'Comedores y Restaurantes':{
              customIcon = Icons.restaurant_menu;
              break;
            }
            case 'Transporte':{
              customIcon = Icons.directions_bus;
              break;
            }
            case 'Viajes':{
              customIcon = Icons.airplanemode_active;
              break;
            }
            case 'Otros':{
              customIcon = Icons.all_inclusive;
              break;
            }
          }
          return _item(customIcon, key, 100 * data ~/ tot, data);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 8.0,
          );
        },
      ),
    );
  }


  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      onTap: (){
        if (month != null){
          print('month_widget: '+month.toString());
          Navigator.of(context).pushNamed("/details",
              arguments: DetailsParams(name, month, year));
        }
      },
      leading: Icon(icon, size: 30.0, color: Colors.lightBlue[600],),
      title: Text(name,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0
        ),
      ),
      subtitle: Text("$percent% del total gastado",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value.toStringAsFixed(2),
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
