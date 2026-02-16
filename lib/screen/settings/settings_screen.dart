import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/provider/settings_provider.dart';

// Screen untuk pengaturan aplikasi seperti theme dan reminder
// Menggunakan permission handler untuk cek izin notifikasi dan alarm
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

// Observer lifecycle dipakai untuk cek izin saat kembali dari settings
class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // daftarkan observer untuk memantau lifecycle app
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // hapus observer saat widget dihancurkan supaya aman
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final provider = context.read<SettingsProvider>();
    // cek izin lagi saat user balik dari settings
    if (state == AppLifecycleState.resumed && provider.waitingAlarmPermission) {
      _checkAlarmPermission();
    }
  }

  // fungsi untuk cek apakah izin notifikasi dan alarm sudah diberikan
  Future<void> _checkAlarmPermission() async {
    // akses penyedia pengaturan aplikasi
    final settingsProvider = context.read<SettingsProvider>();
    // verifikasi status perizinan notifikasi sistem
    final notifGranted = await Permission.notification.isGranted;
    // verifikasi status perizinan alarm presisi
    final alarmGranted = await Permission.scheduleExactAlarm.isGranted;

    // aktifkan reminder jika semua izin sudah ada
    if (notifGranted && alarmGranted) {
      await settingsProvider.toggleReminder(true);
    }
    settingsProvider.setWaitingAlarmPermission(false);
  }

  // dialog untuk meminta user memberikan izin exact alarm
  Future<void> _showExactAlarmDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Izin Alarm & Reminder"),
        content: const Text(
          "Aplikasi membutuhkan izin Exact Alarm agar notifikasi bisa muncul tepat jam 11.",
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),

            // tutup dialog jika batal
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Go to Settings"),
            onPressed: () async {
              // tutup dialog sebelum request izin
              Navigator.pop(context);

              // tandai bahwa sedang menunggu izin alarm
              context.read<SettingsProvider>().setWaitingAlarmPermission(true);

              // request izin exact alarm ke sistem
              await Permission.scheduleExactAlarm.request();
            },
          ),
        ],
      ),
    );
  }

  // fungsi saat user mengaktifkan reminder
  Future<void> _handleToggleOn() async {
    final settingsProvider = context.read<SettingsProvider>();

    // request izin notifikasi terlebih dahulu
    final notifStatus = await Permission.notification.request();

    // jika ditolak, langsung hentikan proses
    if (!notifStatus.isGranted) return;

    final alarmGranted = await Permission.scheduleExactAlarm.isGranted;

    // jika izin alarm belum ada, tampilkan dialog
    if (!alarmGranted) {
      await _showExactAlarmDialog();
      return;
    }

    // aktifkan reminder jika semua izin tersedia
    await settingsProvider.toggleReminder(true);
  }

  @override
  Widget build(BuildContext context) {
    // ambil state theme dari provider
    final themeProvider = context.watch<ThemeProvider>();

    // ambil state reminder dari provider
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          // switch untuk mengaktifkan atau menonaktifkan dark mode
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Aktifkan tema gelap'),
            value: themeProvider.isDarkMode,

            // toggle theme melalui provider
            onChanged: (value) => themeProvider.toggleTheme(value),

            secondary: const Icon(Icons.dark_mode),
          ),

          const Divider(),

          // switch untuk mengaktifkan atau menonaktifkan reminder
          SwitchListTile(
            title: const Text('Daily Lunch Reminder'),
            subtitle: const Text(
              'Notifikasi rekomendasi restoran setiap jam 11.00',
            ),
            value: settingsProvider.isActive,

            onChanged: (value) async {
              // jika switch ON, jalankan proses cek izin
              if (value) {
                await _handleToggleOn();
              } else {
                // jika OFF, langsung nonaktifkan reminder
                await settingsProvider.toggleReminder(false);
              }
            },
            secondary: const Icon(Icons.notifications_active),
          ),
        ],
      ),
    );
  }
}
