import 'package:flutter/material.dart';

class ListCards extends StatelessWidget {
  const ListCards({super.key, required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}