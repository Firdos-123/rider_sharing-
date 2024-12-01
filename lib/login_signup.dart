import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider/map_page.dart';
import 'package:rider/AllWidgets/progressDialog.dart';

class LoginSignUp extends StatefulWidget {
  // Constructor with optional Key
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  _LoginSignUpState createState() => _LoginSignUpState();
}


class _LoginSignUpState extends State<LoginSignUp> {
  final userRef = FirebaseFirestore.instance.collection("users");

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool signUpPage = true;
  String btnText = "SignUp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: navigationOption(),
              ),
              const SizedBox(height: 30),
              logoText(),
              const SizedBox(height: 20),
              Visibility(
                visible: signUpPage,
                child: Column(
                  children: [
                    userNameTextField(),
                    phoneTextField(),
                  ],
                ),
              ),
              emailTextField(),
              passwordTextField(),
              const SizedBox(height: 20),
              signInSignUp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget navigationOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              signUpPage = true;
              btnText = "SignUp";
            });
          },
          child: const Text(
            "SignUp",
            style: TextStyle(color: Colors.grey, fontSize: 25),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              signUpPage = false;
              btnText = "Login";
            });
          },
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.grey, fontSize: 25),
          ),
        ),
      ],
    );
  }

  Widget logoText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/car_ios.png',
          height: 100,
          width: 100,
        ),
        const SizedBox(width: 10),
        const Text(
          "Ryflex",
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.red),
        ),
      ],
    );
  }

  Widget userNameTextField() {
    return textField(
      controller: userNameController,
      hintText: "Enter your username",
      icon: Icons.account_circle,
    );
  }

  Widget phoneTextField() {
    return textField(
      controller: phoneController,
      hintText: "Enter your phone number",
      icon: Icons.phone,
      inputType: TextInputType.phone,
    );
  }

  Widget emailTextField() {
    return textField(
      controller: emailController,
      hintText: "Enter your Email",
      icon: Icons.email,
      inputType: TextInputType.emailAddress,
    );
  }

  Widget passwordTextField() {
    return textField(
      controller: passwordController,
      hintText: "Enter your password",
      icon: Icons.lock,
      obscureText: true,
    );
  }

  Widget textField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        decoration: kBoxDecor,
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.red, fontFamily: 'Opensans'),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 14),
            prefixIcon: Icon(icon, color: Colors.red),
            hintText: hintText,
          ),
        ),
      ),
    );
  }

  Widget signInSignUp() {
    return ElevatedButton(
      onPressed: () {
        signUpPage ? _register() : _login();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          btnText,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _register() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Registering, please wait...");
      },
    );

    final User? user = (await _auth
        .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim())
        .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMsg(context, "$errMsg", "Error");
    }))
        .user;

    if (user != null) {
      userRef.doc(user.uid).set({
        "name": userNameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
      }).catchError((onError) {
      });

      Navigator.pop(context);
      displayToastMsg(context, "Congratulations, account created", "Success");
      setState(() {
        signUpPage = false;
        btnText = "Login";
      });
    } else {
      Navigator.pop(context);
      displayToastMsg(context, "User account creation failed", "Failed");
    }
  }

  void _login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Verifying Login, please wait...");
      },
    );

    final User? user = (await _auth
        .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim())
        .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMsg(context, "$errMsg", "Error");
    }))
        .user;

    if (user != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );

    } else {
      Navigator.pop(context);
      displayToastMsg(context, "Login failed", "Failed");
    }
  }

  final kBoxDecor = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
}

Future<void> displayToastMsg(BuildContext context, String msg, String title) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
