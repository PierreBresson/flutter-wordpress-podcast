import 'package:riverpod/riverpod.dart';

class TabIndex {
  final int index;
  TabIndex({required this.index});
}

class TabIndexNotifier extends StateNotifier<TabIndex> {
  TabIndexNotifier() : super(TabIndex(index: 2));

  void updateTabIndex(int index) {
    state = TabIndex(index: index);
  }
}

final tabIndexProvider =
    StateNotifierProvider<TabIndexNotifier, TabIndex>((ref) {
  return TabIndexNotifier();
});
