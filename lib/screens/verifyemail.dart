import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'selectAction.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() =>
      _VerifyEmailPageState();
}

class _VerifyEmailPageState
    extends State<VerifyEmailPage> {

  bool _checking = false;

  Future<void> checkVerification() async {

    setState(() {
      _checking = true;
    });

    try {

      await FirebaseAuth.instance
          .currentUser
          ?.reload();

      final user =
          FirebaseAuth.instance
              .currentUser;

      if (!mounted) return;

      if (user != null &&
          user.emailVerified) {

        await FirebaseAuth.instance
            .signOut();

        Navigator.pushAndRemoveUntil(

          context,

          MaterialPageRoute(
            builder:
                (_) =>
                    const selectAction(
                      initialTab: 0,
                    ),
          ),

          (route) => false,
        );

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Email not verified yet",
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
              Text(e.toString()),
        ),
      );

    }

    if (mounted) {
      setState(() {
        _checking = false;
      });
    }
  }

  Future<void> resendEmail() async {

    try {

      await FirebaseAuth.instance
          .currentUser
          ?.sendEmailVerification();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Verification email resent",
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
              Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          "Verify Email",
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(
                24),

        child: Center(

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.mark_email_read,
                size: 90,
                color: Colors.blue,
              ),

              const SizedBox(
                  height: 20),

              const Text(
                "Check your email",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 10),

              Text(
                FirebaseAuth
                        .instance
                        .currentUser
                        ?.email ??
                    "",

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  color:
                      Colors.grey,
                ),
              ),

              const SizedBox(
                  height: 10),

              const Text(

                "Open the verification email and verify your account before continuing.",

                textAlign:
                    TextAlign.center,
              ),

              const SizedBox(
                  height: 30),

              SizedBox(

                width:
                    double.infinity,

                height: 55,

                child:
                    ElevatedButton(

                  onPressed:
                      _checking
                          ? null
                          : checkVerification,

                  child:
                      _checking

                          ? const SizedBox(
                              width:
                                  22,
                              height:
                                  22,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    3,
                              ),
                            )

                          : const Text(
                              "I Verified My Email",
                            ),
                ),
              ),

              const SizedBox(
                  height: 12),

              TextButton(

                onPressed:
                    resendEmail,

                child:
                    const Text(
                  "Resend Email",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}