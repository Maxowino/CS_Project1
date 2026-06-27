import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() =>
      _ReportPageState();
}

class _ReportPageState
    extends State<ReportPage> {

  final _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      descriptionController =
      TextEditingController();

  bool loading = false;

  String risk = "LOW";

  Position? currentPosition;

  @override
  void initState() {
    super.initState();

    loadLocation();
  }

  Future<void> loadLocation() async {

    bool enabled =
        await Geolocator
            .isLocationServiceEnabled();

    if (!enabled) {
      return;
    }

    LocationPermission permission =
        await Geolocator
            .requestPermission();

    if (permission ==
            LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      return;
    }

    currentPosition =
        await Geolocator
            .getCurrentPosition();

    setState(() {});
  }
  Future<Map<String, dynamic>>validateReport() async {
  if (currentPosition == null) {
   return {
  "verified": true,
  "flagReason": "",
   "weatherRain": 0,
};
}

double rainfall = 0;

try {

final url =
Uri.parse(

"https://api.open-meteo.com/v1/forecast"
"?latitude=${currentPosition!.latitude}"
"&longitude=${currentPosition!.longitude}"
"&current=rain",

);

final response =await http.get(url).timeout(const Duration(seconds: 5,),
);

if (
response.statusCode == 200
) {

final data =
jsonDecode(
response.body,
);

rainfall =

(
data["current"]["rain"]
?? 0
)

.toDouble();

}

} catch (_) {
  return {
     "verified": true,
     "flagReason":"Weather unavailable",
    "weatherRain": 0,
};// error handling users dont wait long for weather api to respond

}

bool verified = true;
String reason = "";
if (
     rainfall == 0
    &&
(risk == "MEDIUM"
||
risk == "HIGH"
)
) {

verified = false;
reason ="No rainfall detected";
}

else if (
  rainfall < 3
&&
risk == "HIGH"

) {

verified = false;
reason ="Reported risk too high";
}
else if (
rainfall >= 10
&&
risk == "LOW"

) {

verified = false;

reason =
"Reported risk lower than weather";

}

return {
"verified":verified,
"flagReason":reason,
"weatherRain":rainfall,
};

}

  Future<void> submitReport() async {

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    if (currentPosition == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text( "Location unavailable",),
        ),
      );
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      User? user =
          FirebaseAuth.instance.currentUser;
      final validation =await validateReport();
      await FirebaseFirestore.instance.collection("flood_reports",).add({
       "uid":user?.uid,
       "email":user?.email,
       "description":descriptionController.text.trim(),
       "risk":risk,
       "lat":currentPosition!.latitude,
       "lng":currentPosition!.longitude,
       "createdAt":Timestamp.now(),
       "weatherRain":validation["weatherRain"],
       "verified":validation["verified"],
       "flagReason":validation["flagReason"],
      }); // ties the reports to users that submits it

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text( "Report submitted",),
        ),
      ); // success message
      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text( e.toString(),
          ),
        ),
      );
    }

   if (mounted) {setState(() {loading = false;});
}
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text( "Submit Flood Report",),
        centerTitle: true,
      ),
      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.warning,
                size: 90,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text( "Report Flood Incident",
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller:descriptionController,
                maxLines: 5,
                decoration:
                    InputDecoration(
                  labelText:"Description",
                  hintText:"Describe flooding situation",
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),
                ),
                validator:
                    (value) {
                  if (value ==
                          null ||
                      value.isEmpty) {
                    return "Enter report";
                  }
                  return null;
                },
              ),
              const SizedBox(
                  height: 20),
              DropdownButtonFormField(
                value:  risk,
                decoration:
                    InputDecoration(
                  labelText:"Risk Level",
                  border:OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value:"LOW",
                    child:
                        Text("LOW",
                    ),
                  ),
                  DropdownMenuItem(
                    value:"MEDIUM",
                    child:
                        Text("MEDIUM",
                    ),
                  ),
                  DropdownMenuItem(
                    value:"HIGH",
                    child:
                        Text("HIGH",),
                  ),
                ],
                onChanged:
                    (value) {
                  setState(() {

                    risk = value!;
                  });
                },
              ),

              const SizedBox(
                  height: 20),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(15),
                  child:
                      Column(
                    children: [
                      const Text(
                        "Current GPS",
                      ),

                      const SizedBox(
                          height: 10),

                      Text(

                        currentPosition ==
                                null
                            ? "Fetching location..."
                            : "${currentPosition!.latitude}\n${currentPosition!.longitude}",
                        textAlign:
                            TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                  height: 30),
              SizedBox(
                height:55,
                child:ElevatedButton(
                  onPressed:
                      loading ? null: submitReport,
                  child:
                      loading
                          ? const CircularProgressIndicator()
                          : const Text( "Submit Report",
                              style: TextStyle(
                                fontSize:18,
                                ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}