import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class ChatbotInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> quickReplies;
  final VoidCallback onKirim;
  final Function(String) onQuickReply;

  const ChatbotInput({
    super.key,
    required this.controller,
    required this.quickReplies,
    required this.onKirim,
    required this.onQuickReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: WarnaUtama.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Input row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: WarnaUtama.text2,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: WarnaUtama.primary.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Tanyakan sesuatu...',
                      hintStyle: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: WarnaUtama.text1.withOpacity(0.35),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      color: WarnaUtama.text1,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onKirim(),
                  ),
                ),
                GestureDetector(
                  onTap: onKirim,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: WarnaUtama.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: WarnaUtama.secondary.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: WarnaUtama.text2,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: quickReplies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onQuickReply(quickReplies[index]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: WarnaUtama.text2,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: WarnaUtama.primary.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      quickReplies[index],
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        color: WarnaUtama.text1.withOpacity(0.7),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}