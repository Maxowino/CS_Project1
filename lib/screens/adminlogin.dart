import 'package:flutter/material.dart';
import 'package:cs_project_1/screens/adminhomepage.dart';

// ignore: camel_case_types
class adminlogin extends StatefulWidget {
  const adminlogin({super.key});

  @override
  State<adminlogin> createState() => _adminloginState();
}

// ignore: camel_case_types
class _adminloginState extends State<adminlogin> {
  bool showpassword = true;
  bool checkedbox = false;
  final GlobalKey<FormState> adminlogindetails = GlobalKey<FormState>();
  final TextEditingController user = TextEditingController();
  final TextEditingController pass = TextEditingController();

  // Define a set of valid admin credentials
  final String validAdminUsername = 'Admin';
  final String validAdminPassword = 'admin1239';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(
          width: 250,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Form(
            key: adminlogindetails,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle_sharp,
                  color: Colors.black,
                  size: 75.0,
                ),
                const Text(
                  'Admin',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: TextFormField(
                    controller: user,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.person),
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Enter Username',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: TextFormField(
                    obscureText: showpassword,
                    controller: pass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showpassword = !showpassword;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Enter Password',
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(180, 50),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      side: BorderSide.none,
                    ),
                    child: const Text('Login'),
                    onPressed: () async {
                      if (adminlogindetails.currentState!.validate()) {
                        // Check if the entered credentials match the valid admin credentials
                        if (user.text.trim() == validAdminUsername && pass.text == validAdminPassword) {
                          // Perform login for the valid admin user
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => adminhomepage()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar (content:const  Text('Login Successful!'),
                            backgroundColor: Colors.black,
                            duration:const Duration(seconds:2),
                            dismissDirection: DismissDirection.up,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height - 170,
                              left: 40,
                              right:40,
                   ),
                   
                  ),
                          );
                        } else {
                          // Show an error message for invalid credentials
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar (content:const  Text('Failed! Enter the Correct Credentials'),
                            backgroundColor: Colors.redAccent,
                            duration:const Duration(seconds:2),
                            dismissDirection: DismissDirection.up,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height - 170,
                              left: 40,
                              right:40,
                   ),
                   
                  ),
                          );
                        }
                      }
                    },
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