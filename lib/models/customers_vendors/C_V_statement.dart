class Statement {
  final int? dataID;
  final int? number;
  final String? operationType;
  final DateTime? operationDate;
  final double? credit;
  final double? debt;
  final int? memeberID;

  Statement(
      {this.dataID,
      this.number,
      this.operationType,
      this.operationDate,
      this.credit,
      this.debt,
      this.memeberID});
}
