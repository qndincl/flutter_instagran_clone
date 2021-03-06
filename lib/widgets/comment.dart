import 'package:flutter/material.dart';
import 'package:flutter_instagram_codingpapa/constants/common_size.dart';
import 'package:flutter_instagram_codingpapa/widgets/rounded_avatar.dart';

class Comment extends StatelessWidget {
  final bool showImage;
  final String username;
  final String text;
  final DateTime dateTime;

  const Comment({
    Key key,
    this.showImage = true,
    @required this.username,
    @required this.text,
    this.dateTime,
  }) : super(key: key);

//! if문. if문을 사용할 수는 있으나 {} 를 사용할 수 없고 한구절씩만 가능하다.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (showImage) RoundedAvatar(size: 22),
        if (showImage)
          SizedBox(
            width: common_xxs_gap,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87)),
                  TextSpan(text: "  "),
                  TextSpan(
                    text: text,
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            if (dateTime != null)
              Text(
                dateTime.toIso8601String(),
                style: TextStyle(color: Colors.grey[400], fontSize: 10),
              ),
          ],
        ),
      ],
    );
  }
}
