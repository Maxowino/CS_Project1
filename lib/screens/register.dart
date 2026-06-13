import 'package:cs_project_1/service/authservice.dart';
import 'package:flutter/material.dart';
import 'verifyemail.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

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

  bool _obscureConfirmPassword =
      true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!
        .validate()) {
      String? result =
          await AuthService()
              .register(
        email: _emailController.text
            .trim(),
        password:
            _passwordController.text
                .trim(),
      );

      if (result == null) {
        ScaffoldMessenger.of(
                context)
            .showSnackBar(
          const SnackBar(
            content: Text(
                "Verification email sent"),
          ),
        );

        DefaultTabController.of(
                context)
            .animateTo(0);
      } else {
        ScaffoldMessenger.of(
                context)
            .showSnackBar(
          SnackBar(
            content:
                Text(result),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(24),

      child: SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,

            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),

              const SizedBox(
                  height: 32),

              TextFormField(
                controller:
                    _emailController,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Email',

                  prefixIcon:
                      Icon(
                    Icons.email,
                  ),

                  border:
                      OutlineInputBorder(),
                ),

                validator:
                    (value) {
                  if (value ==
                          null ||
                      value
                          .isEmpty) {
                    return 'Please enter email';
                  }

                  if (!value
                      .contains(
                          '@')) {
                    return 'Invalid email';
                  }

                  return null;
                },
              ),

              const SizedBox(
                  height: 20),

              TextFormField(
                controller:
                    _passwordController,

                obscureText:
                    _obscurePassword,

                decoration:
                    InputDecoration(
                  labelText:
                      'Password',

                  prefixIcon:
                      const Icon(
                    Icons.lock,
                  ),

                  border:
                      const OutlineInputBorder(),

                  suffixIcon:
                      IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                              .visibility_off
                          : Icons
                              .visibility,
                    ),

                    onPressed:
                        () {
                      setState(
                          () {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                  ),
                ),

                validator:
                    (value) {
                  if (value ==
                          null ||
                      value
                          .isEmpty) {
                    return 'Enter password';
                  }

                  if (value
                          .length <
                      6) {
                    return 'Minimum 6 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(
                  height: 20),

              TextFormField(
                controller:
                    _confirmPasswordController,

                obscureText:
                    _obscureConfirmPassword,

                decoration:
                    InputDecoration(
                  labelText:
                      'Confirm Password',

                  prefixIcon:
                      const Icon(
                    Icons.lock,
                  ),

                  border:
                      const OutlineInputBorder(),

                  suffixIcon:
                      IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons
                              .visibility_off
                          : Icons
                              .visibility,
                    ),

                    onPressed:
                        () {
                      setState(
                          () {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),

                validator:
                    (value) {
                  if (value !=
                      _passwordController
                          .text) {
                    return 'Passwords do not match';
                  }

                  return null;
                },
              ),

              const SizedBox(
                  height: 30),

              SizedBox(
                width:
                    double.infinity,

                child:
                    ElevatedButton(
                  onPressed:
                      _register,

                  child:
                      const Text(
                    'Register',
                  ),
                ),
              ),

              const SizedBox(
                  height: 10),

              TextButton(
                onPressed: () {
                  DefaultTabController.of(context).animateTo(0);
                },

                child:
                    const Text(
                  "Already have an account? Login",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}