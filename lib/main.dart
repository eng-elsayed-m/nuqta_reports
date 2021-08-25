import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nuqta/app_localization.dart';
import 'package:nuqta/pages/cashier_page.dart';
import 'package:nuqta/pages/debts_page.dart';
import 'package:nuqta/pages/expenes_page.dart';
import 'package:nuqta/pages/invoices_page.dart';
import 'package:nuqta/pages/pos_vendors_page.dart';
import 'package:nuqta/pages/product_page.dart';
import 'package:nuqta/pages/profits_page.dart';
import 'package:nuqta/pages/reset_password_page.dart';
import 'package:nuqta/pages/restaurant_reports_page.dart';
import 'package:nuqta/pages/home_page.dart';
import 'package:nuqta/pages/pos_customers_page.dart';
import 'package:nuqta/pages/store_page.dart';
import 'package:nuqta/services/auth.dart';
import 'package:nuqta/services/pos.dart';
import 'package:nuqta/services/restaurant.dart';
import 'package:provider/provider.dart';
import './pages/login.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Restaurant>(
          update: (ctx, auth, previousData) => Restaurant(auth.token),
          create: (_) => Restaurant(""),
        ),
        ChangeNotifierProxyProvider<Auth, POS>(
          update: (ctx, auth, previousData) => POS(auth.token),
          create: (_) => POS(""),
        ),
      ],
      builder: (context, child) => Consumer<Auth>(
        builder: (context, _auth, child) => MaterialApp(
          supportedLocales: [
            // Locale("en", "US"),
            Locale("ar", "EG")
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.countryCode == locale!.countryCode &&
                  supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            }),
            fontFamily: "Droid",
            primarySwatch: Colors.blue,
          ),
          home: _auth.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: _auth.autoLogin(),
                  builder: (ctx, AsyncSnapshot snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Container(
                              width: double.infinity,
                              height: 500,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/logo-s.png",
                                    width: 200,
                                    height: 200,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 25),
                                    child: LinearProgressIndicator(
                                      minHeight: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : LoginPage()),
          routes: {
            HomePage.nv: (ctx) => HomePage(),
            LoginPage.nv: (ctx) => LoginPage(),
            ResturantReportsPage.nv: (ctx) => ResturantReportsPage(),
            PosCustomersPage.nv: (ctx) => PosCustomersPage(),
            ResetPasswordPage.nv: (ctx) => ResetPasswordPage(),
            PosVendorsPage.nv: (ctx) => PosVendorsPage(),
            StorePage.nv: (ctx) => StorePage(),
            ProfitsPage.nv: (ctx) => ProfitsPage(),
            ExpensesPage.nv: (ctx) => ExpensesPage(),
            DebtsPage.nv: (ctx) => DebtsPage(),
            CashierPage.nv: (ctx) => CashierPage(),
            InvoicesPage.nv: (ctx) => InvoicesPage(),
            ProductPage.nv: (ctx) => ProductPage(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
