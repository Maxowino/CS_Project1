import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final uid =
        FirebaseAuth
            .instance
            .currentUser!
            .uid;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          "My Reports",
        ),
      ),

      body:

      StreamBuilder<QuerySnapshot>(

        stream:

        FirebaseFirestore
            .instance

            .collection(
              "flood_reports",
            )

            .where(
              "uid",
              isEqualTo: uid,
            )

            .limit(
              20,
            )

            .snapshots(),

        builder:
            (
          context,
          snapshot,
        ) {

          if (
          snapshot.connectionState ==
              ConnectionState.waiting
          ) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (
          !snapshot.hasData ||
              snapshot.data!.docs.isEmpty
          ) {

            return const Center(
              child:
                  Text(
                "No Reports Yet",
              ),
            );
          }

          final reports =
              snapshot
                  .data!
                  .docs;

          return ListView.builder(

            itemCount:
                reports.length,

            itemBuilder:
                (
              context,
              index,
            ) {

              var report =
                  reports[index];

              String description =
                  report["description"] ??
                      "No Description";

              DateTime? createdAt;

              try {

                if (
                report[
                "createdAt"
                ] !=
                    null
                ) {

                  createdAt =

                      (
                      report[
                      "createdAt"
                      ]
                      as Timestamp
                      )

                          .toDate();
                }

              }

              catch (_) {}

              return Card(

                margin:

                const EdgeInsets.all(
                  10,
                ),

                child:

                ListTile(

                  leading:

                  const Icon(
                    Icons.description,
                    color:
                        Colors.blue,
                  ),

                  title:

                  Text(
                    description,
                  ),

                  subtitle:

                  Text(

                    createdAt != null

                        ?

                    "Created: "

                        "${createdAt.day.toString().padLeft(2,'0')}/"

                        "${createdAt.month.toString().padLeft(2,'0')}/"

                        "${createdAt.year}"

                        " "

                        "${createdAt.hour.toString().padLeft(2,'0')}:"

                        "${createdAt.minute.toString().padLeft(2,'0')}:"

                        "${createdAt.second.toString().padLeft(2,'0')}"

                        :

                    "Created: Unknown",

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