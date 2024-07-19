import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/widget/textformwidget.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

 

  @override
  Widget build(BuildContext context) {
     Future passwordreset() async {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailcontroller.text.trim());
        PanaraInfoDialog.show(
          context,
          title: "Password Reset",
          message: "A password reset request has been sent to your email.",
          buttonText: "Okay",
          onTapDismiss: () {
            Navigator.of(context).pop();
          },
          panaraDialogType: PanaraDialogType.success,
        );
      } on FirebaseAuthException catch (e) {
        PanaraInfoDialog.show(
          context,
          title: "Error",
          message: e.message.toString(),
          buttonText: "Okay",
          onTapDismiss: () {
            Navigator.of(context).pop();
          },
          panaraDialogType: PanaraDialogType.error,
        );
      }
    }
    return Scaffold(
      backgroundColor: MyColor().darkblue,
     appBar: AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: MyColor().primarycolor,
     ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Your Email and we will send you a password reset link ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color:  MyColor().white
            ),
            ),
            SizedBox(height: 30,),
            CustomTextFormField(controller: emailcontroller, hintText: "Email "),
            SizedBox(height: 20,),
            ElevatedButton(
              
              style: ButtonStyle(
                 shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), 
                  ),
                ),
                 backgroundColor: WidgetStateProperty.all<Color>(MyColor().primarycolor),
              ),
              onPressed: passwordreset, child:  Text("Reset Password",style: TextStyle(
                color: MyColor().white
              ),),)
          ],
        ),
      ),
    );
    
  }
  
}

TextEditingController emailcontroller = TextEditingController();
