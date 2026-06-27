import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FlaggedReportsPage extends StatelessWidget {
  const FlaggedReportsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("flood_reports")
          .where(
            "verified",
            isEqualTo: false,
          )
          .snapshots(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No flagged reports",
            ),
          );
        }

        final reports = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: reports.length,
          itemBuilder: (
            context,
            index,
          ) {
            final report = reports[index];

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    report["email"] ?? "Unknown",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        report["description"] ?? "",
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Risk: ${report["risk"]}",
                      ),
                      Text(
                        "Reason: ${report["flagReason"]}",
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text(
                              "Delete Report",
                            ),
                            content: const Text(
                              "Are you sure you want to permanently delete this flagged report?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    false,
                                  );
                                },
                                child: const Text(
                                  "Cancel",
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    true,
                                  );
                                },
                                child: const Text(
                                  "Delete",
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        await report.reference.delete();
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}