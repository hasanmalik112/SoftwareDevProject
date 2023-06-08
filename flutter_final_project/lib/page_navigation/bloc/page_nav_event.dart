part of 'page_nav_bloc.dart';

abstract class PageNavEvent extends Equatable {
  const PageNavEvent();

  @override
  List<Object> get props => [];
}

class PageEventInitialize extends PageNavEvent {
  const PageEventInitialize();
}

class PressedItemViewEvent extends PageNavEvent {}

class SplashViewEvent extends PageNavEvent {}

class PressedTransactionViewEvent extends PageNavEvent {}

class PressedOrderViewEvent extends PageNavEvent {}

class PressedAddProdEvent extends PageNavEvent {}

class PressedAddTransactionEvent extends PageNavEvent {}

class PressedBackButtonEvent extends PageNavEvent {}

class PressedMakeTransactionViewEvent extends PageNavEvent {}
