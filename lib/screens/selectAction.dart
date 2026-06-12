// // ignore_for_file: camel_case_types

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:cs_project_1/screens/login.dart';
import 'package:cs_project_1/screens/register.dart';
import 'package:cs_project_1/screens/adminlogin.dart';

class selectAction extends StatefulWidget {
  const selectAction({super.key});

  @override
  State<selectAction> createState() => _selectUserState();
}

class _selectUserState extends State<selectAction>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],

        appBar: AppBar(
          title: const Text(
            'Flood Alert System',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,

          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Admin'),
                  onTap: () {
                    Future.delayed(
                      Duration.zero,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const adminlogin(),
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          ],

          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.login),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person_add),
                text: "Register",
              ),
            ],
          ),
        ),

        body: AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(
            options: const ParticleOptions(
              spawnMaxRadius: 10,
              spawnMinSpeed: 10,
              particleCount: 70,
              spawnMaxSpeed: 40,
              minOpacity: 0.2,
              spawnOpacity: 0.3,
              baseColor: Colors.black,
            ),
          ),

          child: const TabBarView(
            children: [
              LoginPage(),
              RegisterPage(),
            ],
          ),
        ),
      ),
    );
  }
}