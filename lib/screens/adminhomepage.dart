import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_project_1/screens/allreports.dart';
import 'package:cs_project_1/screens/flaggedreports.dart';
import 'package:flutter/material.dart';
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() =>
      _AdminHomePageState();
}

class _AdminHomePageState
    extends State<AdminHomePage> {

  int currentIndex = 0;

  int users = 0;
  int reports = 0;
  int flagged = 0;

  bool loading = true;

  List<QueryDocumentSnapshot>
      recentReports = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void>
      loadDashboard() async {

    setState(() {
      loading = true;
    });

    try {

      final usersSnap =
          await FirebaseFirestore
              .instance
              .collection(
                  "users")
              .get();

      final reportsSnap =
          await FirebaseFirestore
              .instance
              .collection(
                  "flood_reports")
              .get();

      int flaggedCount = 0;

      for (var report
          in reportsSnap.docs) {

        final data =
            report.data();

        if (
            data.containsKey(
                    "verified") &&
                data[
                        "verified"] ==
                    false) {
          flaggedCount++;
        }

      }

      recentReports =
          reportsSnap.docs
              .take(5)
              .toList();

      if (!mounted) return;

      setState(() {

        users =
            usersSnap.docs.length;

        reports =
            reportsSnap.docs.length;

        flagged =
            flaggedCount;

        loading =
            false;

      });

    } catch (_) {

      if (!mounted) return;

      setState(() {
        loading = false;
      });

    }

  }

  Widget statCard(
      IconData icon,
      String title,
      String value,
      Color color) {

    return Expanded(

      child:
          Card(

        elevation: 2,

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                  18),

        ),

        child:
            Padding(

          padding:
              const EdgeInsets
                  .all(18),

          child:
              Column(

            children: [

              Icon(
                icon,
                color:
                    color,
                size:
                    35,
              ),

              const SizedBox(
                  height:
                      10),

              Text(
                value,

                style:
                    const TextStyle(

                  fontSize:
                      24,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),

              Text(
                title,
              ),

            ],

          ),

        ),

      ),

    );

  }

  Widget dashboard() {

    if (loading) {

      return const Center(
        child:
            CircularProgressIndicator(),
      );

    }

    return RefreshIndicator(

      onRefresh:
          loadDashboard,

      child:
          ListView(

        padding:
            const EdgeInsets
                .all(16),

        children: [

          const Text(

            "Overview",

            style:
                TextStyle(

              fontSize:
                  28,

              fontWeight:
                  FontWeight.bold,

            ),

          ),

          const SizedBox(
              height:
                  20),

          Row(

            children: [

              statCard(
                Icons.people,
                "Users",
                users
                    .toString(),
                Colors.black,
              ),

              statCard(
                Icons.warning,
                "Reports",
                reports
                    .toString(),
                Colors.orange,
              ),

            ],

          ),

          Row(

            children: [

              statCard(
                Icons.flag,
                "Flagged",
                flagged
                    .toString(),
                Colors.red,
              ),

            ],

          ),

          const SizedBox(
              height:
                  30),

          const Text(

            "Recent Reports",

            style:
                TextStyle(

              fontSize:
                  22,

              fontWeight:
                  FontWeight.bold,

            ),

          ),

          const SizedBox(
              height:
                  10),

          ...recentReports.map(

            (report) {

              return Card(

                child:
                    ListTile(

                  leading:
                      const Icon(
                    Icons.location_on,
                  ),

                  title:
                      Text(

                    report[
                            "email"] ??
                        "",

                  ),

                  subtitle:
                      Text(

                    report[
                            "description"] ??
                        "",

                    maxLines:
                        2,

                  ),

                  trailing:
                      Text(

                    report[
                            "risk"] ??
                        "",

                  ),

                ),

              );

            },

          ),

        ],

      ),

    );

  }

  @override
  Widget build(
      BuildContext context) {

    final pages = [

      dashboard(),
      const AllReportsPage(),
      const FlaggedReportsPage(),
    ];
    return Scaffold(
      backgroundColor:
          Colors.grey
              .shade200,
      appBar:
          AppBar(
        title:
            const Text(
          "Admin Dashboard",
        ),
        backgroundColor:
            Colors.white,
        foregroundColor:
            Colors.black,
        elevation:
            0,
      ),
      body:
          IndexedStack(
        index:
            currentIndex,
        children:
            pages,
      ),

      bottomNavigationBar:

          NavigationBar(

        selectedIndex:
            currentIndex,

        backgroundColor:
            Colors.white,

        indicatorColor:
            Colors.black,

        labelBehavior:
            NavigationDestinationLabelBehavior
                .alwaysShow,

        onDestinationSelected:
            (index) {

          setState(() {

            currentIndex =
                index;

          });

        },

        destinations:
            const [

          NavigationDestination(

            icon:
                Icon(
              Icons.dashboard_outlined,
            ),

            selectedIcon:
                Icon(
              Icons.dashboard,
              color:
                  Colors.white,
            ),

            label:
                "Dashboard",

          ),

          NavigationDestination(

            icon:
                Icon(
              Icons.list_alt,
            ),

            selectedIcon:
                Icon(
              Icons.list_alt,
              color:
                  Colors.white,
            ),

            label:
                "Reports",

          ),

          NavigationDestination(

            icon:
                Icon(
              Icons.flag_outlined,
            ),

            selectedIcon:
                Icon(
              Icons.flag,
              color:
                  Colors.white,
            ),

            label:
                "Flagged",

          ),

        ],

      ),

    );

  }

}