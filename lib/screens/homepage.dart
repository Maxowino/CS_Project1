import 'dart:convert';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_project_1/screens/selectAction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cs_project_1/screens/report.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
extends State<HomePage> {

Position? currentPosition;

bool loading = true;

final List<Marker>
markers = [];

final List<CircleMarker>
floodZones = [];

// WEATHER
double rainfall = 0;

String weatherText =
"Loading...";

String updatedAt =
"--";

Timer? weatherTimer;

@override
void initState() {
super.initState();
loadLocation();
}

Future<void>
loadLocation()
async {

bool enabled =
await Geolocator
.isLocationServiceEnabled();

if (!enabled) return;

LocationPermission permission =
await Geolocator
.requestPermission();

if (
permission ==
LocationPermission.denied
) {
return;
}

currentPosition =
await Geolocator
.getCurrentPosition();

markers.add(

Marker(

point:

LatLng(
currentPosition!.latitude,
currentPosition!.longitude,
),

width: 60,

height: 60,

child:

const Icon(
Icons.my_location,
size: 40,
color: Colors.blue,
),

),

);

await loadReports();

await loadWeather();

startWeatherUpdates();

setState(() {
loading = false;
});

}

Future<void> loadWeather()
async {

if (
currentPosition == null
) return;

final url =
Uri.parse(

"https://api.open-meteo.com/v1/forecast"
"?latitude=${currentPosition!.latitude}"
"&longitude=${currentPosition!.longitude}"
"&current=rain"

);

final response =
await http.get(
url,
);

if (
response.statusCode ==
200
) {

final data =
jsonDecode(
response.body,
);

if (!mounted) return;

setState(() {

rainfall =
(data["current"]["rain"]
?? 0)
.toDouble();

if (
rainfall == 0
) {

weatherText =
"No Rain";

}

else if (
rainfall < 5
) {

weatherText =
"Light Rain";

}

else {

weatherText =
"Heavy Rain";

}

updatedAt =
TimeOfDay
.now()
.format(
context,
);

});

}
}
void startWeatherUpdates() {

weatherTimer =

Timer.periodic(

const Duration(
seconds: 30,
),

(_){

loadWeather();

},

);

}


Future<void>
loadReports()
async {

var reports =

await FirebaseFirestore
.instance
.collection(
"flood_reports",
)
.get();

for (
var report
in reports.docs
) {

double severity =

(report["severity"]?? 1).toDouble();

Color zoneColor =severity >= 3? Colors.red.withOpacity(0.35,)

  : severity == 2? Colors.orange.withOpacity(0.30,)

: Colors.yellow.withOpacity(
0.25,
);

floodZones.add(

CircleMarker(

point:

LatLng(
report["lat"],
report["lng"],
),

radius:
severity *
300,

useRadiusInMeter:
true,

color:
zoneColor,

borderColor:
Colors.red,

borderStrokeWidth:
2,

),

);

markers.add(

Marker(

point:

LatLng(
report["lat"],
report["lng"],
),

width: 50,

height: 50,

child:

Icon(

Icons.warning,

color:

severity >= 3

? Colors.red

: severity == 2

? Colors.orange

: Colors.yellow,

size: 35,

),

),

);

}

}

@override
Widget build(
BuildContext context,
) {

return Scaffold(

drawer:

Drawer(

child:

Column(

children: [

DrawerHeader(

child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,

children: [

const Icon(
Icons.person,
size: 60,
),

const SizedBox(
height: 10,
),

Text(

FirebaseAuth
.instance
.currentUser
?.email

??

"No Email",

textAlign:
TextAlign.center,

style:

const TextStyle(
fontSize: 16,
),

),

],

),

),

ListTile(

leading:

const Icon(
Icons.logout,
),

title:

const Text(
"Logout",
),

onTap:
() async {

Navigator.pop(
context,
);

await FirebaseAuth
.instance
.signOut();

if (
!mounted
) return;

Navigator.pushAndRemoveUntil(

context,

MaterialPageRoute(

builder:
(context)
=>
const selectAction(),

),

(route)=>false,

);

},

),

],

),

),

appBar:

AppBar(

title:

const Text(
"Flood Alert",
),

centerTitle:
true,

),

body:

loading

?

const Center(

child:
CircularProgressIndicator(),

)

:

Column(

children: [

Container(

width:
double.infinity,

padding:

const EdgeInsets
.all(
15,
),

color:
Colors.orange,

child:

const Column(

children: [

Text(

"Current Risk",

style:

TextStyle(
color:
Colors.white,
),

),

Text(

"LOW",

style:

TextStyle(

fontSize:
22,

color:
Colors.white,

),

),

],

),

),

Expanded(

child:

FlutterMap(

options:

MapOptions(

initialCenter:

LatLng(

currentPosition!
.latitude,

currentPosition!
.longitude,

),

initialZoom:
15,

),

children: [

TileLayer(

urlTemplate:

"https://tile.openstreetmap.org/{z}/{x}/{y}.png",

tileProvider:

CancellableNetworkTileProvider(),

),

CircleLayer(

circles:
floodZones,

),

MarkerLayer(

markers:
markers,

),

],

),

),

Card(

margin:

const EdgeInsets
.all(
12,
),

child:

ListTile(
leading:
Icon(rainfall > 5? Icons.thunderstorm
   : rainfall > 0? Icons.cloud
   : Icons.wb_sunny,
color:
rainfall > 5? Colors.red

: rainfall > 0? Colors.blue
: Colors.orange,

),

title:

Text(
weatherText,
),

subtitle:

Text(
"Rainfall: $rainfall mm",
),

),// icons changning according to rain

),

],

),

bottomNavigationBar:

BottomNavigationBar(

currentIndex:
0,

onTap:
(index){

if(
index==1
){

Navigator.push(

context,

MaterialPageRoute(

builder:
(_)
=>
const ReportPage(),

),

);

}

},

items:

const [

BottomNavigationBarItem(

icon:
Icon(
Icons.map,
),

label:
"Map",

),

BottomNavigationBarItem(

icon:
Icon(
Icons.add_location,
),

label:
"Report",

),
],
),

);

}

}