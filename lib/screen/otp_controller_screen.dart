import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:registration_phone_number/screen/home_screen.dart';

class OtpControllerScreen extends StatefulWidget {
  final String phone;
  final String codeDigits;
  const OtpControllerScreen({Key? key, required this.phone, required this.codeDigits}) : super(key: key);

  @override
  State<OtpControllerScreen> createState() => _OtpControllerScreenState();
}

class _OtpControllerScreenState extends State<OtpControllerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOtpController = TextEditingController();
  final FocusNode _pinOtpFocus = FocusNode();
  String? verificationCode;

  final PinTheme pinOtpDecoration = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.codeDigits + widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      },
      codeSent: (vId, resendToken) {
        setState(() {
          verificationCode = vId;
        });
      },
      codeAutoRetrievalTimeout: (vId) {
        setState(() {
          verificationCode = vId;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  verifyPhoneNumber();
                },
                child: Text(
                  "Verifying: ${widget.codeDigits}-${widget.phone}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Pinput(
                length: 6,
                focusNode: _pinOtpFocus,
                controller: _pinOtpController,
                defaultPinTheme: pinOtpDecoration,
                pinAnimationType: PinAnimationType.rotation,
                onSubmitted: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationCode!, smsCode: pin))
                        .then((value) {
                      if (value.user != null) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const HomeScreen();
                        }));
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid OTP"),
                        duration: Duration(
                          seconds: 3,
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
