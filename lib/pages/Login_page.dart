import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:coffee_soffee/Widget/Button.dart';
import 'package:coffee_soffee/pages/IntroPage.dart';
import 'package:coffee_soffee/pages/Sign_Up.dart';
import '../Services/authentication.dart';
import '../Widget/snack_bar.dart';
import '../Widget/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth= AuthServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  void despose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUsers() async {
    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "Success") {
      setState(() {
        isLoading = true;
      });
      //navigate to the next screen
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroPage()));
    } else {
      setState(() {
        isLoading = true;
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
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    icon: Icons.email),
                TextFieldInpute(
                  isPass: true,
                    textEditingController: passwordController,
                    hintText: "Enter your Password",
                    icon: Icons.lock),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.brown),
                    ),
                  ),
                ),
                MyButton(onTab: loginUsers, text: "Log In"),
                const SizedBox(height: 10,),
                ElevatedButton(onPressed: ()async {
                    await _auth.loginWithGoogle();
                }, child: const Text("Sign In with Google")),
                
                SizedBox(
                  height: height / 15,
                ),
                // InkWell(
                //   onTap: ()async{
                //     await _auth.loginWithGoogle();
                //   },
                //   child: Container(
                //     height: 50,
                //       width: 50,
                //       child: Image.asset('assets/icons/google-symbol.png')),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ));
                      },
                      child: const Text(
                        "SignUp",
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
