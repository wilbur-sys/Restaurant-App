// enum untuk menyimpan semua nama route yang dipakai di aplikasi
// supaya navigasi lebih aman dan tidak typo string manual
enum NavigationRoute {
  // route utama saat pertama kali aplikasi dibuka
  mainRoute("/"),

  // route untuk menuju halaman detail restoran
  detailRoute("/detail"),

  // route untuk menuju halaman pengaturan aplikasi
  settingsRoute("/settings");

  // constructor untuk menyimpan nilai path route
  const NavigationRoute(this.name);

  // variabel untuk menyimpan string path route
  final String name;
}
