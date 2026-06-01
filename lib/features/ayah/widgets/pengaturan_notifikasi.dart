import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/theme/warna_utama.dart';
import '../../../services/notification_service.dart';
import '../../../services/session.dart';
import '../../../utils/api.dart';

class PengaturanNotifikasi extends StatefulWidget {
  const PengaturanNotifikasi({super.key});

  @override
  State<PengaturanNotifikasi> createState() => _PengaturanNotifikasiState();
}

class _PengaturanNotifikasiState extends State<PengaturanNotifikasi> {
  bool _hanyaBerisiko = false;
  bool _semuaPerubahan = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final allChanges =
        prefs.getBool(NotificationService.fatherAllChangesKey) ?? true;
    final riskOnly =
        prefs.getBool(NotificationService.fatherRiskOnlyKey) ?? false;

    if (!mounted) return;
    setState(() {
      _semuaPerubahan = allChanges;
      _hanyaBerisiko = allChanges ? true : riskOnly;
    });

    await _syncSettings();
  }

  Future<void> _setAllChanges(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.fatherAllChangesKey, value);

    if (value) {
      await prefs.setBool(NotificationService.fatherRiskOnlyKey, true);
    }

    setState(() {
      _semuaPerubahan = value;
      if (value) _hanyaBerisiko = true;
    });

    await _syncSettings();
  }

  Future<void> _setRiskOnly(bool value) async {
    if (_semuaPerubahan) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.fatherRiskOnlyKey, value);

    setState(() => _hanyaBerisiko = value);
    await _syncSettings();
  }

  Future<void> _syncSettings() async {
    final token = await Session.getToken();
    if (token == null || token.isEmpty) return;

    try {
      await http.put(
        Uri.parse('${Api.baseUrl}/notifications/father-settings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'risk_only': _semuaPerubahan ? true : _hanyaBerisiko,
          'all_changes': _semuaPerubahan,
        }),
      );
    } catch (_) {}
  }

  Widget _itemNotifikasi({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: WarnaUtama.text2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: WarnaUtama.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: WarnaUtama.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: WarnaUtama.text1,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: WarnaUtama.text1.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: WarnaUtama.secondary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengaturan Notifikasi',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: WarnaUtama.text1,
          ),
        ),
        const SizedBox(height: 12),
        _itemNotifikasi(
          icon: Icons.notifications_outlined,
          title: 'Hanya Berisiko Depresi',
          subtitle: 'Notifikasi saat kondisi kritis',
          value: _semuaPerubahan ? true : _hanyaBerisiko,
          onChanged: _semuaPerubahan ? null : _setRiskOnly,
        ),
        const SizedBox(height: 10),
        _itemNotifikasi(
          icon: Icons.update,
          title: 'Semua Perubahan',
          subtitle: 'Laporan harian perkembangan',
          value: _semuaPerubahan,
          onChanged: _setAllChanges,
        ),
      ],
    );
  }
}
