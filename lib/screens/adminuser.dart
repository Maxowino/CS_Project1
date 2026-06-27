import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersPage
extends StatelessWidget {

const AdminUsersPage({
super.key,
});

@override
Widget build(
BuildContext context,
) {

return Scaffold(

appBar:

AppBar(

automaticallyImplyLeading:
false,

title:
const Text(
"All Users",
),

),

body:

StreamBuilder<

QuerySnapshot<

Map<String,dynamic>

>

>(

stream:

FirebaseFirestore
.instance
.collection(
"users",
)
.snapshots(),

builder:
(
context,
snapshot,
){

if (
snapshot.connectionState ==
ConnectionState.waiting
){

return const Center(

child:
CircularProgressIndicator(),

);

}

if (
!snapshot.hasData ||

snapshot.data!.docs.isEmpty
){

return const Center(

child:
Text(
"No users found",
),

);

}

final users =
snapshot.data!.docs;

return ListView.builder(

padding:
const EdgeInsets.all(
12,
),

itemCount:
users.length,

itemBuilder:
(
context,
index,
){

final user =
users[index];

final data =
user.data();

String email =

data["email"]
??

"Unknown";

bool verified =

data["verified"]
??

false;

Timestamp?
verifiedAt =

data["verifiedAt"];

String timeText =

verifiedAt != null

?

verifiedAt
.toDate()
.toString()

:

"Not verified";

return Card(

margin:

const EdgeInsets.only(
bottom: 10,
),

shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(
16,
),

),

child:

ListTile(

contentPadding:

const EdgeInsets.symmetric(

horizontal:
16,

vertical:
10,

),

leading:

CircleAvatar(

backgroundColor:
Colors.black,

child:

Text(

email
.isNotEmpty

?

email[0]
.toUpperCase()

:

"U",

style:

const TextStyle(
color:
Colors.white,
),

),

),

title:

Text(

email,

style:

const TextStyle(

fontWeight:
FontWeight.bold,

),

),

subtitle:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

const SizedBox(
height: 6,
),

Text(

"Verified: ${verified ? "Yes" : "No"}",

style:

TextStyle(

color:

verified

?

Colors.green

:

Colors.red,

),

),

const SizedBox(
height: 4,
),

Text(
"Verified At: $timeText",
),

],

),

trailing:

Icon(

verified

?

Icons.verified

:

Icons.cancel,

color:

verified

?

Colors.green

:

Colors.red,

),

),

);

},

);

},

),

);

}

}