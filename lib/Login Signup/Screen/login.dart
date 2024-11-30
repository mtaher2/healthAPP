import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Login%20Signup/Widget/button.dart';
import 'package:flutter_firebase_project/Password%20Forgot/forgot_password.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Import for checking connectivity
import 'package:email_validator/email_validator.dart'; // Import for email validation // Custom snackbar widget// Your custom text fields
import '../Services/authentication.dart';
import '../Widget/snackbar.dart';
import 'home_screen.dart';
import 'signup.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  // Check if the device has internet connectivity
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Log in the user via Firebase Authentication
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
      // Validate the email format
      if (!EmailValidator.validate(emailController.text)) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
            context, "Please enter a valid email address.", Colors.red);
        return;
      }

      // Authenticate user using Firebase Auth method
      String res = await AuthMethod().loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Handle the result of the authentication
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        // Navigate to the HomeScreen if login is successful
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // Show the error message returned by the AuthMethod
        showSnackBar(context, res, Colors.red);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle any unexpected errors during login
      showSnackBar(
          context, "An error occurred. Please try again later.", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          false, // Prevent the UI from shifting when keyboard appears
      body: Stack(
        children: [
          // SVG Background positioned lower down, behind the SafeArea
          Positioned.fill(
            top: 50, // Adjust the SVG position slightly lower
            child: SvgPicture.asset(
              'assets/images/register.svg', // Replace with your SVG path
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          // Foreground content (SafeArea with text fields, etc.)
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Galla University Logo
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Image.asset(
                      'assets/images/galla_logo.jpeg', // Replace with your logo path
                      height: screenHeight * 0.05,
                    ),
                  ),
                  const Spacer(),
                  // Email Label
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0XFF12284F),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Email Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Password Label
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0XFF12284F),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Password Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to Forgot Password screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFF12284F),
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Login Button
                  Center(
                    child: Container(
                      width: screenWidth * 0.52,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF509E2D),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: loginUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF097CBF),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.013),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  // Signup Link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don’t have an account? Sign up instead",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF12284F),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
