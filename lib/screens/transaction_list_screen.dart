// lib/screens/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/my_transaction.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายรับ-รายจ่าย')),
      body: Consumer<TransactionProvider>(
        builder: (context, txProvider, child) {
          if (txProvider.transactions.isEmpty) {
            return const Center(child: Text('ไม่มีรายการ'));
          }
          return ListView.builder(
            itemCount: txProvider.transactions.length,
            itemBuilder: (ctx, i) {
              final tx = txProvider.transactions[i];
              final isIncome = tx.type == TransactionType.income;
              return ListTile(
                leading: CircleAvatar(child: Text(isIncome ? 'รับ' : 'จ่าย')),
                title: Text(tx.title),
                subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${tx.amount.toStringAsFixed(2)} บาท',
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        // เรียกเมธอด delete
                        context.read<TransactionProvider>().deleteTransaction(tx.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TransactionProvider>().addTransaction(
              'ค่าอาหาร',
              120.0,
              DateTime.now(),
              TransactionType.expense,
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
