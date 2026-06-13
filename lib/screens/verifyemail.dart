import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    await FirebaseAuth.instance.currentUser
        ?.reload();

    User? user =
        FirebaseAuth.instance.currentUser;

    setState(() {
      _checking = false;
    });

    if (user != null &&
        user.emailVerified) {

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.of(context)
          .popUntil(
              (route) =>route.isFirst);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Email verified. Please login.",
          ),
        ),
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
            const EdgeInsets.all(24),

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

            const Text(
              "Open the verification link then return here.",
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
                height: 30),

            SizedBox(
              width:
                  double.infinity,

              child:
                  ElevatedButton(

                onPressed:
                    _checking
                        ? null
                        : checkVerification,

                child:
                    _checking
                        ? const CircularProgressIndicator()
                        : const Text(
                            "I Verified My Email",
                          ),
              ),
            ),

            const SizedBox(
                height: 10),

            TextButton(

              onPressed: () async {

                await FirebaseAuth
                    .instance
                    .currentUser
                    ?.sendEmailVerification();

                if (!mounted) return;

                ScaffoldMessenger.of(
                        context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Verification email resent"),
                  ),
                );
              },

              child:
                  const Text(
                "Resend Email",
              ),
            ),
          ],
        ),
      ),
    );
  }
}