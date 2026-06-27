import 'dart:convert';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_project_1/screens/selectAction.dart';
import 'package:cs_project_1/screens/user_reports.dart';
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

class _HomePageState extends State<HomePage> {

Position? currentPosition;

bool loading = true;

final List<Marker>
markers = [];

final List<CircleMarker>
floodZones = [];

// WEATHER
double rainfall = 0;
String riskLevel = "LOW";

Color riskColor =
Colors.green;

bool alertSent =
false;

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

Future<void> loadLocation()
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

// SHOW UI IMMEDIATELY
setState(() {
loading = false;
});

// LOAD IN BACKGROUND
await loadWeather();
await loadReports();
startWeatherUpdates();

}

Future<void> loadWeather() async {

  if (currentPosition == null) return;

  try {

    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast"
      "?latitude=${currentPosition!.latitude}"
      "&longitude=${currentPosition!.longitude}"
      "&current=rain",
    );

    final response =await http.get(url).timeout(const Duration(seconds: 5),);
    if (response.statusCode != 200) return;

    final data =
        jsonDecode(response.body);
    if (!mounted) return;
    setState(() {
      rainfall =
          (data["current"]["rain"] ?? 0).toDouble();
      updatedAt =TimeOfDay.now().format(context);
      weatherText =
          rainfall == 0? "No Rain"
              : rainfall < 5? "Light Rain"
              : "Heavy Rain";
    });
  } catch (e) {
    debugPrint(
      "Weather failed: $e",
    );
  }
}
bool refreshing = false;

void startWeatherUpdates() {
  weatherTimer?.cancel();
  weatherTimer = Timer.periodic(
    const Duration(seconds: 30),(_) async {
      if (refreshing) return;
      refreshing = true;
      try {
        debugPrint(
          "Updating weather...",
        );
        await loadWeather();
        await loadReports();
        await updateRisk();
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        debugPrint(
          "Timer error: $e",
        );
      } finally {
        refreshing = false;
      }
    },
  );

}
Future<void>loadReports()async {
if (markers.length > 1) {
markers.removeRange(1, markers.length);}// removes old markers to avoid duplicates

floodZones.clear();
var reports =

await FirebaseFirestore.instance.collection("flood_reports",).get();
for (
var report
in reports.docs
) {
bool verified =report["verified"] ?? true;if (!verified) continue; //Check db & Ignore flagged reports
String risk =(report["risk"] ?? "LOW").toString().toUpperCase();
double severity =
risk == "HIGH"? 3: risk == "MEDIUM"? 2: 1;
Color zoneColor =
severity >= 3? Colors.red.withValues(alpha: 0.35,)
: severity == 2? Colors.orange.withValues(alpha: 0.30,)
: Colors.yellow.withValues(alpha: 0.25,
);
floodZones.add(
CircleMarker(
point:LatLng(
  report["lat"],
  report["lng"],
),
radius:severity *300,
useRadiusInMeter:true,
color:zoneColor,
borderColor:Colors.red,
borderStrokeWidth:2,
),
);
markers.add(
Marker(
point:LatLng(
     report["lat"],
     report["lng"],),
width: 50,
height: 50,
child:Icon(
  Icons.warning,
  color:severity >= 3? Colors.red
  : severity == 2? Colors.orange
  : Colors.yellow,size: 35,
),

),

);

}
if (mounted) {
setState(() {});
}
}
Future<void> updateRisk() async {
int reportScore = 0;// get reports
var reports =await FirebaseFirestore.instance.collection("flood_reports").get();
for (var report in reports.docs) {
      bool verified =report["verified"] ?? true;// Ignore flagged reports
      if (!verified) continue;

String risk =(report["risk"] ?? "LOW").toString().toUpperCase();
if (risk == "HIGH") {
reportScore += 3;
}
else if (risk == "MEDIUM") {
reportScore += 2;
}
else {
reportScore += 1;
}
}
// WEATHER SCORE
int weatherScore = 0;

if (rainfall >= 10) {

weatherScore = 3;

}
else if (rainfall >= 5) {

weatherScore = 2;

}
else if (rainfall > 0) {

weatherScore = 1;

}

int total =
reportScore +
(weatherScore * 2); // weather weighted more

String newRisk = "LOW";
Color newColor = Colors.green;

if (total >= 15) {

newRisk = "EXTREME";
newColor = Colors.purple;

}
else if (total >= 10) {

newRisk = "HIGH";
newColor = Colors.red;

}
else if (total >= 5) {

newRisk = "MEDIUM";
newColor = Colors.orange;

}

if (!mounted) return;

setState(() {

riskLevel = newRisk;
riskColor = newColor;

});

// Alerts only once
if (
(newRisk == "HIGH" ||
newRisk == "EXTREME") &&
!alertSent
) {

alertSent = true;

sendFloodAlert();

}

if (
newRisk == "LOW" ||
newRisk == "MEDIUM"
) {

alertSent = false;

}

}
void sendFloodAlert() {

ScaffoldMessenger
.of(context)

.showSnackBar(

SnackBar(

backgroundColor:

riskLevel ==
"EXTREME"

?

Colors.purple

:

Colors.red,

content:

Text(

riskLevel ==
"EXTREME"

?

"🚨 Extreme Flood Risk"

:

"⚠️ High Flood Risk",

),

),

);

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
Icons.history,
),

title:
const Text(
"My Reports",
),

onTap:
(){

Navigator.pop(
context,
);

Navigator.push(

context,

MaterialPageRoute(

builder:
(_)=>
const MyReportsPage(),

),

);

},

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
(context)=>
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
riskColor,

child:

Column(
children: [

const Text(
"Current Risk",
style: TextStyle(
color: Colors.white,
),

),

Text(
riskLevel,
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.white,
),

),

],
)

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
"Rainfall: $rainfall mm\nUpdated: $updatedAt",
),// referesh visual for weather 

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
@override
void dispose() {

weatherTimer?.cancel();

super.dispose();

}

}