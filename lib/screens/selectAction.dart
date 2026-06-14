// ignore_for_file: camel_case_types

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class selectAction extends StatefulWidget {
   final int initialTab;

  const selectAction({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<selectAction> createState() => _selectActionState();
}

class _selectActionState
    extends State<selectAction>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
       initialIndex: widget.initialTab,

      child: Scaffold(
        backgroundColor:
            Colors.grey.shade200,

        body: AnimatedBackground(
          vsync: this,

          behaviour:
              RandomParticleBehaviour(
            options:
                const ParticleOptions(
              particleCount: 35,
              spawnMinSpeed: 8,
              spawnMaxSpeed: 18,
              minOpacity: 0.1,
              spawnOpacity: 0.2,
              baseColor:
                  Colors.black,
            ),
          ),

          child: SafeArea(
            child: Column(
              children: [

                const SizedBox(
                    height: 30),

                const Icon(
                  Icons.cloud,
                  size: 70,
                  color: Colors.black,
                ),

                const SizedBox(
                    height: 12),

                // const Text(
                //   "Flood Alert",
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight:
                //         FontWeight.bold,
                //   ),
                // ),

                // const SizedBox(
                //     height: 8),

                // Text(
                //   "Receive localized flood alerts",
                //   style: TextStyle(
                //     color:
                //         Colors.grey[700],
                //   ),
                // ),

                const SizedBox(
                    height: 25),

                Container(
                  margin:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 24,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                                30),
                  ),

                  child:
                      const TabBar(

                    indicatorSize:
                        TabBarIndicatorSize.tab,//scrollable 
                    indicator:
                        BoxDecoration(
                      color:
                          Colors.black,
                      borderRadius:
                          BorderRadius
                              .all(
                        Radius.circular(
                            30),
                      ),
                    ),

                    labelColor:
                        Colors.white,

                    unselectedLabelColor:
                        Colors.black,

                    tabs: [
                      Tab(
                        text:
                            "Login",
                      ),
                      Tab(
                        text:
                            "Register",
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 20),

                Expanded(
                  child:
                      Container(
                    margin:
                        const EdgeInsets
                            .all(
                                16),

                    padding:
                        const EdgeInsets
                            .all(
                                10),

                    decoration:
                        BoxDecoration(
                      color: Colors
                          .white,

                      borderRadius:
                          BorderRadius
                              .circular(
                                  20),

                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black12,

                          blurRadius:
                              12,
                        ),
                      ],
                    ),

                    child:
                        const TabBarView(
                      children: [
                        LoginPage(),
                        RegisterPage(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}