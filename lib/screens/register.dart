import 'package:cs_project_1/service/authservice.dart';
import 'package:flutter/material.dart';
import 'verifyemail.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final _formKey =
      GlobalKey<FormState>();

  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {

    if (!_formKey.currentState!
        .validate()) return;

    setState(() {
      _loading = true;
    });

    String? result =
        await AuthService().register(
      email:_emailController.text.trim(),
      password:_passwordController.text.trim(),
    );

    setState(() {
      _loading = false;
    });
    if (!mounted) return;
    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder:(_) =>const VerifyEmailPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text(result),
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Create Account",
                style:TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller:_emailController,
                keyboardType:TextInputType.emailAddress,
                decoration:InputDecoration(
                  labelText:"Email",
                  prefixIcon:const Icon(Icons.email,),
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),
                ),
                validator:(value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Enter email";
                  }

                  if (!value
                      .contains(
                          "@")) {
                    return "Invalid email";
                  }

                  return null;
                },
              ),// email validation

              const SizedBox(height: 18),
              TextFormField(
                controller:_passwordController,
                obscureText:_obscurePassword,
                decoration:InputDecoration(
                  labelText:"Password",
                  prefixIcon:const Icon(Icons.lock,),
                  border:
                      OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon:
                      IconButton(
                    icon:Icon(
                      _obscurePassword? Icons.visibility_off: Icons.visibility,
                    ), 

                    onPressed:() {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    }, /// toggles visibility 
                  ),
                ),

                validator:
                    (value) {

                  if (value == null ||
                      value.isEmpty) {
                    return "Enter password";
                  }

                  if (value.length <6) 
                  {return "Minimum 6 characters"; }
                  return null;
                },
              ),
              const SizedBox(
                  height: 18),
              TextFormField(

                controller: _confirmPasswordController,
                obscureText:_obscureConfirmPassword,
                decoration:
                    InputDecoration(
                  labelText:"Confirm Password",
                  prefixIcon:
                      const Icon(Icons.lock,
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
                      _obscureConfirmPassword? Icons.visibility_off: Icons.visibility,
                    ),
                    onPressed:
                        () {
                      setState(
                          () {

                        _obscureConfirmPassword =!_obscureConfirmPassword;

                      });
                    },
                  ),
                ),

                validator:
                    (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Confirm password";
                  }

                  if (value !=_passwordController.text) {
                    return "Passwords do not match";
                  }

                  return null;
                },
              ),

              const SizedBox(
                  height: 30),

              SizedBox(

                width:double.infinity,
                height: 55,
                child:
                    ElevatedButton(
                  onPressed:
                      _loading
                          ? null
                          : _register,

                  child:
                      _loading

                          ? const SizedBox(
                              width:22,
                              height:22,
                              child:
                                  CircularProgressIndicator(strokeWidth:3,
                              ),
                            )

                          : const Text(
                              "Register",
                              style:
                                  TextStyle(
                                fontSize:18,
                              ),
                            ),
                ),
              ),

              const SizedBox(height: 15),
              TextButton(
                onPressed:
                    () {
                  DefaultTabController .of(context).animateTo(0);
                },
                child:const Text(
                  "Already have an account? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}