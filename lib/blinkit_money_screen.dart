import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'confetti_painter.dart';
import 'marquee_text.dart';
import 'wallet_icon_painter.dart';

class BlinkitMoneyScreen extends StatefulWidget {
  const BlinkitMoneyScreen({super.key});

  @override
  State<BlinkitMoneyScreen> createState() => _BlinkitMoneyScreenState();
}

class _BlinkitMoneyScreenState extends State<BlinkitMoneyScreen>
    with TickerProviderStateMixin {

  // Phase 1: wallet entry — scale + slide up from below center
  late AnimationController _walletEntryCtrl;
  late Animation<double> _walletScaleAnim;
  late Animation<double> _walletSlideAnim;

  // Phase 2: confetti burst
  late AnimationController _confettiCtrl;

  // Wobble while confetti plays
  late AnimationController _wobbleCtrl;
  late Animation<double> _wobbleAnim;

  // Phase 3: wallet moves up + text fades in simultaneously
  late AnimationController _transitionCtrl;
  late Animation<double> _walletTopAnim;
  late Animation<double> _textFadeAnim;
  late Animation<double> _textScaleAnim;
  late Animation<Offset> _textSlideAnim;

  // Phase 4: cards stagger in
  late AnimationController _cardsCtrl;
  late List<Animation<double>> _cardFadeAnims;
  late List<Animation<Offset>> _cardSlideAnims;

  // Phase 5: settings icon
  late AnimationController _settingsCtrl;
  late Animation<double> _settingsFadeAnim;

  // Phase 6: button + gift card
  late AnimationController _buttonCtrl;
  late Animation<double> _buttonFadeAnim;
  late Animation<Offset> _buttonSlideAnim;
  late Animation<double> _giftFadeAnim;
  late Animation<Offset> _giftSlideAnim;

  // Phase 7: marquee
  late AnimationController _marqueeCtrl;
  late Animation<double> _marqueeFadeAnim;

  final List<ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _generateParticles();
    _setupControllers();
    _runSequence();
  }

  void _generateParticles() {
    final rng = math.Random(7);
    final colors = [
      const Color(0xFFE53935),
      const Color(0xFF1E88E5),
      const Color(0xFF43A047),
      const Color(0xFFFFD600),
      const Color(0xFFE91E63),
      const Color(0xFF00ACC1),
      const Color(0xFF7B1FA2),
      const Color(0xFFFF6D00),
    ];
    for (int i = 0; i < 80; i++) {
      _particles.add(ConfettiParticle(
        x: rng.nextDouble(),
        y: -0.02 - rng.nextDouble() * 0.30,
        vx: (rng.nextDouble() - 0.5) * 0.010,
        vy: 0.005 + rng.nextDouble() * 0.008,
        color: colors[rng.nextInt(colors.length)],
        rotation: rng.nextDouble() * math.pi * 2,
        rotationSpeed: (rng.nextDouble() - 0.5) * 0.20,
        size: 7 + rng.nextDouble() * 9,
        isRect: rng.nextBool(),
      ));
    }
  }

  void _setupControllers() {
    // ── Wallet entry ──
    _walletEntryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _walletScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _walletEntryCtrl, curve: Curves.elasticOut));
    _walletSlideAnim = Tween<double>(begin: 60.0, end: 0.0).animate(
        CurvedAnimation(parent: _walletEntryCtrl, curve: Curves.easeOutCubic));

    // ── Confetti ──
    _confettiCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));

    // ── Wobble ──
    _wobbleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 850));
    _wobbleAnim = Tween<double>(begin: -0.07, end: 0.07).animate(
        CurvedAnimation(parent: _wobbleCtrl, curve: Curves.easeInOut));

    // ── Transition: wallet moves to top + text appears ──
    _transitionCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _walletTopAnim = CurvedAnimation(
        parent: _transitionCtrl, curve: Curves.easeInOutCubic);
    _textFadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _transitionCtrl,
            curve: const Interval(0.25, 1.0, curve: Curves.easeOut)));
    _textScaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
            parent: _transitionCtrl,
            curve: const Interval(0.25, 0.9, curve: Curves.easeOutBack)));
    _textSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _transitionCtrl,
                curve: const Interval(0.25, 0.85, curve: Curves.easeOut)));

    // ── Cards ──
    _cardsCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    _cardFadeAnims = [];
    _cardSlideAnims = [];
    for (int i = 0; i < 3; i++) {
      final start = i * 0.20;
      final end = (start + 0.55).clamp(0.0, 1.0);
      _cardFadeAnims.add(Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: _cardsCtrl,
              curve: Interval(start, end, curve: Curves.easeOut))));
      _cardSlideAnims.add(
          Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
              CurvedAnimation(
                  parent: _cardsCtrl,
                  curve: Interval(start, end, curve: Curves.easeOutCubic))));
    }

    // ── Settings icon ──
    _settingsCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _settingsFadeAnim =
        CurvedAnimation(parent: _settingsCtrl, curve: Curves.easeIn);

    // ── Button + gift card ──
    _buttonCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    _buttonFadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _buttonCtrl,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));
    _buttonSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.45), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _buttonCtrl,
                curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic)));
    _giftFadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _buttonCtrl,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut)));
    _giftSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.45), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _buttonCtrl,
                curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)));

    // ── Marquee ──
    _marqueeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _marqueeFadeAnim =
        CurvedAnimation(parent: _marqueeCtrl, curve: Curves.easeIn);
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 180));
    _walletEntryCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 120));
    _confettiCtrl.forward();
    _wobbleCtrl.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 1550));
    _wobbleCtrl.stop();
    _wobbleCtrl.animateTo(0.5, duration: const Duration(milliseconds: 180));
    _transitionCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 580));
    _cardsCtrl.forward();
    _settingsCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 820));
    _buttonCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 420));
    _marqueeCtrl.forward();
  }

  @override
  void dispose() {
    _walletEntryCtrl.dispose();
    _confettiCtrl.dispose();
    _wobbleCtrl.dispose();
    _transitionCtrl.dispose();
    _cardsCtrl.dispose();
    _settingsCtrl.dispose();
    _buttonCtrl.dispose();
    _marqueeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111008),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotBgPainter())),
          AnimatedBuilder(
            animation: _confettiCtrl,
            builder: (_, __) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: ConfettiPainter(
                  particles: _particles, progress: _confettiCtrl.value),
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _walletEntryCtrl,
                _wobbleCtrl,
                _transitionCtrl,
                _cardsCtrl,
                _settingsCtrl,
                _buttonCtrl,
                _marqueeCtrl,
              ]),
              builder: (context, _) => _buildBody(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final safeTop = mq.padding.top;
    final availH = screenH - safeTop;

    // Responsive wallet size
    final double walletSize = screenH < 700 ? 90.0 : 110.0;

    // Wallet fractions — responsive for small screens
    const double centerFrac = 0.42;
    final double topFrac = screenH < 700 ? 0.15 : 0.19;

    final walletFrac =
        centerFrac + (topFrac - centerFrac) * _walletTopAnim.value;
    final walletCenterY = availH * walletFrac;

    // Wobble zeroes out as transition plays
    final wobble =
        _wobbleAnim.value * (1.0 - _walletTopAnim.value.clamp(0.0, 1.0));

    // Responsive MONEY font size
    final double moneyFontSize = screenH < 700 ? 42.0 : 54.0;

    // Responsive card vertical padding
    final double cardVPad = screenH < 700 ? 10.0 : 15.0;

    // Responsive spacing between cards
    final double cardSpacing = screenH < 700 ? 6.0 : 10.0;

    return Stack(
      children: [
        // ── Top bar ──
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleBtn(Icons.arrow_back_ios_new_rounded),
                FadeTransition(
                  opacity: _settingsFadeAnim,
                  child: _circleBtn(Icons.settings_outlined),
                ),
              ],
            ),
          ),
        ),

        // ── Wallet icon ──
        Positioned(
          top: walletCenterY - (walletSize / 2) + _walletSlideAnim.value,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.rotate(
              angle: wobble,
              child: Transform.scale(
                scale: _walletScaleAnim.value,
                child: SizedBox(
                  width: walletSize,
                  height: walletSize,
                  child: const WalletIconWidget(),
                ),
              ),
            ),
          ),
        ),

        // ── "blinkit MONEY" text ──
        Positioned(
          top: walletCenterY + (walletSize / 2) + 6 + _walletSlideAnim.value,
          left: 0,
          right: 0,
          child: FadeTransition(
            opacity: _textFadeAnim,
            child: SlideTransition(
              position: _textSlideAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'blinkit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenH < 700 ? 18.0 : 22.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      letterSpacing: 0.5,
                    ),
                  ),
                  ScaleTransition(
                    scale: _textScaleAnim,
                    child: Text(
                      'MONEY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: moneyFontSize,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Montserrat',
                        letterSpacing: 5,
                        height: 1.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Feature cards + CTA ──
        if (_transitionCtrl.value > 0.55)
          Positioned(
            top: availH * topFrac + (walletSize / 2) + (screenH < 700 ? 80 : 100),
            left: 16,
            right: 16,
            bottom: 48,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  _featureCard(
                    index: 0,
                    iconWidget: _phonePayIcon(),
                    title: 'Single tap payments',
                    subtitle: 'Enjoy seamless payments without the wait for OTPs',
                    verticalPadding: cardVPad,
                  ),
                  SizedBox(height: cardSpacing),
                  _featureCard(
                    index: 1,
                    iconWidget: _wifiPayIcon(),
                    title: 'Zero failures',
                    subtitle: 'Zero payment failures ensure you never miss an order',
                    verticalPadding: cardVPad,
                  ),
                  SizedBox(height: cardSpacing),
                  _featureCard(
                    index: 2,
                    iconWidget: _refundIcon(),
                    title: 'Real-time refunds',
                    subtitle: 'No need to wait for refunds. Blinkit Money refunds are instant!',
                    verticalPadding: cardVPad,
                  ),
                  SizedBox(height: screenH < 700 ? 12.0 : 18.0),

                  // Add Money button
                  FadeTransition(
                    opacity: _buttonFadeAnim,
                    child: SlideTransition(
                      position: _buttonSlideAnim,
                      child: _addMoneyButton(screenH: screenH),
                    ),
                  ),
                  SizedBox(height: screenH < 700 ? 6.0 : 10.0),

                  // Claim Gift Card
                  FadeTransition(
                    opacity: _giftFadeAnim,
                    child: SlideTransition(
                      position: _giftSlideAnim,
                      child: _giftCardRow(),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

        // ── Marquee ──
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: FadeTransition(
            opacity: _marqueeFadeAnim,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: MarqueeText(
                text: 'Enjoy seamless one tap payments     ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.22),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  letterSpacing: 0.5,
                ),
                velocity: 65,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────── Sub-widgets ───────────────

  Widget _featureCard({
    required int index,
    required Widget iconWidget,
    required String title,
    required String subtitle,
    double verticalPadding = 15,
  }) {
    if (index >= _cardFadeAnims.length) return const SizedBox.shrink();
    return FadeTransition(
      opacity: _cardFadeAnims[index],
      child: SlideTransition(
        position: _cardSlideAnims[index],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.07), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF111110),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: iconWidget),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.48),
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _phonePayIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.smartphone, color: Colors.white.withOpacity(0.9), size: 28),
        Positioned(
          bottom: 8,
          right: 8,
          child: Icon(Icons.touch_app, color: Colors.white.withOpacity(0.7), size: 14),
        ),
      ],
    );
  }

  Widget _wifiPayIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.smartphone, color: const Color(0xFFFFCC00).withOpacity(0.9), size: 28),
        Positioned(
          top: 8,
          right: 6,
          child: const Icon(Icons.wifi, color: Color(0xFFFFCC00), size: 14),
        ),
      ],
    );
  }

  Widget _refundIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.smartphone, color: const Color(0xFFFFCC00).withOpacity(0.9), size: 28),
        Positioned(
          top: 8,
          right: 6,
          child: const Icon(Icons.currency_rupee, color: Color(0xFFFFCC00), size: 13),
        ),
      ],
    );
  }

  Widget _addMoneyButton({double screenH = 800}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: screenH < 700 ? 48.0 : 54.0,
        decoration: BoxDecoration(
          color: const Color(0xFF2D7A30),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Add Money',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _giftCardRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF3A2800),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🎁', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Claim Gift Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Enter gift card details to claim your gift card',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.4), size: 22),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

// ── Dot pattern background ──
class _DotBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 18.0;
    const r = 1.5;
    final halfH = size.height * 0.52;
    for (double y = 0; y < halfH; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        final opacity = (1.0 - y / halfH) * 0.36;
        canvas.drawCircle(
          Offset(x, y),
          r,
          Paint()..color = const Color(0xFF9A8500).withOpacity(opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotBgPainter _) => false;
}