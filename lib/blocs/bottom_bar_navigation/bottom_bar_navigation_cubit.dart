import 'package:bloc/bloc.dart';

class BottomBarNavigationCubit extends Cubit<int> {
  BottomBarNavigationCubit() : super(0);

  void update(int index) => emit(index);
}
