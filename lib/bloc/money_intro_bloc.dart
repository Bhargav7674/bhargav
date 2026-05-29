import 'package:flutter/foundation.dart';

part 'money_intro_event.dart';
part 'money_intro_state.dart';

/// Minimal BLoC implementation without external package dependency.
/// Uses ChangeNotifier for reactivity so we don't need bloc package.
/// 
/// NOTE: In production, use flutter_bloc package. This demonstrates
/// BLoC pattern principles (events → state) without third-party deps,
/// as required by the assignment constraints.
class MoneyIntroBloc extends ChangeNotifier {
  MoneyIntroState _state = const MoneyIntroState();

  MoneyIntroState get state => _state;

  void add(MoneyIntroEvent event) {
    if (event is MoneyIntroStarted) {
      _onStarted();
    } else if (event is AddMoneyTapped) {
      _onAddMoneyTapped();
    } else if (event is ClaimGiftCardTapped) {
      _onClaimGiftCard();
    }
  }

  Future<void> _onStarted() async {
    _emit(_state.copyWith(phase: MoneyIntroPhase.walletEntry));
    await Future.delayed(const Duration(milliseconds: 300));
    _emit(_state.copyWith(phase: MoneyIntroPhase.confettiBurst));
    await Future.delayed(const Duration(milliseconds: 1500));
    _emit(_state.copyWith(phase: MoneyIntroPhase.walletMovingUp));
    await Future.delayed(const Duration(milliseconds: 700));
    _emit(_state.copyWith(phase: MoneyIntroPhase.textRevealed));
    await Future.delayed(const Duration(milliseconds: 500));
    _emit(_state.copyWith(phase: MoneyIntroPhase.cardsAppearing));
    await Future.delayed(const Duration(milliseconds: 900));
    _emit(_state.copyWith(phase: MoneyIntroPhase.fullyLoaded));
  }

  Future<void> _onAddMoneyTapped() async {
    _emit(_state.copyWith(isAddMoneyLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    _emit(_state.copyWith(isAddMoneyLoading: false));
  }

  void _onClaimGiftCard() {
    // Navigate to gift card screen (handled by UI layer)
  }

  void _emit(MoneyIntroState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
