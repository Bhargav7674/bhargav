# Bhargav — Blinkit Money Screen

Flutter implementation of the Blinkit Money intro screen as part of a UI/UX & Animations assignment.

---

## 📱 Demo

> Add your screen recording GIF here

---

## How It Works

The screen runs a 7-phase animation sequence on load:

1. **Wallet entry** — wallet scales in with an elastic bounce from below center
2. **Confetti burst** — particles explode from top while wallet wobbles side to side
3. **Wallet moves up** — wobble stops, wallet slides to the upper section of the screen
4. **Text reveal** — "blinkit MONEY" fades and scales in just below the wallet
5. **Cards stagger** — 3 feature cards slide up one by one with a delay between each
6. **CTA appears** — "Add Money" button and Gift Card row slide up from the bottom
7. **Marquee** — scrolling text fades in at the very bottom

All animations are driven by `AnimationController` chains. No third-party animation packages — every painter, particle, and transition is written from scratch.

State is managed using a custom BLoC pattern built on `ChangeNotifier` (no `flutter_bloc` package, as per assignment constraints).

---

## Folder Structure

```
lib/
├── main.dart                  # Entry point
├── blinkit_money_screen.dart  # Main screen, all animation controllers
├── money_intro_bloc.dart      # BLoC logic (events → state transitions)
├── money_intro_event.dart     # Events: Started, AddMoneyTapped, ClaimGiftCard
├── money_intro_state.dart     # State + MoneyIntroPhase enum
├── confetti_painter.dart      # Custom particle system using CustomPainter
├── wallet_icon_painter.dart   # Wallet icon drawn with Canvas
└── marquee_text.dart          # Infinite scrolling marquee, pure Flutter
```