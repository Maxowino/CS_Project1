import 'package:cs_project_1/service/authservice.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key})
      : super(key: key);

  @override
  State<LoginPage> createState() =>_LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
  final _formKey =
      GlobalKey<FormState>();

  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  bool _obscurePassword = true;

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    String? result =
        await AuthService().login(
      email:
          _emailController.text.trim(),

      password:
          _passwordController.text.trim(),
    );

    setState(() {
      _loading = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text(
            "Login successful",
          ),
        ),
      );

      Navigator.pushReplacement(
        context,MaterialPageRoute(builder: (_) =>const HomePage(),
        ),
);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(result),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(24),

      child:
          SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: Column(
            children: [

              const SizedBox(
                  height: 20),

              const Text(
                "Welcome Back",
                style:
                    TextStyle(
                  fontSize:
                      28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 10),

              Text(
                "Login to continue",

                style:
                    TextStyle(
                  color:
                      Colors.grey[600],
                ),
              ),

              const SizedBox(
                  height: 35),

              TextFormField(
                controller:
                    _emailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration:
                    InputDecoration(
                  labelText:
                      "Email",

                  prefixIcon:
                      const Icon(
                    Icons.email,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),

                validator:
                    (value) {
                  if (value ==
                          null ||
                      value.isEmpty) {
                    return "Enter email";
                  }

                  if (!value.contains(
                          '@')) {
                    return "Invalid email";
                  }

                  return null;
                },
              ),

              const SizedBox(
                  height: 18),

              TextFormField(
                controller:
                    _passwordController,

                obscureText:
                    _obscurePassword,

                decoration:
                    InputDecoration(
                  labelText:
                      "Password",

                  prefixIcon:
                      const Icon(
                    Icons.lock,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),

                  suffixIcon:
                      IconButton(
                    icon:
                        Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),

                    onPressed:() {
                      setState(
                          () {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                validator:
                    (value) {
                  if (value ==  null ||
                      value.isEmpty) {
                    return "Enter password";
                  }

                  if (value.length <6) {
                    return "Minimum 6 characters";
                  }

                  return null;
                },
              ),

              const SizedBox(
                  height: 30),

              SizedBox(
                width:
                    double.infinity,

                height: 55,

                child:
                    ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),

                  onPressed:_loading? null: _login,

                  child:
                      _loading
                          ? const SizedBox(
                              width:22,
                              height:22,
                              child:
                                  CircularProgressIndicator( strokeWidth:3,
                              ),
                            )
                          : 
                          const Text("Login",
                              style:
                                  TextStyle(
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