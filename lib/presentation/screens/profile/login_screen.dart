import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/buisness_logic/auth/auth_getx.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/widget/bottom_nav.dart';
import 'package:theate/presentation/screens/profile/forgot_password.dart';
import 'package:theate/presentation/screens/profile/register.dart';
import 'package:theate/presentation/widget/textformwidget.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
   final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      if (authController.user.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => const BottomNav());
        });
        return Container();
      }
      return Scaffold(
          backgroundColor: MyColor().darkblue,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: Stack(
            children: [
       Form(
              key: _formKey,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Center(
                            child: Image.asset(
                              'asset/Movitix_tittle_orange.png',
                              width: screenWidth * 0.7,
                            ),
                          ),
                          Text(
                            'Log in to your account using email ',
                            style: TextStyle(
                                color: MyColor().primarycolor, fontSize: 19),
                          ),
                          Text(
                            'or Google Account ',
                            style: TextStyle(
                                color: MyColor().primarycolor, fontSize: 19),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomTextFormField(
                            errorText: "Email is required",
                              prefixIcon: const Icon(Icons.email),
                              controller: _emailcontroller,
                              hintText: 'email'),
                          const SizedBox(
                            height: 35,
                          ),
                          CustomTextFormField(
                            errorText: "Password is required",
                              prefixIcon: const Icon(Icons.person),
                              obscureText: true,
                              controller: _passwordcontroller,
                              hintText: "Password"),
                             const SizedBox(height: 2,),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(()=> ForgotPasswordPage());
                                    },
                                    child: Text("Forgot Password",style: TextStyle(
                                      color:  MyColor().primarycolor 
                                    ), ),
                                  )
                                ],
                              ),
                          SizedBox(
                            height: screenHeight * 0.06,
                          ),
                          InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  authController.login(_emailcontroller.text.trim(),
            _passwordcontroller.text.trim());
                }
              },
                            child: Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.06,
                              decoration: BoxDecoration(
                                color: MyColor().primarycolor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                  child: Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              )),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: MyColor().gray,
                                  thickness: 1,
                                  endIndent: 10,
                                ),
                              ),
                              Text(
                                "Or continue with Google account",
                                style: TextStyle(color: MyColor().gray),
                              ),
                              Expanded(
                                child: Divider(
                                  color: MyColor().gray,
                                  thickness: 1,
                                  indent: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              // context.read<AuthblocBloc>().add(GoogleSignInEvent());
              
                              // AuthService().singInWithGoogle();
              
                              authController.googleSingIn();
                            },
                            child: Container(
                              height: screenHeight * 0.06,
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                      color: MyColor().gray, width: 0.5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'asset/Google_png.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  const Text(
                                    "  Login With Goolge",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                         const  SizedBox(
                            height: 29,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Didn’t have an account?',
                                style: TextStyle(color: Colors.white),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(() => RegisterPage());
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(color: MyColor().primarycolor),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
             if(authController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                     valueColor: AlwaysStoppedAnimation<Color>(MyColor().primarycolor),
                  ),
                ),
              )
             
            ],
            
          ));
    });
  }
}
