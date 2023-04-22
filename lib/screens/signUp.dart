import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:buskz/screens/route.dart';
import 'package:buskz/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String _email, _password, name;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> createUserDocument() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    if (user != null) {
      // Create a document for the user using their UID
      final DocumentReference userDocRef = usersCollection.doc(user.uid);

      // Set initial data for the user
      final Map<String, dynamic> userData = {
        'email': user.email,
        'displayName': user.displayName,
        // Add any other user data you want to store as JSON here
      };

      // Set the user data in the document
      await userDocRef.set(userData);
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('тіркелу'),
        centerTitle: true,
        leading: Icon(Icons.app_registration),
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
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Required field';
                    }
                  },
                  onSaved: (input) => name = input!,
                  decoration: const InputDecoration(
                    labelText: 'аты',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signUp();
                  },
                  child: const Text('тіркелу'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Сізде бұрыннан тіркелгі бар ма? '),
                        TextSpan(
                          text: 'Кіру',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
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

  Future signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential user =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        await user.user!.updateDisplayName(name);
        await createUserDocument();
        final Uint8List emptyData = Uint8List.fromList([]);
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('users/${user.user!.uid}/avatar.jpg');

        await storageRef.putData(emptyData);

        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Page1()));
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
