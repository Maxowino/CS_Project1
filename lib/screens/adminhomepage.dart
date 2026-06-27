import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_project_1/screens/adminuser.dart';
import 'package:cs_project_1/screens/allreports.dart';
import 'package:cs_project_1/screens/flaggedreports.dart';
import 'package:cs_project_1/screens/selectAction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({
    super.key,
  });

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

 Future<void> loadDashboard() async {

if (!mounted) return;

setState(() {
loading = true;
});

try {

final usersSnap =
await FirebaseFirestore
.instance
.collection("users")
.get();

final reportsSnap =
await FirebaseFirestore
.instance
.collection("flood_reports")
.get();

int flaggedCount = 0;

// count flagged safely
for (var report in reportsSnap.docs) {

final data =report.data();

bool verified =
data["verified"] ?? true;

if (!verified) {
flaggedCount++;
}

}

// latest reports first
final latest =
reportsSnap.docs.reversed
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

recentReports =
latest;

loading = false;

});

} catch (e) {

debugPrint(
"Dashboard error: $e",
);

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

      child: Card(

        elevation: 2,

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                  18),

        ),

        child: Padding(

          padding:
              const EdgeInsets
                  .all(18),

          child: Column(

            children: [

              Icon(
                icon,
                size: 34,
                color:
                    color,
              ),

              const SizedBox(
                height: 10,
              ),

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
              height: 20),

          Row(

            children: [

              statCard(
                Icons.people,
                "Users",
                users
                    .toString(),
                Colors.black,
              ),

              const SizedBox(
                width: 10,
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

          const SizedBox(
              height: 10),

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
              height: 30),

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
              height: 10),

        ...recentReports.map((report) {

final data =
report.data()
as Map<String,dynamic>;

return Card(

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(16),
),

child:

ListTile(

leading:

const CircleAvatar(
backgroundColor:
Colors.black,
child:
Icon(
Icons.location_on,
color:
Colors.white,
),
),

title:

Text(
data["email"]
?? "Unknown User",
),

subtitle:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

Text(
data["description"]
?? "No description",
maxLines: 2,
),

Text(
"Risk: ${data["risk"] ?? "LOW"}",
),

],

),

trailing:

(data["verified"] ?? true)

? const Icon(
Icons.check_circle,
color:
Colors.green,
)

: const Icon(
Icons.flag,
color:
Colors.red,
),

),

);

}),

        ],

      ),

    );

  }

  @override
  Widget build(
      BuildContext context) {

    final pages = [

      dashboard(),
      const AdminUsersPage(),
      const AllReportsPage(),
      const FlaggedReportsPage(),
    ];

    return Scaffold(

      drawer: Drawer(

width: 230,

child: Column(

children: [

SizedBox(

height: 120,

child:

DrawerHeader(

margin:
EdgeInsets.zero,

padding:
const EdgeInsets.only(
top: 10,
left: 10,
right: 10,
),

child:

Column(

mainAxisAlignment:
MainAxisAlignment.center,

children: [

const CircleAvatar(

radius: 24,

backgroundColor:
Colors.black,

child:

Icon(
Icons.admin_panel_settings,
size: 24,
color:
Colors.white,
),

),

const SizedBox(
height: 8,
),

const Text(

"Admin",

style:
TextStyle(

fontSize: 18,

fontWeight:
FontWeight.bold,

),

),

const SizedBox(
height: 4,
),

Flexible(

child:

Text(

FirebaseAuth
.instance
.currentUser
?.email

??

"",

maxLines: 1,

overflow:
TextOverflow.ellipsis,

textAlign:
TextAlign.center,

style:

TextStyle(

fontSize: 11,

color:
Colors.grey.shade600,

),

),

),

],

),

),

),

const Spacer(),

ListTile(

leading:

const Icon(
Icons.logout,
color:
Colors.red,
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

if (!context.mounted)
return;

Navigator.pushAndRemoveUntil(

context,

MaterialPageRoute(

builder:
(_)=>
const selectAction(),

),

(route)=>false,

);

},

),

const SizedBox(
height: 15,
),

],

),

),

      backgroundColor:
          Colors.grey.shade200,

      appBar:

          AppBar(

        automaticallyImplyLeading:
            false,

        title:
            const Text(
          "Admin Dashboard",
        ),

        actions: [

          Builder(

            builder:
                (context) {

              return IconButton(

                icon:
                    const Icon(
                  Icons.menu,
                ),

                onPressed:
                    () {

                  Scaffold.of(
                          context)
                      .openDrawer();

                },

              );

            },

          ),

        ],

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

        onDestinationSelected:
            (index) {

          setState(() {

            currentIndex =
                index;

          });

        },
destinations: const [

NavigationDestination(

icon:
Icon(
Icons.dashboard,
),

label:
"Dashboard",

),

NavigationDestination(

icon:
Icon(
Icons.people,
),

label:
"Users",

),

NavigationDestination(

icon:
Icon(
Icons.list_alt,
),

label:
"Reports",

),

NavigationDestination(

icon:
Icon(
Icons.flag,
),
label:
"Flagged",
),
],
      ),
    );
  }
}