import 'package:flutter/material.dart';
import 'package:nuqta/services/pos.dart';
import 'package:nuqta/theme.dart';
import 'package:nuqta/widgets/date_widget.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  static const nv = "/product";
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  DateTime? sDate = DateTime.now().subtract(Duration(days: 1000));
  DateTime? eDate = DateTime.now();
  final _inputDeco = InputDecoration(
    fillColor: Colors.transparent,
    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
    border: InputBorder.none,
    filled: true,
  );
  String? errorText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: TextField(
          onChanged: (value) {
            setState(() {
              // query = value;
            });
          },
          decoration: _inputDeco.copyWith(
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: "نوع المصروفات..."),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("حركة الصنف", style: Them.pageTitle),
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
                          disabledHint: Text("....."),
                          hint: Text("المخزن"),
                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                          // value: storeId,
                          onChanged: (value) {},
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
                      ? SizedBox(height: 12)
                      : DropdownButton(
                          hint: Text("نوع العمليه"),
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
                          0: FlexColumnWidth(1.5),
                          1: FlexColumnWidth(0.9),
                          2: FlexColumnWidth(0.9),
                          3: FlexColumnWidth(1.2),
                        }, children: [
                          TableRow(
                            children: [
                              Text(
                                "رقم الفاتوره",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "النوع",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "التاريخ",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "الكميه",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "السعر",
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
                        child: FutureBuilder(
                          future: Provider.of<POS>(context, listen: false)
                              .fetchExpenseStatements(sDate, eDate),
                          initialData: null,
                          builder: (BuildContext context,
                                  AsyncSnapshot snapshot) =>
                              snapshot.connectionState ==
                                      ConnectionState.waiting
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
                                            0: FlexColumnWidth(1.5),
                                            1: FlexColumnWidth(0.9),
                                            2: FlexColumnWidth(0.9),
                                            3: FlexColumnWidth(1.2),
                                          },
                                          children: []
                                          //  Provider.of<POS>(context)
                                          //     .eStatements
                                          //     .map((state) =>
                                          //         TableRow(children: [
                                          //           Text(
                                          //             state.expenseTypeName
                                          //                 .toString(),
                                          //             style: Them.tableCell,
                                          //             overflow: TextOverflow
                                          //                 .ellipsis,
                                          //           ),
                                          //           SizedBox(),
                                          //           Text(
                                          //             state.expenseDate
                                          //                 .toString()
                                          //                 .split(" ")
                                          //                 .first,
                                          //           ),
                                          //           Text(
                                          //             state.value.toString(),
                                          //             style: Them.tableCell,
                                          //           ),
                                          //         ]))
                                          //     .toList()
                                          ),
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
