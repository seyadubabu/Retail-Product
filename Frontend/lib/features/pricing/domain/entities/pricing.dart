class Pricing {
  final String id;
  final String storeId;
  final String sku;
  final String productName;
  final double price;
  final DateTime date;
  final bool isSynced;

  Pricing({
    required this.id,
    required this.storeId,
    required this.sku,
    required this.productName,
    required this.price,
    required this.date,
    this.isSynced = true,
  });
}