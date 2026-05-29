import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/chatbot_header.dart';
import '../widgets/chatbot_bubble.dart';
import '../widgets/chatbot_input.dart';

class ChatbotPage extends StatefulWidget {
  final String namaBot;
  final String pesanAwal;
  final List<String> quickReplies;
  final String? pesanPertama;

  const ChatbotPage({
    super.key,
    this.namaBot = 'Nurtura AI',
    required this.pesanAwal,
    this.quickReplies = const [],
    this.pesanPertama,
  });

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages = [
      {
        'pesan': widget.pesanAwal,
        'isBot': true,
        'waktu': _formatWaktu(DateTime.now()),
      },
    ];

    if (widget.pesanPertama != null && widget.pesanPertama!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _kirimPesan(widget.pesanPertama!);
      });
    }
  }

  String _formatWaktu(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m ${time.hour < 12 ? 'AM' : 'PM'}';
  }

  String _formatTanggal(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day) return 'HARI INI';
    if (date.day == now.day - 1) return 'KEMARIN';
    return '${date.day} ${_bulan(date.month)} ${date.year}';
  }

  String _bulan(int bulan) {
    const list = [
      'JAN', 'FEB', 'MAR', 'APR', 'MEI', 'JUN',
      'JUL', 'AGU', 'SEP', 'OKT', 'NOV', 'DES'
    ];
    return list[bulan - 1];
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _kirimPesan(String teks) async {
    if (teks.trim().isEmpty) return;
    _inputController.clear();

    setState(() {
      _messages.add({
        'pesan': teks,
        'isBot': false,
        'waktu': _formatWaktu(DateTime.now()),
      });
      _isLoading = true;
    });

    _scrollToBottom();

    // TODO: ganti dengan API call ke service
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _messages.add({
          'pesan': 'Terima kasih sudah berbagi. Aku di sini untuk mendukungmu. 💚',
          'isBot': true,
          'waktu': _formatWaktu(DateTime.now()),
        });
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            ChatbotHeader(
              namaBot: widget.namaBot,
              onTutup: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                itemCount: _messages.length + (_isLoading ? 1 : 0) + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: WarnaUtama.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _formatTanggal(DateTime.now()),
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: WarnaUtama.text1.withOpacity(0.5),
                          ),
                        ),
                      ),
                    );
                  }

                  if (_isLoading && index == _messages.length + 1) {
                    return const ChatbotBubble(
                      pesan: '',
                      waktu: '',
                      isBot: true,
                      isLoading: true,
                    );
                  }

                  final msg = _messages[index - 1];
                  return ChatbotBubble(
                    pesan: msg['pesan'] as String,
                    waktu: msg['waktu'] as String,
                    isBot: msg['isBot'] as bool,
                  );
                },
              ),
            ),
            ChatbotInput(
              controller: _inputController,
              quickReplies: widget.quickReplies,
              onKirim: () => _kirimPesan(_inputController.text),
              onQuickReply: (teks) => _kirimPesan(teks),
            ),
          ],
        ),
      ),
    );
  }
}