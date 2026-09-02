import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';


class AvatarSection extends StatelessWidget {
  const AvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/gamer 2.png'),
            ),

            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/gamer (1).png'),

            ),

            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/gamer 3.png'),
            ),
          ],
        ),

        const SizedBox(height: 5),

        const Text(
          'Avatar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}