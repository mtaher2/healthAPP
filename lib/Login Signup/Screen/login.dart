import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Login%20Signup/Widget/button.dart';
import 'package:flutter_firebase_project/Password%20Forgot/forgot_password.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Import for checking connectivity
import 'package:email_validator/email_validator.dart'; // Import for email validation
import '../Services/authentication.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import 'home_screen.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> loginUser() async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      showSnackBar(
          context,
          "No internet connection. Please check your network settings.",
          Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Validate email format
      if (!EmailValidator.validate(emailController.text)) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
            context, "Please enter a valid email address.", Colors.red);
        return;
      }

      // Authenticate user using the AuthMethod class
      String res = await AuthMethod().loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // Show specific error message
        showSnackBar(context, res, Colors.red);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
          context, "An error occurred. Please try again later.", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01), // Adjust padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.39,
                  child:
                      Image.asset('assets/images/Medical research-amico.png'),
                ),
                SizedBox(height: height * 0.02),
                // Email input
                SizedBox(
                  width: double.infinity,
                  child: TextFieldInput(
                    icon: Icons.person,
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType:
                        TextInputType.emailAddress, // Use emailAddress type
                  ),
                ),
                SizedBox(height: height * 0.02),
                // Password input
                SizedBox(
                  width: double.infinity,
                  child: TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                ),
                SizedBox(height: height * 0.02),
                const ForgotPassword(),
                SizedBox(height: height * 0.02),
                // Show loading indicator or login button
                SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff4771f5)),
                        ))
                      : MyButtons(onTap: loginUser, text: "Log In"),
                ),
                SizedBox(height: height * 0.02),
                // Signup link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Color(0xff4771f5)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
