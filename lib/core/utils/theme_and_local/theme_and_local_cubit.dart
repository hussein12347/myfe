import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'theme_and_local_state.dart';

class ThemeAndLocalCubit extends Cubit<ThemeAndLocalState> {
  ThemeAndLocalCubit() : super(ThemeAndLocalInitial());
}
