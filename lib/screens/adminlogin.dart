import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_project_1/screens/adminhomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({
    super.key,
  });

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

bool obscure =
true;

Future<void> login() async {

try {

setState(() {
loading = true;
});

UserCredential userCredential =

await FirebaseAuth
.instance
.signInWithEmailAndPassword(

email:
email.text.trim(),

password:
password.text,

);

String uid =
userCredential.user!.uid;

// ADMIN CHECK
DocumentSnapshot adminDoc =

await FirebaseFirestore
.instance
.collection("admin")
.doc(uid)
.get();

if (!adminDoc.exists) {

await FirebaseAuth
.instance
.signOut();

throw FirebaseAuthException(
code:
"not-admin",
);

}

if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(

behavior:
SnackBarBehavior.floating,

margin:

EdgeInsets.only(

bottom:

MediaQuery.of(context)
.size.height - 150,

left: 20,
right: 20,

),

backgroundColor:
Colors.green,

content:
const Text(
"Login successful",
),

),

);

Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:
(_)=>
const AdminHomePage(),

),

);

}

on FirebaseAuthException
catch (e) {

String message;

switch (e.code) {

case "user-not-found":
message =
"No admin account exists";
break;

case "wrong-password":
message =
"Incorrect password";
break;

case "invalid-email":
message =
"Enter a valid email";
break;

case "invalid-credential":
message =
"Incorrect email or password";
break;

case "not-admin":
message =
"Access denied. Not admin.";
break;

default:
message =
"Login failed";

}

if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(

behavior:
SnackBarBehavior.floating,

margin:

EdgeInsets.only(

bottom:

MediaQuery.of(context)
.size.height - 150,

left: 20,
right: 20,

),

backgroundColor:
Colors.red,

content:
Text(message),

),

);

}

finally {

if (mounted) {

setState(() {
loading = false;
});

}

}

}

@override
Widget build(
BuildContext context,
) {

return Scaffold(

backgroundColor:
Colors.grey.shade200,

body:

SafeArea(

child:

Center(

child:

SingleChildScrollView(

padding:
const EdgeInsets.all(
24,
),

child:

Container(

padding:
const EdgeInsets.all(
24,
),

decoration:

BoxDecoration(

color:
Colors.white,

borderRadius:
BorderRadius.circular(
20,
),

boxShadow: [

BoxShadow(

color:
Colors.black12,

blurRadius:
15,

),

],

),

child:

Column(

children: [

const Icon(

Icons.admin_panel_settings,

size:
70,

color:
Colors.black,

),

const SizedBox(
height: 20,
),

const Text(

"Admin Login",

style:
TextStyle(

fontSize:
28,

fontWeight:
FontWeight.bold,

),

),

const SizedBox(
height: 8,
),

Text(

"Login with admin account",

style:
TextStyle(

color:
Colors.grey.shade600,

),

),

const SizedBox(
height: 35,
),

TextField(

controller:
email,

decoration:

InputDecoration(

labelText:
"Email",

prefixIcon:
const Icon(
Icons.email,
),

border:

OutlineInputBorder(

borderRadius:
BorderRadius.circular(
15,
),

),

),

),

const SizedBox(
height: 18,
),

TextField(

controller:
password,

obscureText:
obscure,

decoration:

InputDecoration(

labelText:
"Password",

prefixIcon:
const Icon(
Icons.lock,
),

suffixIcon:

IconButton(

icon:

Icon(

obscure

?

Icons.visibility_off

:

Icons.visibility,

),

onPressed:
() {

setState(() {

obscure =
!obscure;

});

},

),

border:

OutlineInputBorder(

borderRadius:
BorderRadius.circular(
15,
),

),

),

),

const SizedBox(
height: 30,
),

SizedBox(

width:
double.infinity,

height:
55,

child:

ElevatedButton(

style:

ElevatedButton.styleFrom(

shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(
15,
),

),

),

onPressed:

loading

?

null

:

login,

child:

loading

?

const SizedBox(

width: 22,

height: 22,

child:
CircularProgressIndicator(
strokeWidth: 3,
),

)

:

const Text(

"Login",

style:
TextStyle(
fontSize: 18,
),

),

),

),

],

),

),

),

),

),

);

}

}