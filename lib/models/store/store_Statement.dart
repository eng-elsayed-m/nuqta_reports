class StoreStatement {
  final int? productID;
  final String? productName;
  final double? quantity;
  final double? salePrice;
  final double? cost;
  final double? value;
  final String? unitName;

  StoreStatement(
      {this.productID,
      this.productName,
      this.quantity,
      this.salePrice,
      this.cost,
      this.value,
      this.unitName});
}
