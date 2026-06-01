import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/notifikasi_section.dart';
import '../../../services/notif_storage.dart';

class NotifikasiIbuPage extends StatefulWidget {
  const NotifikasiIbuPage({super.key});

  @override
  State<NotifikasiIbuPage> createState() => _NotifikasiIbuPageState();
}

class _NotifikasiIbuPageState extends State<NotifikasiIbuPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadNotif();
  }

  Future<void> loadNotif() async {
    final result = await NotifStorage.getAll();

    setState(() {
      data = result.reversed.toList(); // terbaru di atas
    });
  }

  Map<String, List<Map<String, dynamic>>> groupData() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    for (var item in data) {
      final date = DateTime.parse(item['time']).toLocal();

      String key;

      // 🔥 HARI INI
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        key = "HARI INI";

        // 🔥 KEMARIN (FIXED - tidak pakai day-1 lagi)
      } else if (date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day) {
        key = "KEMARIN";

        // 🔥 selain itu
      } else {
        key = "${date.day}-${date.month}-${date.year}";
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupData();

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
                      ...grouped.entries.map((entry) {
                        return NotifikasiSection(
                          label: entry.key,
                          isNew: entry.key == "HARI INI",
                          items: entry.value.map((e) {
                            return {
                              'judul': e['title'],
                              'deskripsi': e['body'],
                              'tipe': 'skrining',
                              'berisiko': false,
                            };
                          }).toList(),
                        );
                      }),

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
