import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:geolocator/geolocator.dart';

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

    if (permission ==
        LocationPermission.denied) {
      return;
    }

    currentPosition =
        await Geolocator
            .getCurrentPosition();

    markers.add(

      Marker(

        point: LatLng(
          currentPosition!
              .latitude,

          currentPosition!
              .longitude,
        ),

        width: 60,

        height: 60,

        child: const Icon(
          Icons.my_location,
          size: 40,
          color: Colors.blue,
        ),
      ),
    );

    await loadReports();

    setState(() {
      loading = false;
    });
  }

  Future<void>
      loadReports() async {

    var reports =
        await FirebaseFirestore .instance.collection(
                "flood_reports").get();

    for (var report
        in reports.docs) {

      markers.add(

        Marker(

          point: LatLng(
            report["lat"],
            report["lng"],
          ),

          width: 50,

          height: 50,

          child: const Icon(
            Icons.warning,
            color: Colors.red,
            size: 35,
          ),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      drawer: Drawer(

        child: Column(

          children: [

            const DrawerHeader(

              child: Icon(
                Icons.person, size: 80,
              ),
            ),

            ListTile(

              leading:
                  const Icon(Icons.logout,
              ),

              title:
                  const Text("Logout",
              ),

              onTap:
                  () async {

                await FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),

      appBar: AppBar(

        title:
            const Text(
          "Flood Alert",
        ),

        centerTitle: true,
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(

              children: [

                Container(

                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets
                          .all(
                              15),

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
                              12),

                  child:
                      const ListTile(

                    leading:
                        Icon(
                      Icons.cloud,
                    ),

                    title:
                        Text(
                      "Weather",
                    ),

                    subtitle:
                        Text(
                      "Weather API coming next",
                    ),
                  ),
                ),
              ],
            ),

      floatingActionButton:

          FloatingActionButton(

        child:
            const Icon(
          Icons.add_location,
        ),

        onPressed:
            () {

          Navigator.pushNamed(
            context,
            "/report",
          );
        },
      ),

      bottomNavigationBar:

          BottomNavigationBar(

        items: [

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
              Icons.warning,
            ),
            label:
                "Alerts",
          ),

          BottomNavigationBarItem(
            icon:
                Icon(
              Icons.person,
            ),
            label:
                "Profile",
          ),
        ],
      ),
    );
  }
}