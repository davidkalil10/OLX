import 'package:flutter/material.dart';

class ProgressPersonalizado extends StatelessWidget {

  final String texto;

  ProgressPersonalizado({@required this.texto});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20,),
        Text(this.texto)
      ],
    );
  }
}
