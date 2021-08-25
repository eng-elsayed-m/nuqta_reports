import 'package:flutter/material.dart';
import 'package:nuqta/services/pos.dart';
import 'package:nuqta/theme.dart';
import 'package:nuqta/widgets/date_widget.dart';
import 'package:provider/provider.dart';

class ProfitsPage extends StatefulWidget {
  static const nv = "/profits";
  @override
  _ProfitsPageState createState() => _ProfitsPageState();
}

class _ProfitsPageState extends State<ProfitsPage> {
  DateTime? sDate = DateTime.now().subtract(Duration(days: 1000));
  DateTime? eDate = DateTime.now();

  String? errorText;
  @override
  Widget build(BuildContext context) {
    final _dSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: _dSize.height,
        width: _dSize.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("الارباح", style: Them.pageTitle),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("من :" + sDate.toString().split(" ").first),
                  UiWidgets.datePicker(context, onSelectionChanged),
                  Text("الى :" + eDate.toString().split(" ").first),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 35),
                child: Material(
                    elevation: 10,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(35),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30),
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: Provider.of<POS>(context, listen: false)
                            .fetchProfits(sDate, eDate),
                        initialData: null,
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          return snapshot.data == null
                              ? Center(
                                  child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: CircularProgressIndicator(),
                                ))
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "ربح المبيعات",
                                          style: Them.tableHeader,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 220,
                                          color: Colors.white,
                                          child: Center(
                                              child: Text(
                                            snapshot.data!["sales"].toString(),
                                            style: Them.tableCell
                                                .copyWith(fontSize: 13),
                                          )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "خصم المبيعات",
                                          style: Them.tableHeader,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 220,
                                          color: Colors.white,
                                          child: Center(
                                              child: Text(
                                            snapshot.data!["salesDiscounts"]
                                                .toString(),
                                            style: Them.tableCell
                                                .copyWith(fontSize: 13),
                                          )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "ارجاع المبيعات",
                                          style: Them.tableHeader,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 220,
                                          color: Colors.white,
                                          child: Center(
                                              child: Text(
                                            snapshot.data!["returnSales"]
                                                .toString(),
                                            style: Them.tableCell
                                                .copyWith(fontSize: 13),
                                          )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "المصروفات",
                                          style: Them.tableHeader,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 220,
                                          color: Colors.white,
                                          child: Center(
                                              child: Text(
                                            snapshot.data!["expenses"]
                                                .toString(),
                                            style: Them.tableCell
                                                .copyWith(fontSize: 13),
                                          )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "صافى الربح",
                                          style: Them.tableHeader,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 220,
                                          color: Colors.greenAccent,
                                          child: Center(
                                              child: Text(
                                            snapshot.data!["netProfit"]
                                                .toString(),
                                            style: Them.tableCell
                                                .copyWith(fontSize: 13),
                                          )),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                        },
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSelectionChanged(value) {
    if (value.startDate != null) {
      sDate = value.startDate;
    }
    if (value.endDate != null) {
      eDate = value.endDate;
    }
    setState(() {});
  }
}
