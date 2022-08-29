import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plugon_mobile/constants/colors.dart';
import 'package:plugon_mobile/providers/auth.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final String email_or_username = 'username';

  final String password = 'password';

  final _fbLoginKey = GlobalKey<FormBuilderState>();

  bool _isLoading = false;

  void _onLoginPressed(BuildContext context) async {
    if (_fbLoginKey.currentState!.saveAndValidate()) {
      final formData = _fbLoginKey.currentState!.value;

      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).signIn(
          formData[email_or_username],
          formData[password],
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        FocusScope.of(context).unfocus();
        _fbLoginKey.currentState!.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: FormBuilder(
            key: _fbLoginKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  name: email_or_username,
                  decoration: const InputDecoration(
                      labelText: 'Email or username',
                      border: OutlineInputBorder()),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'Không được để trống'),
                  ]),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                    name: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password', border: OutlineInputBorder()),
                    validator: FormBuilderValidators.required(
                        errorText: 'Không được để trống')),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => _onLoginPressed(context),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(loginButtonColor),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                              fontWeight: FontWeight.w900,
                            ),
                          )),
              ],
            )),
      ),
    );
  }
}
