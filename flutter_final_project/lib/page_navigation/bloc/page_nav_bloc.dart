import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'page_nav_event.dart';
part 'page_nav_state.dart';

class PageNavBloc extends Bloc<PageNavEvent, PageNavState> {
  PageNavBloc() : super(PageNavInitial()) {
    on<SplashViewEvent>((event, emit) async {
      emit(PageNavInitial());
    });

    on<PressedItemViewEvent>((event, emit) async {
      emit(PressedItemViewState());
      emit(PageNavInitial());
    });

    on<PressedTransactionViewEvent>((event, emit) {
      emit(PressedTransactionViewState());
      emit(PageNavInitial());
    });

    on<PressedOrderViewEvent>((event, emit) {
      emit(PressedOrderViewState());
      emit(PageNavInitial());
    });

    on<PressedAddProdEvent>((event, emit) {
      emit(PressedAddProductViewState());
      emit(PageNavInitial());
    });

    on<PressedMakeTransactionViewEvent>((event, emit) {
      emit(PressedAddProductViewState());

      emit(PageNavInitial());
    });

    on<PressedAddTransactionEvent>((event, emit) {
      emit(PressedAddTransactionViewState());
      emit(PageNavInitial());
    });

    on<PressedBackButtonEvent>((event, emit) {
      emit(PressedBackButtonState());
      emit(PageNavInitial());
    });
  }
}


/*

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerInitial()) {
    on<pressedItemViewEvent>((event, emit) async {
      emit(pressedItemViewState());
    });

    on<pressedTransactionViewEvent>((event, emit) {
      emit(pressedTransactionViewState());
    });

    on<pressedOrderViewEvent>((event, emit) {
      emit(pressedOrderViewState());
    });
  }
*/