import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/notifikasi_section.dart';
import '../../../services/notif_storage.dart';
import '../../../services/session.dart';
import '../../../utils/api.dart';

class NotifikasiAyahPage extends StatefulWidget {
  const NotifikasiAyahPage({super.key});

  @override
  State<NotifikasiAyahPage> createState() => _NotifikasiAyahPageState();
}

class _NotifikasiAyahPageState extends State<NotifikasiAyahPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _loadNotif();
  }

  Future<void> _loadNotif() async {
    final result = await _fetchBackendNotifications();
    if (!mounted) return;
    setState(() => data = result.reversed.toList());
  }

  Future<List<Map<String, dynamic>>> _fetchBackendNotifications() async {
    final token = await Session.getToken();
    if (token == null || token.isEmpty) {
      return NotifStorage.getAllFather();
    }

    try {
      final response = await http.get(
        Uri.parse('${Api.baseUrl}/notifications?limit=50'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return NotifStorage.getAllFather();
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final items = body['data']?['items'] as List? ?? [];

      return items.map<Map<String, dynamic>>((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return {
          'title': map['title'] ?? '',
          'body': map['message'] ?? '',
          'type': map['type'] ?? 'stabil',
          'berisiko': map['type'] == 'peringatan',
          'time': map['created_at'] ?? DateTime.now().toIso8601String(),
        };
      }).toList();
    } catch (_) {
      return NotifStorage.getAllFather();
    }
  }

  Map<String, List<Map<String, dynamic>>> _groupData() {
    final grouped = <String, List<Map<String, dynamic>>>{};
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    for (final item in data) {
      final date = DateTime.tryParse(item['time']?.toString() ?? '')?.toLocal();
      if (date == null) continue;

      final key = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day
          ? 'HARI INI'
          : date.year == yesterday.year &&
                  date.month == yesterday.month &&
                  date.day == yesterday.day
              ? 'KEMARIN'
              : '${date.day}-${date.month}-${date.year}';

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupData();

    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Riwayat Notifikasi',
                leftIcon: Icons.chevron_left,
                onLeftTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text("Belum ada notifikasi"),
                        ),
                      )
                    else
                      ...grouped.entries.map((entry) => NotifikasiSection(
                            label: entry.key,
                            isNew: entry.key == 'HARI INI',
                            items: entry.value.map((e) {
                              return {
                                'judul': e['title'] ?? '',
                                'deskripsi': e['body'] ?? '',
                                'tipe': e['type'] ?? 'stabil',
                                'berisiko': e['berisiko'] ?? false,
                              };
                            }).toList(),
                          )),

                    // Footer
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: WarnaUtama.primary.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.history,
                              color: WarnaUtama.text1.withOpacity(0.3),
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'SEMUA PEMBERITAHUAN TELAH DITAMPILKAN',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: WarnaUtama.text1.withOpacity(0.3),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
