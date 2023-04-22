import 'package:buskz/screens/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:buskz/screens/route.dart';
import 'package:buskz/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _email, _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Кіру'),
        leading: Icon(Icons.login),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Please type an email';
                    }
                  },
                  onSaved: (input) => _email = input!,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  validator: (input) {
                    if (input!.length < 6) {
                      return 'Your password needs to be at least 6 characters';
                    }
                  },
                  onSaved: (input) => _password = input!,
                  decoration: const InputDecoration(
                    labelText: 'Құпия сөз',
                  ),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () async{
                   await signUp(context);
                  },
                  child: const Text('Sign Up'),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Есептік жазбаңыз жоқ па? '),
                        TextSpan(
                          text: 'тіркелу',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                              // Обработка нажатия на ссылку
                            },
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential user =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
       await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Page1()));
        print(user);
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message.toString(),
          gravity: ToastGravity.CENTER,
        );
        print(e);
      }
    }
  }
}