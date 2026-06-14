import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {

  GoogleMapController?
      mapController;

  Position? currentPosition;

  final Set<Marker>
      markers = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadLocation();
  }

  Future loadLocation() async {

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

        markerId:
            const MarkerId(
          "me",
        ),

        position: LatLng(
          currentPosition!.latitude,
          currentPosition!.longitude,
        ),

        infoWindow:
            const InfoWindow(
          title:
              "Your Location",
        ),
      ),
    );

    loadReports();

    setState(() {
      loading = false;
    });
  }

  Future loadReports() async {

    var reports =
        await FirebaseFirestore
            .instance
            .collection(
                "flood_reports")
            .get();

    for (var report
        in reports.docs) {

      markers.add(

        Marker(

          markerId:
              MarkerId(
            report.id,
          ),

          position:
              LatLng(
            report["lat"],
            report["lng"],
          ),

          icon:
              BitmapDescriptor
                  .defaultMarkerWithHue(
            BitmapDescriptor
                .hueRed,
          ),

          infoWindow:
              InfoWindow(
            title:
                report["risk"],
          ),
        ),
      );
    }

    setState(() {});
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
                Icons.person,
                size: 80,
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

                await FirebaseAuth
                    .instance
                    .signOut();
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

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      Text(
                        "LOW",
                        style:
                            TextStyle(
                          color:
                              Colors.white,

                          fontSize:
                              24,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(

                  height: 380,

                  child:
                      GoogleMap(

                    initialCameraPosition:

                        CameraPosition(

                      target:
                          LatLng(
                        currentPosition!
                            .latitude,

                        currentPosition!
                            .longitude,
                      ),

                      zoom:
                          15,
                    ),

                    myLocationEnabled:
                        true,

                    myLocationButtonEnabled:
                        true,

                    markers:
                        markers,

                    onMapCreated:
                        (controller) {

                      mapController =
                          controller;
                    },
                  ),
                ),

                Card(

                  margin:
                      const EdgeInsets
                          .all(
                              12),

                  child:
                      ListTile(

                    leading:
                        const Icon(
                      Icons.cloud,
                    ),

                    title:
                        const Text(
                      "Weather",
                    ),

                    subtitle:
                        const Text(
                      "API integration coming next",
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

        onPressed: () {

          Navigator.pushNamed(
            context,
            "/report",
          );
        },
      ),

      bottomNavigationBar:

          BottomNavigationBar(

        items: const [

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