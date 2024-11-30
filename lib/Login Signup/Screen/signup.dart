import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_firebase_project/Login%20Signup/Widget/button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Services/authentication.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import 'login.dart';
import 'verification_screen.dart'; // Import the VerificationScreen

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signupUser() async {
    // Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showSnackBar(context,
          'No internet connection. Please check your network.', Colors.red);
      return;
    }

    // Set isLoading to true
    setState(() {
      isLoading = true;
    });

    // Sign up user using our auth method
    String res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    // If string returned is "success", user has been created and navigate to the verification screen.
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      // Navigate to the verification screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const VerificationScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // Show error
      showSnackBar(context, res, Colors.red);
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
                  //name
                  const Text(
                    "Name",
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
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
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
                  SizedBox(height: screenHeight * 0.05),

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
                              onPressed: signupUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF097CBF),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.013),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "sign up",
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
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Already have an account? Login instead ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF12284F),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
