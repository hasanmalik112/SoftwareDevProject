part of 'page_nav_bloc.dart';

@Immutable()
abstract class PageNavState extends Equatable {
  const PageNavState();

  @override
  List<Object?> get props => [];
}

class PageNavInitial extends PageNavState {
  @override
  List<Object?> get props => [];
}

// part of 'drawer_bloc.dart';
class MainPageViewState extends PageNavState {
  @override
  List<Object?> get props => [];
}

class PressedItemViewState extends PageNavState {
  @override
  List<Object?> get props => [];
}

class PressedTransactionViewState extends PageNavState {
  @override
  List<Object?> get props => [];
}

class PressedOrderViewState extends PageNavState {
  @override
  List<Object?> get props => [];
}

class PressedAddProductViewState extends PageNavState {
  @override
  List<Object?> get props => [];
}

class PressedAddTransactionViewState extends PageNavState {
  @override
  List<Object?> get props => [];
}

class PressedMakeTransactionViewState extends PageNavState {
  @override
  List<Object?> get props => [];
}

class PressedBackButtonState extends PageNavState {
  @override
  List<Object?> get props => [];
}
