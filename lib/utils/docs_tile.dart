import 'package:flutter/material.dart';
import 'package:madr_driver/utils/const_color.dart';

class DivTile extends StatelessWidget {
  DivTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: ConstColor.accentColor,
      thickness: 0.8,
      endIndent: 10,
      indent: 10,
    );
  }
}
