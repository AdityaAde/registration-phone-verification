import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:registration_phone_number/screen/otp_controller_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeDigits = '';
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              SizedBox(
                width: 400,
                height: 60,
                child: CountryCodePicker(
                  onChanged: (country) {
                    setState(() {
                      dialCodeDigits = country.dialCode!;
                    });
                  },
                  initialSelection: "ID",
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nomor Handphone',
                    prefix: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(dialCodeDigits),
                    ),
                  ),
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukan Nomor Handphone';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return OtpControllerScreen(
                          phone: _controller.text,
                          codeDigits: dialCodeDigits,
                        );
                      }));
                    }
                  },
                  child: const Text("Lanjut"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
