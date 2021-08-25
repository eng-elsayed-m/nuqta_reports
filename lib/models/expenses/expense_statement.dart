class ExpenseStatement {
  final int? expenseTypeID;
  final String? expenseTypeName;
  final double? value;
  final DateTime? expenseDate;
  final String? notes;

  ExpenseStatement(
      {this.expenseTypeID,
      this.expenseTypeName,
      this.value,
      this.expenseDate,
      this.notes});
}
