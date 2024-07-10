import 'package:flutter/material.dart';

import '../resources/strings.dart';

class ORView extends StatelessWidget {
  const ORView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LBL_OR,
        ),
      ],
    );
  }
}
