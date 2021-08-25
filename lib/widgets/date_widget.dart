import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UiWidgets {
  //Date Widget ************************
  static Widget datePicker(BuildContext ctx, Function onChange) => TextButton(
      onPressed: () {
        Widget _datePicker = Dialog(
            child: Container(
                constraints: BoxConstraints(
                    minHeight: 200,
                    minWidth: 100,
                    maxHeight: 400,
                    maxWidth: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // image: DecorationImage(
                  //   image: AssetImage("assets/images/logo-s.png"),
                  // )
                ),
                child: SfDateRangePicker(
                  showActionButtons: true,
                  selectionMode: DateRangePickerSelectionMode.range,
                  onCancel: () => Navigator.of(ctx).pop(),
                  onSubmit: (obj) {
                    onChange(obj);

                    Navigator.of(ctx).pop();
                  },
                  initialSelectedRange: PickerDateRange(null, null),
                )));
        showDialog(context: ctx, builder: (ctx) => _datePicker);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text("اختر التاريخ"),
      ));

  //((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))
}
