import 'package:flutter/material.dart';
import 'package:fwp/navigation/page_mixin.dart';
import './about_screen.dart';

class AboutPage extends StatelessWidget with PageMixin {
  @override
  Widget build(BuildContext context) => const AboutScreen();

  @override
  Widget get child => AboutPage();

  @override
  String get subPath => "about";

  @override
  String get path => "/about";
}
