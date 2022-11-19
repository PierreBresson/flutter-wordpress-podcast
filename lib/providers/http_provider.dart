import 'package:fwp/repositories/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final httpProvider = Provider<HttpRepository>((ref) => HttpRepository());
