import 'package:flutter/material.dart';

final TextStyle baseTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
);

final TextStyle fullNameTextStyle =
    baseTextStyle.copyWith(color: Colors.white, fontSize: 20);

final TextStyle titleMediaStyle = baseTextStyle.copyWith(
  color: Colors.white,
  fontSize: 18,
);

final TextStyle descriptionMediaStyle = titleMediaStyle.copyWith(
  color: Colors.grey[400],
  fontSize: 14,
);
