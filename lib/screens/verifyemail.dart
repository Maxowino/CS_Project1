import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPage extends StatefulWidget {
const VerifyEmailPage({super.key});

@override
State<VerifyEmailPage> createState() =>_VerifyEmailPageState();
}

class _VerifyEmailPageState
extends State<VerifyEmailPage> {

 bool loading=false;

  Future<void> checkVerification() async {setState(() {loading=true;
});

await FirebaseAuth.instance.currentUser?.reload();

User? user = FirebaseAuth.instance.currentUser;

if(user!=null &&user.emailVerified){

        await FirebaseAuth.instance.signOut();

          Navigator.pop(context);

ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
               content:Text("Email verified. Login now",),
                       ),
                );
}else{

   ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email not verified yet",
                          ),
                    ),
                  );

}

      setState(() {loading=false;});
}

  Future<void> resendEmail() async {await FirebaseAuth.instance.currentUser?.sendEmailVerification();

ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
                   content:Text("Verification email resent",
                          ),
                         ),
               );

}

@override
Widget build(BuildContext context){

 return Scaffold(

         appBar:AppBar(),

              body:Padding(
                 padding:const EdgeInsets.all(24),
                   child:Column(
                     mainAxisAlignment:MainAxisAlignment.center,

                       children:[
                        const Icon(
                          Icons.mark_email_read,size:90,
                       ),
                       const SizedBox(
                        height:20,
                      ),
                      const Text(
                        "Verify Your Email",style:TextStyle(
                          fontSize:28,
                          fontWeight:FontWeight.bold,
                   ),
         ),
         const SizedBox(
          height:10,
      ),
      const Text("Verification email has been sent to your email. Please verify to continue.",
      textAlign:TextAlign.center,
),
                 const SizedBox(
                  height:40,
                  ),
                  SizedBox(
                    width:double.infinity,
                    child:
                    ElevatedButton(
                      onPressed:loading? null: checkVerification,
                      child:
                      loading? const CircularProgressIndicator(): 
                      const Text("Verified",),
                  ),
             ),
             TextButton(
              onPressed: resendEmail,
              child:
              const Text( "Resend Email",),
),

],
),
),
);
}
}