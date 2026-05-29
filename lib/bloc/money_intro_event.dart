part of 'money_intro_bloc.dart';

abstract class MoneyIntroEvent {}

/// Fired when the screen first appears
class MoneyIntroStarted extends MoneyIntroEvent {}

/// Fired when the user taps "Add Money"
class AddMoneyTapped extends MoneyIntroEvent {}

/// Fired when the user taps "Claim Gift Card"
class ClaimGiftCardTapped extends MoneyIntroEvent {}
