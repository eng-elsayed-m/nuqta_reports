import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:nuqta/services/pos.dart';
import 'package:nuqta/theme.dart';
import 'package:nuqta/widgets/date_widget.dart';
import 'package:provider/provider.dart';

class PosCustomersPage extends StatefulWidget {
  static const nv = "/pos-customers";
  @override
  _PosCustomersPageState createState() => _PosCustomersPageState();
}

class _PosCustomersPageState extends State<PosCustomersPage> {
  DateTime? sDate = DateTime.now().subtract(Duration(days: 1000));
  DateTime? eDate = DateTime.now();
  int? id;
  String? name;
  FloatingSearchBarController? _controller;
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    _controller = FloatingSearchBarController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Text(
                    "كشف حساب عميل",
                    style: Them.pageTitle,
                    textAlign: TextAlign.center,
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
                            child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.top,
                                columnWidths: {
                                  0: FlexColumnWidth(0.7),
                                  1: FlexColumnWidth(1.2),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(0.8),
                                  4: FlexColumnWidth(0.8),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Text(
                                        "الرقم",
                                        style: Them.tableHeader,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "نوع العمليه",
                                        style: Them.tableHeader,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "التاريخ",
                                        style: Them.tableHeader,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "مدين",
                                        style: Them.tableHeader,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "دائن",
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
                                  .fetchCustomerStatements(sDate, eDate, id),
                              initialData: null,
                              builder: (BuildContext context,
                                      AsyncSnapshot snapshot) =>
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? Center(
                                          child: SizedBox(
                                              width: 70,
                                              height: 70,
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : SingleChildScrollView(
                                          child: Table(
                                              defaultVerticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              columnWidths: {
                                                0: FlexColumnWidth(0.7),
                                                1: FlexColumnWidth(1.2),
                                                2: FlexColumnWidth(1),
                                                3: FlexColumnWidth(0.8),
                                                4: FlexColumnWidth(0.8),
                                              },
                                              children: Provider.of<POS>(
                                                      context)
                                                  .cStatements
                                                  .map((state) =>
                                                      TableRow(children: [
                                                        Text(
                                                          state.number
                                                              .toString(),
                                                          style: Them.tableCell,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          state.operationType
                                                              .toString(),
                                                          style: Them.tableCell,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
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
                                                          state.credit
                                                              .toString(),
                                                          style: Them.tableCell,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          state.debt.toString(),
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
                    ),
                  ),
                ),
              ],
            ),
            buildFloatingSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    return FloatingSearchBar(
      controller: _controller,
      hint: name ?? 'العملاء...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      width: double.infinity,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        if (query.isNotEmpty) {
          Provider.of<POS>(context, listen: false).fetchCustomers(query);
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Provider.of<POS>(context).customers.map((custo) {
                return InkWell(
                    onTap: () {
                      id = custo.id;
                      print(custo.id);
                      name = custo.name;
                      setState(() {});
                      _controller!.close();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35)),
                        height: 50,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                custo.name,
                              ),
                            ),
                          ],
                        )));
              }).toList(),
            ),
          ),
        );
      },
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
