import 'package:flutter/material.dart';
import 'package:home/login_state.dart';
import 'package:home/pages/authWithEmail.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Text(
              "HomEconomY!",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline4.fontSize,
                fontWeight: Theme.of(context).textTheme.headline4.fontWeight,
                fontFamily: Theme.of(context).textTheme.headline4.fontFamily,
                color: Colors.blue
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/login_screen.png'),
            ),
            Text(
              "Tu aplicación personal de finanzas",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.caption.fontSize,
                  fontWeight: Theme.of(context).textTheme.caption.fontWeight,
                  fontFamily: Theme.of(context).textTheme.caption.fontFamily,
                  color: Colors.blue
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Consumer<LoginState>(
              builder: (BuildContext context, LoginState value, Widget child) {
                if (value.isLoading()) {
                  return CircularProgressIndicator();
                } else {
                  return child;
                }
              },
              child: Column(
                children: [
                  RaisedButton(
                    child: Text("Iniciar sesión con Google"),
                    onPressed: () {
                      Provider.of<LoginState>(context, listen: false).login(null, null);
                    },
                  ),
                  RaisedButton(
                    child: Text("Iniciar sesión con email"),
                    onPressed: () {
                      LoginDialog().loginDialog();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
