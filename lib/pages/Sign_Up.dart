import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:coffee_soffee/Services/authentication.dart';
import 'package:coffee_soffee/Widget/snack_bar.dart';
import 'package:coffee_soffee/pages/IntroPage.dart';
import 'package:coffee_soffee/pages/Login_page.dart';
import '../Widget/Button.dart';
import '../Widget/text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading=false;
  void despose(){

    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    String res = await AuthServices().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: phoneController.text,
    );


    if(res=="Success"){
      setState(() {
        isLoading=true;
      });
      //navigate to the next screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const IntroPage()));
    }else{
      setState(() {
        isLoading=true;
      });
      //show errormessage
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: double.infinity,
                    height: height / 3.4,
                    child: Lottie.asset("assets/images/animation2.json")),
                const SizedBox(
                  height: 30,
                ),
                TextFieldInpute(
                    textEditingController: nameController,
                    hintText: "Enter your name",
                    icon: Icons.person
                ),
                TextFieldInpute(
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    icon: Icons.email),
                TextFieldInpute(
                    textEditingController: phoneController,
                    hintText: "Enter your phone number",
                    icon: Icons.phone), // New Phone Number field
                TextFieldInpute(
                    textEditingController: passwordController,
                    hintText: "Enter your Password",
                    isPass: true,
                    icon: Icons.lock),
                MyButton(onTab: signUpUser, text: "Sign Up"),
                SizedBox(
                  height: height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.brown),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
