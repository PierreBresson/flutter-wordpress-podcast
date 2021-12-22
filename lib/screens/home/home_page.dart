import 'package:flutter/material.dart';
import 'package:fwp/navigation/page_mixin.dart';
import 'home_screen.dart';

class HomePage extends StatelessWidget with PageMixin {
  @override
  Widget build(BuildContext context) => HomeScreen();

  @override
  Widget get child => HomePage();

  @override
  String get subPath => "/";

  @override
  String get path => "/";
}
