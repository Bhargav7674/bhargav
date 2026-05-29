part of 'money_intro_bloc.dart';

enum MoneyIntroPhase {
  initial,
  walletEntry,
  confettiBurst,
  walletMovingUp,
  textRevealed,
  cardsAppearing,
  fullyLoaded,
}

class MoneyIntroState {
  final MoneyIntroPhase phase;
  final bool isAddMoneyLoading;

  const MoneyIntroState({
    this.phase = MoneyIntroPhase.initial,
    this.isAddMoneyLoading = false,
  });

  MoneyIntroState copyWith({
    MoneyIntroPhase? phase,
    bool? isAddMoneyLoading,
  }) {
    return MoneyIntroState(
      phase: phase ?? this.phase,
      isAddMoneyLoading: isAddMoneyLoading ?? this.isAddMoneyLoading,
    );
  }
}
