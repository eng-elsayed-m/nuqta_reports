import 'package:adobe_xd/adobe_xd.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:nuqta/services/auth.dart';
import 'package:provider/provider.dart';
// import '../widget/forgot.dart';

class LoginPage extends StatefulWidget {
  static const nv = "login-page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey();
  final _inputDeco = InputDecoration(
    fillColor: Colors.transparent,
    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    filled: true,
  );
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfffbfbfb),
        body: Stack(
          children: <Widget>[
            ..._bg,
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _textLogin,
                  Container(
                    height: MediaQuery.of(context).size.height * 0.26,
                    child: Column(
                      children: [
                        _inputEmail(),
                        _passwordInput(),
                      ],
                    ),
                  ),
                  _loadingIndicator(),
                  _buttonLogin(),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> __submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
    });
    await Provider.of<Auth>(context, listen: false)
        .logIn(email.toString(), password.toString())
        .onError((error, stackTrace) => _showErrorDialog(error.toString()));
    setState(() {
      _loading = false;
    });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Container(
          width: double.infinity,
          child: _loading
              ? LinearProgressIndicator(
                  minHeight: 10,
                )
              : SizedBox(
                  height: 10,
                )),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(
          child: Text(message),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("اعد المحاوله"))
        ],
      ),
    );
  }

  //Form elements *********************
  Widget _inputEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: TextFormField(
        onSaved: (value) => email = value,
        validator: (value) {
          if (value!.isEmpty) {
            return "اسم المستخدم غير صحيح";
          } else
            return null;
        },
        style: TextStyle(color: Colors.blueGrey),
        decoration: _inputDeco.copyWith(
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Image.asset(
                "assets/images/user-1.png",
                width: 30,
                height: 30,
              ),
            ),
            labelText: "اسم المستخدم"),
      ),
    );
  }

  Widget _passwordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: TextFormField(
        onSaved: (value) => password = value,
        validator: (value) {
          if (value!.length <= 6) {
            return "كلمة المرور قصيرة جدا";
          } else
            return null;
        },
        style: TextStyle(
          color: Colors.blueGrey,
        ),
        obscureText: true,
        decoration: _inputDeco.copyWith(
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Image.asset(
                "assets/images/padlock.png",
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            labelText: "كلمة المرور"),
      ),
    );
  }

  Widget _buttonLogin() {
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
          onPressed: () => __submit(),
          child: Center(
            child: Icon(
              Icons.arrow_forward,
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      ),
    );
  }

  //UI elements **************
  List<Widget> _bg = [
    Pinned.fromPins(
      Pin(size: 99.0, start: 24.0),
      Pin(size: 100.0, middle: 0.1831),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(72.0),
          gradient: LinearGradient(
            begin: Alignment(0.87, 0.0),
            end: Alignment(-1.0, 0.0),
            colors: [const Color(0x0006c4f1), const Color(0x30349fb9)],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    ),
    Pinned.fromPins(
      Pin(size: 35.9, middle: 0.6428),
      Pin(size: 36.2, middle: 0.7821),
      child: Transform.rotate(
        angle: 3.159,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(72.0),
            gradient: LinearGradient(
              begin: Alignment(0.87, 0.0),
              end: Alignment(-1.0, 0.0),
              colors: [const Color(0x0006c4f1), const Color(0x30349fb9)],
              stops: [0.0, 1.0],
            ),
          ),
        ),
      ),
    ),
    Pinned.fromPins(
      Pin(size: 51.0, end: 49.5),
      Pin(size: 51.6, middle: 0.258),
      child: Transform.rotate(
        angle: 3.159,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(72.0),
            gradient: LinearGradient(
              begin: Alignment(0.87, 0.0),
              end: Alignment(-1.0, 0.0),
              colors: [const Color(0x0006c4f1), const Color(0x30349fb9)],
              stops: [0.0, 1.0],
            ),
          ),
        ),
      ),
    ),
    Pinned.fromPins(
      Pin(size: 144.0, end: -32.0),
      Pin(size: 146.0, start: -45.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(72.0),
          gradient: LinearGradient(
            begin: Alignment(0.87, 0.0),
            end: Alignment(-1.0, 0.0),
            colors: [const Color(0xff06c4f1), const Color(0xff349fb9)],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    ),
    Pinned.fromPins(
      Pin(size: 281.0, start: -67.0),
      Pin(size: 266.0, end: -118.0),
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset('assets/images/logo-s.png'),
            Text("Developed by : "),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(133.0),
          gradient: LinearGradient(
            begin: Alignment(0.87, 0.0),
            end: Alignment(-1.0, 0.0),
            colors: [const Color(0xff06c4f1), const Color(0xff349fb9)],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    )
  ];
  Widget _textLogin = Column(
    children: <Widget>[
      Image.asset(
        "assets/images/Cubes-logo.png",
        height: 100,
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText("تسجيل الدخول.....",
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                speed: Duration(seconds: 2))
          ],
        ),
      )
    ],
  );
}
