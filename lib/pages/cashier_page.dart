import 'package:flutter/material.dart';
import 'package:nuqta/models/cashier/chashier_statement.dart';

import 'package:nuqta/services/pos.dart';
import 'package:nuqta/theme.dart';
import 'package:nuqta/widgets/date_widget.dart';
import 'package:provider/provider.dart';

class CashierPage extends StatefulWidget {
  static const nv = "/casher";
  @override
  _CashierPageState createState() => _CashierPageState();
}

DateTime? sDate = DateTime.now().subtract(Duration(days: 1000));
DateTime? eDate = DateTime.now();

class _CashierPageState extends State<CashierPage> {
  String? errorText;
  @override
  Widget build(BuildContext context) {
    // final _dSize = MediaQuery.of(context).size;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("حركة الخزينه", style: Them.pageTitle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FutureBuilder<List>(
                future: Provider.of<POS>(context, listen: false).fetchStores(),
                initialData: null,
                builder: (context, AsyncSnapshot<List> snapshot) {
                  return snapshot.data == null
                      ? SizedBox(height: 48)
                      : DropdownButton(
                          hint: Text("النوع"),
                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                          // value: storeId,
                          items: snapshot.data!
                              .map((estore) => DropdownMenuItem(
                                  onTap: () {
                                    setState(() {
                                      // storeId = estore.id;
                                    });
                                  },
                                  value: estore.id,
                                  child: Text(estore.name)))
                              .toList());
                },
              ),
              FutureBuilder<List>(
                future: Provider.of<POS>(context, listen: false).fetchStores(),
                initialData: null,
                builder: (context, AsyncSnapshot<List> snapshot) {
                  return snapshot.data == null
                      ? SizedBox(height: 48)
                      : DropdownButton(
                          hint: Text("الموظف"),
                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                          // value: storeId,
                          items: snapshot.data!
                              .map((estore) => DropdownMenuItem(
                                  onTap: () {
                                    setState(() {
                                      // storeId = estore.id;
                                    });
                                  },
                                  value: estore.id,
                                  child: Text(estore.name)))
                              .toList());
                },
              ),
            ],
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
            child: Material(
                elevation: 10,
                shadowColor: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Table(columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(0.8),
                          2: FlexColumnWidth(0.7),
                          3: FlexColumnWidth(0.7),
                          4: FlexColumnWidth(1.3),
                        }, children: [
                          TableRow(
                            children: [
                              Text(
                                "التاريخ",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "العمليه",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "الوارد",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "المنصرف",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "البيان",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ]),
                      ),
                      Divider(
                        color: const Color(0xff06c4f1),
                        thickness: 2,
                        height: 0,
                      ),
                      Expanded(
                        child: FutureBuilder<List<CashierStatement>>(
                          future: Provider.of<POS>(context, listen: false)
                              .fetchCashierStatements(sDate, eDate),
                          initialData: null,
                          builder: (BuildContext context,
                                  AsyncSnapshot<List<CashierStatement>>
                                      snapshot) =>
                              snapshot.data == null
                                  ? Center(
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CircularProgressIndicator()),
                                    )
                                  : SingleChildScrollView(
                                      child: Table(
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          columnWidths: {
                                            0: FlexColumnWidth(1),
                                            1: FlexColumnWidth(0.8),
                                            2: FlexColumnWidth(0.7),
                                            3: FlexColumnWidth(0.7),
                                            4: FlexColumnWidth(1.3),
                                          },
                                          children: snapshot.data!
                                              .map((state) =>
                                                  TableRow(children: [
                                                    Text(
                                                      state.operationDate
                                                          .toString()
                                                          .split(" ")
                                                          .first,
                                                      style: Them.tableCell
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.operationType
                                                          .toString()
                                                          .split(" ")
                                                          .first,
                                                      style: Them.tableCell,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.credit.toString(),
                                                      style: Them.tableCell,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.debt.toString(),
                                                      style: Them.tableCell,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.description
                                                          .toString(),
                                                      style: Them.tableCell,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ]))
                                              .toList()),
                                    ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
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
