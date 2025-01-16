import 'package:byaparlekha/database/myDatabase/database.dart';

class TransactionSummary {
  final Transaction transaction;
  final bool isIncome;
  final CategoryData category;
  TransactionSummary({
    required this.transaction,
    required this.isIncome,
    required this.category,
  });

  TransactionSummary copyWith({
    Transaction? transaction,
    bool? isIncome,
    CategoryData? category,
  }) {
    return TransactionSummary(
      transaction: transaction ?? this.transaction,
      isIncome: isIncome ?? this.isIncome,
      category: category ?? this.category,
    );
  }

  @override
  String toString() => 'TransactionSummary(transaction: $transaction, isIncome: $isIncome, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionSummary && other.transaction == transaction && other.isIncome == isIncome && other.category == category;
  }

  @override
  int get hashCode => transaction.hashCode ^ isIncome.hashCode ^ category.hashCode;

  factory TransactionSummary.fromDatabase(Map<String, dynamic> map) {
    return TransactionSummary(
      isIncome: map['is_income'] == 1,
      transaction: Transaction(
        image: map['image'],
        id: map['id'],
        categoryId: map['category_id'],
        description: map['description'],
        amount: map['amount'],
        accountId: map['account_id'],
        isDailySales: map['is_daily_sales'] == 1,
        billNumber: map['bill_number'],
        transactionDate: DateTime.fromMillisecondsSinceEpoch(map['transaction_date'] * 1000),
        createdDate: DateTime.fromMillisecondsSinceEpoch(map['created_date'] * 1000),
        modifiedDate: map['modified_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['modified_date'] * 1000),
      ),
      category: CategoryData(
        isSystem: map['is_system'] == 1,
        createdDate: DateTime.fromMillisecondsSinceEpoch(map['created_date'] * 1000),
        categoryHeadingId: map['category_heading_id'],
        id: map['id'],
        orderId: map['category_order_id'],
        name: map['name'],
        nepaliName: map['nepali_name'],
        iconName: map['category_icon_name'],
      ),
    );
  }
}
