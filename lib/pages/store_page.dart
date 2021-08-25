import 'package:flutter/material.dart';
import 'package:nuqta/models/store/store.dart';
import 'package:nuqta/services/pos.dart';
import 'package:nuqta/theme.dart';
import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class StorePage extends StatefulWidget {
  static const nv = "/stores";

  @override
  _StorePageState createState() => _StorePageState();
}

// final ScrollController? _scrollController = ScrollController();
final _inputDeco = InputDecoration(
  fillColor: Colors.transparent,
  contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
  border: InputBorder.none,
  filled: true,
);

class _StorePageState extends State<StorePage> {
  int? storeId;
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          decoration: _inputDeco.copyWith(
              hintText: "الاصناف...",
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
              )),
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              " المخازن ",
              style: Them.pageTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder<List<Store>>(
              future: Provider.of<POS>(context, listen: false).fetchStores(),
              initialData: null,
              builder: (context, AsyncSnapshot<List<Store>> snapshot) {
                return snapshot.data == null
                    ? SizedBox(height: 48)
                    : DropdownButton(
                        disabledHint: Text("....."),
                        hint: Text("اختر مخزن"),
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        value: storeId,
                        onChanged: (value) {},
                        items: snapshot.data!
                            .map((estore) => DropdownMenuItem(
                                onTap: () {
                                  setState(() {
                                    storeId = estore.id;
                                  });
                                },
                                value: estore.id,
                                child: Text(estore.name)))
                            .toList());
              },
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
                          1: FlexColumnWidth(0.8),
                          2: FlexColumnWidth(0.6),
                          3: FlexColumnWidth(0.8),
                          4: FlexColumnWidth(0.6),
                        }, children: [
                          TableRow(
                            children: [
                              Text(
                                "الصنف",
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
                              Text(
                                "التكلفه",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "القيمه",
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
                              .fetchStoreStatements(storeId),
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
                                            1: FlexColumnWidth(0.8),
                                            2: FlexColumnWidth(0.6),
                                            3: FlexColumnWidth(0.8),
                                            4: FlexColumnWidth(0.6),
                                          },
                                          children: Provider.of<POS>(context)
                                              .sStatements
                                              .where((element) => element
                                                  .productName!
                                                  .contains(query))
                                              .map((state) =>
                                                  TableRow(children: [
                                                    Text(
                                                      state.productName
                                                          .toString(),
                                                      style: Them.tableCell,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // textAlign:
                                                      //     TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.quantity.toString(),
                                                      style: Them.tableCell,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.salePrice
                                                          .toString()
                                                          .split(" ")
                                                          .first,
                                                      style: Them.tableCell,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.cost.toString(),
                                                      style: Them.tableCell,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.value.toString(),
                                                      style: Them.tableCell,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ]))
                                              .toList()),
                                    ),
                        ),
                      )
                    ],
                  ),
                )

                // FutureBuilder(
                //   future: Provider.of<POS>(context, listen: false)
                //       .fetchStoreStatements(storeId),
                //   initialData: null,
                //   builder: (BuildContext context, AsyncSnapshot snapshot) =>
                //       snapshot.connectionState == ConnectionState.waiting
                //           ? Center(
                //               child: SizedBox(
                //                   width: 70,
                //                   height: 70,
                //                   child: CircularProgressIndicator()),
                //             )
                //           : SingleChildScrollView(
                //               child: Padding(
                //                 padding: const EdgeInsets.all(10.0),
                //                 child: DataTable(
                //                   dataTextStyle: TextStyle(
                //                       fontSize: 30,
                //                       color: Colors.black,
                //                       fontWeight: FontWeight.w800),
                //                   dataRowHeight: 70,
                //                   columnSpacing: 30,
                //                   headingTextStyle: TextStyle(
                //                       color: Colors.black,
                //                       fontSize: 50,
                //                       fontWeight: FontWeight.w800),
                //                   columns: [
                //                     DataColumn(label: Text("الصنف")),
                //                     DataColumn(label: Text("الكميه")),
                //                     DataColumn(label: Text("السعر")),
                //                     DataColumn(label: Text("التكلفه")),
                //                     DataColumn(label: Text("القيمه")),
                //                   ],
                //                   rows: Provider.of<POS>(context)
                //                       .sStatements
                //                       .where((element) =>
                //                           element.productName!.contains(query))
                //                       .map((state) => DataRow(cells: [
                //                             DataCell(Text(
                //                               state.productName.toString(),
                //                             )),
                //                             DataCell(Text(
                //                               state.quantity.toString() +
                //                                   " " +
                //                                   state.unitName.toString(),
                //                             )),
                //                             DataCell(Text(
                //                               state.salePrice
                //                                   .toString()
                //                                   .split(" ")
                //                                   .first,
                //                             )),
                //                             DataCell(Text(
                //                               state.cost.toString(),
                //                             )),
                //                             DataCell(Text(
                //                               state.value.toString(),
                //                             ))
                //                           ]))
                //                       .toList(),
                //                 ),
                //               ),
                //             ),
                // ),

                ),
          ),
        ],
      ),
    );
  }
}
