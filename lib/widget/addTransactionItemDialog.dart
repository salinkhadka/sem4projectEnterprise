class AddTransactionItemDialog extends StatefulWidget {
  final Function(TransactionItemData) onItemAdd;
  const AddTransactionItemDialog({super.key, required this.onItemAdd});
  @override
  _AddTransactionItemDialogState createState() => _AddTransactionItemDialogState();
}