import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllReportsPage
extends StatelessWidget {

const AllReportsPage({
super.key,
});

@override
Widget build(
BuildContext context,
) {

return Scaffold(

appBar:AppBar(
  automaticallyImplyLeading: false, // Remove the back button
title:
const Text(
"All Reports",
),
),

body:

StreamBuilder<QuerySnapshot>(

  stream:
      FirebaseFirestore
          .instance
          .collection(
              "flood_reports")
          .snapshots(),

  builder:
      (context, snapshot) {

    if (
        snapshot.connectionState ==
            ConnectionState.waiting) {

      return const Center(
        child:
            CircularProgressIndicator(),
      );

    }

    if (
        !snapshot.hasData ||
        snapshot.data!.docs.isEmpty) {

      return const Center(
        child:
            Text(
          "No reports",
        ),
      );

    }

    final reports =
        snapshot.data!.docs;

    return ListView.builder(

      itemCount:
          reports.length,

      itemBuilder:
          (context, index) {

        final report =
            reports[index];

        return Card(

          child:
              ListTile(

            title:
                Text(
              report["email"] ??
                  "Unknown",
            ),

            subtitle:
                Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(
                  report[
                          "description"] ??
                      "",
                ),

                Text(
                  "Risk: ${report["risk"]}",
                ),

              ],

            ),

          ),

        );

      },

    );

  },

)

);

}

}