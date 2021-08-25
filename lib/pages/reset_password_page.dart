import 'package:flutter/material.dart';
import 'package:nuqta/services/auth.dart';
import 'package:nuqta/theme.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  static const nv = "/reset-password";
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _inputDeco = InputDecoration(
    fillColor: Colors.transparent,
    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    filled: true,
  );
  Map<String, String> pwData = {"oldP": "", "newP": "", "confirmP": ""};
  TextEditingController _controller = TextEditingController();
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
    });

    final success = await Provider.of<Auth>(context, listen: false)
        .resetPassword(pwData["oldP"], pwData["newP"], pwData["confirmP"]);

    if (success) {
      _showErrorDialog("تاكد من كلمة السر الحاليه");
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("تم اعادة تعيين كلمة السر")));
    }
    setState(() {
      _loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("تم اعادة تعيين كلمة السر"),
      duration: Duration(seconds: 1),
    ));
  }

  void _showErrorDialog(String errorMessage) async {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text(errorMessage),
              actions: [
                TextButton(
                  child: Text("اعد المحاوله"),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final _dSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: _dSize.height * 0.2),
      child: Material(
        animationDuration: Duration(seconds: 3),
        elevation: 10,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'assets/images/logo-s.png',
                  fit: BoxFit.contain,
                )),
            Text(
              "اعادة تعيين كلمة المرور",
              style: Them.pageTitle,
            ),
            Container(
              height: _dSize.height * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          textAlign: TextAlign.center,
                          decoration: _inputDeco.copyWith(
                              labelText: "كلمة السر الحاليه"),
                          onSaved: (newValue) =>
                              pwData["oldP"] = newValue.toString(),
                          validator: (value) {
                            if (value!.length < 6) return "كلمة المرور قصيرة";

                            return null;
                          },
                          textDirection: TextDirection.ltr,
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          decoration: _inputDeco.copyWith(
                              labelText: "كلمة السر الجديده"),
                          controller: _controller,
                          onSaved: (newValue) =>
                              pwData["newP"] = newValue.toString(),
                          validator: (value) {
                            if (value!.length < 6) {
                              return "كلمة المرور قصيرة";
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          decoration: _inputDeco.copyWith(
                              labelText: "تأكيد كلمة السر الجديده"),
                          onSaved: (newValue) =>
                              pwData["confirmP"] = newValue.toString(),
                          validator: (value) {
                            if (value!.length < 6) {
                              return "كلمة المرور قصيرة";
                            } else if (value != _controller.text) {
                              return "كلمة السر غير متطابقة";
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          obscureText: true,
                        ),
                      ])),
            ),
            _loading
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                    ),
                  )
                : _buttonReset(),
          ],
        ),
      ),
    );
  }

  Widget _buttonReset() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 100, left: 100),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade300,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(
                5.0,
                5.0,
              ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextButton(
          onPressed: () => _submit(),
          child: Center(child: Text("اعادة تعيين")),
        ),
      ),
    );
  }
}
