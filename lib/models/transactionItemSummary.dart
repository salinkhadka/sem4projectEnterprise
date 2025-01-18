import 'package:byaparlekha/database/myDatabase/database.dart';

class TransactionItemSummary {
  final TransactionItemData transactionItem;
  final int transactionId;
  final bool isIncome;
  final DateTime transactionDateTime;
  final DateTime transactionCreatedDate;
  final PersonData person;
  final CategoryData categoryData;
  final String? billNumber;
  final CategoryHeadingData categoryHeadingData;
  final ItemData item;
  TransactionItemSummary({
    required this.transactionItem,
    required this.transactionId,
    required this.isIncome,
    required this.transactionDateTime,
    required this.transactionCreatedDate,
    required this.person,
    required this.categoryData,
    required this.billNumber,
    required this.categoryHeadingData,
    required this.item,
  });

  TransactionItemSummary copyWith({
    TransactionItemData? transactionItem,
    int? transactionId,
    bool? isIncome,
    DateTime? transactionDateTime,
    DateTime? transactionCreatedDate,
    PersonData? person,
    CategoryData? categoryData,
    String? billNumber,
    CategoryHeadingData? categoryHeadingData,
    ItemData? item,
  }) {
    return TransactionItemSummary(
      transactionItem: transactionItem ?? this.transactionItem,
      transactionId: transactionId ?? this.transactionId,
      isIncome: isIncome ?? this.isIncome,
      transactionDateTime: transactionDateTime ?? this.transactionDateTime,
      transactionCreatedDate: transactionCreatedDate ?? this.transactionCreatedDate,
      person: person ?? this.person,
      categoryData: categoryData ?? this.categoryData,
      billNumber: billNumber ?? this.billNumber,
      categoryHeadingData: categoryHeadingData ?? this.categoryHeadingData,
      item: item ?? this.item,
    );
  }

  @override
  String toString() {
    return 'TransactionItemSummary(transactionItem: $transactionItem, transactionId: $transactionId, isIncome: $isIncome, transactionDateTime: $transactionDateTime, transactionCreatedDate: $transactionCreatedDate, person: $person, categoryData: $categoryData, billNumber: $billNumber, categoryHeadingData: $categoryHeadingData, item: $item)';
  }

  factory TransactionItemSummary.fromDatabase(Map<String, dynamic> map) {
    return TransactionItemSummary(
      transactionId: map['transaction_id'],
      billNumber: map['bill_number'],
      transactionCreatedDate: DateTime.fromMillisecondsSinceEpoch(map['transaction_created_date'] * 1000),
      categoryData: CategoryData(
          id: map['category_id'],
          name: map['category_name'],
          nepaliName: map['nepali_name'] ?? '',
          categoryHeadingId: map['category_heading_id'],
          orderId: 1,
          isSystem: map['category_is_system'] == 1,
          createdDate: DateTime.now()),
      transactionDateTime: DateTime.fromMillisecondsSinceEpoch(map['transaction_date'] * 1000),
      isIncome: map['is_income'] == 1,
      categoryHeadingData: CategoryHeadingData(
          id: map['category_heading_id'],
          name: map['category_heading_name'],
          nepaliName: map['category_heading_nepali_name'],
          isIncome: map['is_income'] == 1,
          isSystem: map['category_heading_is_system'] == 1,
          createdDate: DateTime.now()),
      item: ItemData(id: map['item_id'], name: map['item_name']),
      transactionItem: TransactionItemData(
        id: map['id'],
        transactionId: map['transaction_id'],
        itemId: map['item_id'],
        personId: map['person_id'],
        quantity: map['quantity'] ?? 0.0,
        amount: map['amount'] ?? 0.0,
        createdDate: DateTime.fromMillisecondsSinceEpoch(map['created_date'] * 1000),
      ),
      person: PersonData(
        id: map['person_id'],
        name: map['person_name'],
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionItemSummary &&
        other.transactionItem == transactionItem &&
        other.transactionId == transactionId &&
        other.isIncome == isIncome &&
        other.transactionDateTime == transactionDateTime &&
        other.transactionCreatedDate == transactionCreatedDate &&
        other.person == person &&
        other.categoryData == categoryData &&
        other.billNumber == billNumber &&
        other.categoryHeadingData == categoryHeadingData &&
        other.item == item;
  }

  @override
  int get hashCode {
    return transactionItem.hashCode ^
        transactionId.hashCode ^
        isIncome.hashCode ^
        transactionDateTime.hashCode ^
        transactionCreatedDate.hashCode ^
        person.hashCode ^
        categoryData.hashCode ^
        billNumber.hashCode ^
        categoryHeadingData.hashCode ^
        item.hashCode;
  }
}
