import 'package:home/login_state.dart';
import 'package:flutter/material.dart';
import 'package:home/pages/loginPage.dart';
import 'package:provider/provider.dart';

class LoginDialog{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  Future<void> loginDialog(){
    return showDialog(
      context: scaffoldKey.currentContext,
      builder: (context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text(
                'Iniciar Sesión'
            ),
          ),
          content: SafeArea(
            child: Form(
              key: _formKey,
              child: Container(
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese el email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText:
                        'Contraseña'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese su contraseña';
                          }
                          return null;
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Provider.of<LoginState>(context, listen: false).login(_emailController.text, _passwordController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Aceptar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
