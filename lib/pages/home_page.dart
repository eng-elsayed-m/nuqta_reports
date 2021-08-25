import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:nuqta/pages/reset_password_page.dart';
import 'package:nuqta/services/auth.dart';
import 'package:nuqta/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const nv = "home-page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  final ButtonStyle buttonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
  bool _app = true; //false = restaurant ... true = pos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SliderMenuContainer(
            hasAppBar: false,
            appBarColor: Colors.white,
            slideDirection: SlideDirection.RIGHT_TO_LEFT,
            drawerIcon: null,
            key: _key,
            sliderMenu: _sideMenu(),
            title: Text(""),
            sliderMenuOpenSize: 205,
            sliderMain: _homeWidget()),
      ),
    );
  }

  Widget _homeWidget() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
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
        Container(
            child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () => _key.currentState!.isDrawerOpen
                      ? _key.currentState!.closeDrawer()
                      : _key.currentState!.openDrawer(),
                  child: Image.asset(
                    "assets/images/menu.png",
                    width: 47,
                    height: 50,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                "assets/images/logo-s.png",
                width: 135,
                height: 125,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 150,
              height: 100,
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                  WavyAnimatedText("Cubes",
                      speed: Duration(seconds: 8),
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          fontFamily: "")),
                  RotateAnimatedText("For IT Solutions",
                      duration: Duration(seconds: 16),
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(fontWeight: FontWeight.w900)),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                  constraints: BoxConstraints(minHeight: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: SingleChildScrollView(
                    child: Text(
                      "قد تأسست الشركة منذ العام 2017م تحت ترخيص تجاري رقم (9414) على يد فريق عمل من الخبراء المحترفين، الذين يسعون لتقديم أعمال مبتكرة وإبداعية ذات جودة عالية، تساهم في رفع مستوى جودة خدمات الهواتف الذكية في السوق الليبي.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        )),
      ],
    );
  }

  Widget _sideMenu() {
    Widget _divider = Divider(
      indent: 10,
      endIndent: 10,
      height: 0,
      thickness: 1.5,
      color: Colors.cyanAccent.shade700,
    );
    return Container(
      width: 200,
      child: Column(
        children: [
          Container(
            width: 200,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.87, 0.0),
                end: Alignment(-1.0, 0.0),
                colors: [const Color(0xffdedede), const Color(0xff349fb9)],
                stops: [0.0, 1.0],
              ),
            ),
            child: Center(child: Image.asset("assets/images/logo-s.png")),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      setState(() {
                        _app = false;
                      });
                    },
                    child: Icon(
                      Icons.restaurant,
                      size: 30,
                    )),
              ),
              Expanded(
                child: TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      setState(() {
                        _app = true;
                      });
                    },
                    child: Icon(
                      Icons.store,
                      size: 30,
                    )),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                  duration: Duration(seconds: 7),
                  child: _app
                      ? Column(
                          key: ValueKey(2),
                          children: [
                            Divider(
                              height: 0,
                              thickness: 2,
                              color: Colors.cyanAccent.shade700,
                            ),
                            ListTile(
                              leading: Icon(Icons.person, color: Colors.blue),
                              title: Text("كشف حساب عميل",
                                  style: Them.drawerItemText),
                              onTap: () => Navigator.of(context)
                                  .pushNamed("/pos-customers"),
                            ),
                            _divider,
                            ListTile(
                              leading: Icon(Icons.view_agenda_rounded,
                                  color: Colors.blue),
                              title: Text("كشف حساب مورد",
                                  style: Them.drawerItemText),
                              onTap: () => Navigator.of(context)
                                  .pushNamed("/pos-vendors"),
                            ),
                            _divider,
                            ListTile(
                              leading: Icon(Icons.storage, color: Colors.blue),
                              title:
                                  Text("المخازن", style: Them.drawerItemText),
                              onTap: () =>
                                  Navigator.of(context).pushNamed("/stores"),
                            ),
                            _divider,
                            ListTile(
                              leading: Icon(Icons.payment, color: Colors.blue),
                              title:
                                  Text("المصروفات", style: Them.drawerItemText),
                              onTap: () =>
                                  Navigator.of(context).pushNamed("/expenses"),
                            ),
                            _divider,
                            ListTile(
                              leading:
                                  Icon(Icons.attach_money, color: Colors.blue),
                              title:
                                  Text("الارباح", style: Them.drawerItemText),
                              onTap: () =>
                                  Navigator.of(context).pushNamed("/profits"),
                            ),
                            _divider,
                            ListTile(
                              leading: Icon(Icons.money, color: Colors.blue),
                              title: Text("الديون", style: Them.drawerItemText),
                              onTap: () =>
                                  Navigator.of(context).pushNamed("/debts"),
                            ),
                            _divider,
                            ListTile(
                              leading:
                                  Icon(Icons.inventory, color: Colors.blue),
                              title: Text("حركة الخزينه",
                                  style: Them.drawerItemText),
                              onTap: () =>
                                  Navigator.of(context).pushNamed("/casher"),
                            ),
                            _divider,
                            ListTile(
                              leading: Icon(Icons.wysiwyg, color: Colors.blue),
                              title: Text(" حركة الفاتوره",
                                  style: Them.drawerItemText),
                              onTap: () =>
                                  Navigator.of(context).pushNamed("/invoices"),
                            ),
                            _divider,
                            ListTile(
                              leading: Icon(Icons.production_quantity_limits,
                                  color: Colors.blue),
                              title: Text(" حركة الصنف",
                                  style: Them.drawerItemText),
                              onTap: () =>
                                  Navigator.of(context).pushNamed("/product"),
                            ),
                            _divider,
                          ],
                        )
                      : Column(
                          key: ValueKey(1),
                          children: [
                            Divider(
                              height: 0,
                              thickness: 2,
                              color: Colors.cyanAccent.shade700,
                            ),
                            ListTile(
                              leading: Icon(Icons.document_scanner_sharp,
                                  color: Colors.blue),
                              horizontalTitleGap: 0.5,
                              title: Text("التقارير اليوميه",
                                  style: Them.drawerItemText),
                              onTap: () => Navigator.of(context)
                                  .pushNamed("/daily-reports"),
                            ),
                            _divider,
                          ],
                        )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () => showDialog(
                          context: context,
                          builder: (ctx) => ResetPasswordPage(),
                        ),
                    child: Text("اعادة تعيين كلمة السر")),
                IconButton(
                    onPressed: () =>
                        Provider.of<Auth>(context, listen: false).logout(),
                    icon: Icon(Icons.logout)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
