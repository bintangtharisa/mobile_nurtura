import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class ChatbotBubble extends StatelessWidget {
  final String pesan;
  final String waktu;
  final bool isBot;
  final bool isLoading;

  const ChatbotBubble({
    super.key,
    required this.pesan,
    required this.waktu,
    required this.isBot,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          if (isBot)
            Padding(
              padding: const EdgeInsets.only(left: 44, bottom: 4),
              child: Text(
                'NURTURA AI',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: WarnaUtama.text1.withOpacity(0.4),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          Row(
            mainAxisAlignment:
                isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isBot) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: WarnaUtama.secondary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: WarnaUtama.secondary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isBot
                        ? WarnaUtama.primary.withOpacity(0.2)
                        : WarnaUtama.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isBot ? 4 : 18),
                      bottomRight: Radius.circular(isBot ? 18 : 4),
                    ),
                  ),
                  child: isLoading
                      ? const _LoadingDots()
                      : Text(
                          pesan,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: isBot
                                ? WarnaUtama.text1.withOpacity(0.85)
                                : WarnaUtama.text2,
                            height: 1.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
          if (!isLoading)
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left: isBot ? 44 : 0,
              ),
              child: Text(
                waktu,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  color: WarnaUtama.text1.withOpacity(0.35),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final opacity =
                (value < 0.5 ? value * 2 : (1 - value) * 2).clamp(0.2, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: WarnaUtama.text1.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}