import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_project_1/screens/adminhomepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() =>
      _AdminLoginPageState();
}

class _AdminLoginPageState
extends State<AdminLoginPage> {

final email =
TextEditingController();

final password =
TextEditingController();

bool loading = false;

Future<void> login() async {

try {

setState(() {
loading = true;
});

UserCredential userCredential =

await FirebaseAuth.instance.signInWithEmailAndPassword(
email: email.text.trim(),
password: password.text,
);

String uid =userCredential.user!.uid;
// CHECK IF ADMIN
DocumentSnapshot adminDoc =

await FirebaseFirestore.instance.collection("admin").doc(uid).get();
if (!adminDoc.exists) {
await FirebaseAuth.instance.signOut();
if (!mounted) return;
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content:
Text(
"Access denied. Not admin.",
),
),

);

return;

}

if (!mounted) return;

Navigator.pushReplacement(

context,

MaterialPageRoute(
builder:
(_)=>
const AdminHomePage(),
),

);

}

catch (e) {

ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(
content:
Text(
e.toString(),
),
),

);

}

if (mounted) {

setState(() {
loading = false;
});

}

}

@override
Widget build(BuildContext context) {

return Scaffold(

appBar:
AppBar(
title:
const Text(
"Admin Login",
),
),

body:

Padding(

padding:
const EdgeInsets.all(20),

child:

Column(

children: [

TextField(
controller: email,
decoration:
const InputDecoration(
labelText:
"Email",
),
),

const SizedBox(
height: 20,
),

TextField(
controller: password,
obscureText: true,
decoration:
const InputDecoration(
labelText:
"Password",
),
),

const SizedBox(
height: 30,
),

ElevatedButton(

onPressed:
loading
? null
: login,

child:

loading
? const CircularProgressIndicator()
: const Text(
"Login",
),

),

],

),

),

);

}

}