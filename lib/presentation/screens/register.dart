import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:theate/buisness_logic/auth/auth_getx.dart';

import 'package:theate/data/models/usermodel.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/screens/login_screen.dart';

import 'package:theate/presentation/widget/textformwidget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailnamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor().darkblue,
        iconTheme: IconThemeData(color: MyColor().primarycolor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                      Center(
                        child: Image.asset(
                          'asset/Movitix_tittle_orange.png',
                          width: screenwidth * 0.7,
                        ),
                      ),
                      Text(
                        'Create an Account',
                        style: TextStyle(
                            color: MyColor().primarycolor, fontSize: 24),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormField(
                          prefixIcon: Icon(Icons.person),
                          controller: _namecontroller,
                          hintText: "Full Name"),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextFormField(
                          prefixIcon: const Icon(Icons.email),
                          controller: _emailnamecontroller,
                          hintText: " Email"),
                      SizedBox(
                        height: 30,
                      ),
                      CustomTextFormField(
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                          controller: _usernamecontroller,
                          hintText: "Username"),
                      SizedBox(
                        height: 30,
                      ),
                      CustomTextFormField(
                          prefixIcon: Icon(Icons.lock),
                          controller: _passwordcontroller,
                          hintText: "Password"),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: screenwidth * 0.9,
                        height: screenheight * 0.06,
                        decoration: BoxDecoration(
                          color: MyColor().primarycolor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: InkWell(
                          onTap: () {
                            Usermodel user = Usermodel(
                                name: _namecontroller.text,
                                email: _emailnamecontroller.text,
                                password: _passwordcontroller.text,
                                userid: _usernamecontroller.text);
                            // authbloc.add(SingupEvent(user: user));
                            authController.signUp(user);
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        )),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            ' Already have an account? ',
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                "Login Here",
                                style: TextStyle(color: MyColor().primarycolor),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: MyColor().darkblue,
        );
      }
    
  }

