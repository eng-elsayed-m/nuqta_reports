import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuqta/services/pos.dart';
import 'package:nuqta/theme.dart';
import 'package:nuqta/widgets/date_widget.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatefulWidget {
  static const nv = "/expenses";
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  String query = "";
  DateTime? sDate = DateTime.now().subtract(Duration(days: 1000));
  DateTime? eDate = DateTime.now();
  ScrollController _scrollController = ScrollController();

  final _inputDeco = InputDecoration(
    fillColor: Colors.transparent,
    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
    border: InputBorder.none,
    filled: true,
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollEndEvent);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEndEvent);
    super.dispose();
  }

  int? expenseTypeId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: TextField(
          onChanged: (value) {
            query = value;
            setState(() {});
          },
          decoration: _inputDeco.copyWith(
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: "نوع المصروفات..."),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "المصروفات",
              style: Them.pageTitle,
            ),
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
                          1: FlexColumnWidth(0.7),
                          2: FlexColumnWidth(0.7),
                          // 3: FlexColumnWidth(0.7),
                        }, children: [
                          TableRow(
                            children: [
                              Text(
                                "نوع المصروف",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "التاريخ",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "القيمه",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              // Text(
                              //   "ملاحظة",
                              //   style: Them.tableHeader,
                              //   textAlign: TextAlign.center,
                              // ),
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
                                            0: FlexColumnWidth(1),
                                            1: FlexColumnWidth(0.7),
                                            2: FlexColumnWidth(0.7),
                                            // 3: FlexColumnWidth(0.8),
                                          },
                                          children: Provider.of<POS>(context)
                                              .eStatements
                                              .where((element) => element
                                                  .expenseTypeName!
                                                  .contains(query))
                                              .map((state) =>
                                                  TableRow(children: [
                                                    Text(
                                                      state.expenseTypeName
                                                          .toString(),
                                                      style: Them.tableCell,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // textAlign:
                                                      //     TextAlign.center,
                                                    ),
                                                    Text(
                                                      state.expenseDate
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
                                                      state.value.toString(),
                                                      style: Them.tableCell,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    // Text(
                                                    //   state.notes
                                                    //               .toString()
                                                    //               .trim() ==
                                                    //           ""
                                                    //       ? "خاليه"
                                                    //       : state.notes
                                                    //           .toString(),
                                                    //   style: Them.tableCell,
                                                    //   overflow:
                                                    //       TextOverflow.ellipsis,
                                                    // ),
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

  Future<void> _onScrollEndEvent() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // await Provider.of<Restaurant>(context, listen: false)
      //     .fetcNexthReports(sDate, eDate);
    }
  }
}
