import 'package:flutter/material.dart';
import 'package:nuqta/services/restaurant.dart';
import 'package:nuqta/theme.dart';
import 'package:provider/provider.dart';

class RestaurantProductsPage extends StatefulWidget {
  static const nv = "/restaurant-products";
  final DateTime date;
  final double total;

  const RestaurantProductsPage(this.date, this.total);
  @override
  _RestaurantProductsPageState createState() => _RestaurantProductsPageState();
}

class _RestaurantProductsPageState extends State<RestaurantProductsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text("تقرير مبيعات", style: Them.pageTitle),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FittedBox(
                  child: Text(
                    "بتاريخ : " +
                        widget.date.toIso8601String().split("T").first,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  fit: BoxFit.contain,
                ),
                Text(
                  "الاجمالى : " + widget.total.toString(),
                  style: TextStyle(
                    color: Colors.cyanAccent.shade700,
                    fontSize: 15,
                  ),
                ),
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
                          2: FlexColumnWidth(0.4),
                          3: FlexColumnWidth(0.4),
                        }, children: [
                          TableRow(
                            children: [
                              Text(
                                "الرقم",
                                style: Them.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "المنتج",
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
                                  .fetchSales(widget.date),
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
                                            0: FlexColumnWidth(0.3),
                                            1: FlexColumnWidth(0.7),
                                            2: FlexColumnWidth(0.4),
                                            3: FlexColumnWidth(0.4),
                                          },
                                          children: Provider.of<Restaurant>(
                                                  context)
                                              .products
                                              .map((prod) =>
                                                  TableRow(children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5.0),
                                                      child: Text(
                                                        prod.dataID.toString(),
                                                        style: Them.tableCell,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5.0),
                                                      child: Text(
                                                        prod.productName
                                                            .toString(),
                                                        style: Them.tableCell,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5.0),
                                                      child: Text(
                                                        prod.totalQuantity
                                                            .toString(),
                                                        style: Them.tableCell,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5.0),
                                                      child: Text(
                                                        prod.totalSales
                                                            .toString(),
                                                        style: Them.tableCell,
                                                        textAlign:
                                                            TextAlign.center,
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

      // Expanded(
      //   child: Material(
      //     elevation: 10,
      //     shadowColor: Colors.blue,
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      //     child: Column(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 5),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             children: [
      //               listText("#", Colors.blueGrey, true),
      //               listText("المنتج", Colors.blueGrey, true),
      //               listText("الكمية", Colors.blueGrey, true),
      //               listText("الاجمالى", Colors.blueGrey, true),
      //             ],
      //           ),
      //         ),
      //         Divider(
      //           color: const Color(0xff06c4f1),
      //           thickness: 2,
      //           height: 0,
      //         ),
      //         Container(
      //           width: double.infinity,
      //           height: _dSize.height * 0.71,
      //           child: FutureBuilder(
      //               future: Provider.of<Restaurant>(context, listen: false)
      //                   .fetchSales(widget.date),
      //               initialData: null,
      //               builder: (BuildContext context, AsyncSnapshot snapshot) =>
      //                   snapshot.connectionState == ConnectionState.waiting
      //                       ? Center(
      //                           child: SizedBox(
      //                           width: 150,
      //                           height: 150,
      //                           child: Stack(
      //                             alignment: AlignmentDirectional.center,
      //                             children: [
      //                               LinearProgressIndicator(
      //                                 minHeight: _dSize.height * 0.3,
      //                                 backgroundColor: Colors.transparent,
      //                               ),
      //                               Image.asset("assets/images/logo-s.png")
      //                             ],
      //                           ),
      //                         ))
      //                       : ListView(
      //                           controller: _scrollController,
      //                           physics: ScrollPhysics(
      //                               parent: BouncingScrollPhysics()),
      //                           children: Provider.of<Restaurant>(context)
      //                               .products
      //                               .map((product) => Row(
      //                                       mainAxisAlignment:
      //                                           MainAxisAlignment.spaceAround,
      //                                       children: [
      //                                         listText(
      //                                           product.dataID.toString(),
      //                                         ),
      //                                         listText(
      //                                           product.productName
      //                                               .toString()
      //                                               .split(" ")
      //                                               .first,
      //                                         ),
      //                                         listText(
      //                                           product.totalQuantity
      //                                               .toString(),
      //                                         ),
      //                                         listText(
      //                                           product.totalSales.toString(),
      //                                         ),
      //                                       ]))
      //                               .toList())),
      //         ),
      //         Divider(
      //           color: const Color(0xff06c4f1),
      //           thickness: 2,
      //           height: 0,
      //         ),
      //         TextButton(
      //             onPressed: () => Navigator.pop(context),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Icon(
      //                   Icons.arrow_back_ios_new,
      //                   color: Colors.redAccent,
      //                   size: 40,
      //                 ),
      //                 Text(
      //                   "Back",
      //                   style: TextStyle(
      //                       fontWeight: FontWeight.bold, fontSize: 20),
      //                 ),
      //               ],
      //             )),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> _onScrollEndEvent() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await Provider.of<Restaurant>(context, listen: false)
          .fetchNextSales(widget.date);
    }
  }
}
