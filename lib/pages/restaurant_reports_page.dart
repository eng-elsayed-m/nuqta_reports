import 'package:flutter/material.dart';
import 'package:nuqta/pages/restaurant_products_page.dart';
import 'package:nuqta/services/restaurant.dart';
import 'package:nuqta/theme.dart';
import 'package:nuqta/widgets/date_widget.dart';
import 'package:provider/provider.dart';

class ResturantReportsPage extends StatefulWidget {
  static const nv = "/daily-reports";
  @override
  _ResturantReportsPageState createState() => _ResturantReportsPageState();
}

class _ResturantReportsPageState extends State<ResturantReportsPage> {
  DateTime? sDate = DateTime.now().subtract(Duration(days: 1000));
  DateTime? eDate = DateTime.now();
  ScrollController _scrollController = ScrollController();

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

  String? errorText;
  @override
  Widget build(BuildContext context) {
    // List<ResturantReport> _reports = Provider.of<POS>(context)
    bool _loadmore = false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
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
            padding: const EdgeInsets.only(top: 10.0),
            child: Text("التقارير اليوميه", style: Them.pageTitle),
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
                          0: FlexColumnWidth(0.3),
                          1: FlexColumnWidth(0.7),
                          2: FlexColumnWidth(0.5),
                          3: FlexColumnWidth(0.5),
                        }, children: [
                          TableRow(
                            children: [
                              Text(
                                "الرقم",
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
                                "الاجمالى",
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
                          future:
                              Provider.of<Restaurant>(context, listen: false)
                                  .fetchReports(sDate, eDate),
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
                                      controller: _scrollController,
                                      child: Table(
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          columnWidths: {
                                            0: FlexColumnWidth(0.3),
                                            1: FlexColumnWidth(0.7),
                                            2: FlexColumnWidth(0.5),
                                            3: FlexColumnWidth(0.5),
                                          },
                                          children: Provider.of<Restaurant>(
                                                  context)
                                              .restaurantReports
                                              .map((repo) =>
                                                  TableRow(children: [
                                                    InkWell(
                                                      onTap: () => Navigator.of(
                                                              context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            RestaurantProductsPage(
                                                                repo.targetDate!,
                                                                repo.totalSales!),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0),
                                                        child: Text(
                                                          repo.dataID
                                                              .toString(),
                                                          style: Them.tableCell,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () => Navigator.of(
                                                              context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            RestaurantProductsPage(
                                                                repo.targetDate!,
                                                                repo.totalSales!),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0),
                                                        child: Text(
                                                          repo.targetDate
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
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () => Navigator.of(
                                                              context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            RestaurantProductsPage(
                                                                repo.targetDate!,
                                                                repo.totalSales!),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0),
                                                        child: Text(
                                                          repo.totalQuantity
                                                              .toString(),
                                                          style: Them.tableCell,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () => Navigator.of(
                                                              context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            RestaurantProductsPage(
                                                                repo.targetDate!,
                                                                repo.totalSales!),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0),
                                                        child: Text(
                                                          repo.totalSales
                                                              .toString(),
                                                          style: Them.tableCell,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
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

  Future<void> _onScrollEndEvent() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await Provider.of<Restaurant>(context, listen: false)
          .fetcNexthReports(sDate, eDate);
    }
  }
}
