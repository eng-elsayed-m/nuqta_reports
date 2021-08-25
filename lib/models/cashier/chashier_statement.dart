class CashierStatement {
  final int? dataID;
  final int? number;
  final String? operationType;
  final DateTime? operationDate;
  final double? credit;
  final double? debt;
  final String? notes;
  final String? description;

  CashierStatement(
      {this.dataID,
      this.operationDate,
      this.number,
      this.operationType,
      this.credit,
      this.debt,
      this.notes,
      this.description});
}
