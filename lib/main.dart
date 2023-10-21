import 'package:flutter/material.dart';
import 'package:home/firebase/initialization.dart';
import 'package:home/pages/authWithEmail.dart';
import 'package:home/pages/homePage.dart';
import 'package:home/pages/addPage.dart';
import 'package:home/pages/detailsPage.dart';
import 'package:home/pages/loginPage.dart';
import 'package:home/login_state.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDefault();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments;
            return MaterialPageRoute(
                builder: (BuildContext context) {
                  return DetailsPage(
                    params: params ,
                  );
                }
            );
          }
        },
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if(state.isLoggedIn()){
              return HomePage();
            } else {
              return LoginPage();
            }
          },
          '/add': (BuildContext context) => AddPage(),
        },
      ),
    );
  }
}




