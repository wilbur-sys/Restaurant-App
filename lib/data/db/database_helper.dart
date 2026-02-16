import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/restaurant_list.dart';

// class helper untuk handle semua operasi database favorite
class DatabaseHelper {
  // instance singleton supaya database cuma dibuat sekali
  static DatabaseHelper? _instance;
  static Database? _database;

  // constructor internal untuk singleton
  DatabaseHelper._internal() {
    _instance = this;
  }

  // factory constructor untuk akses instance yang sama
  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  // getter untuk akses database, init kalau belum ada
  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  // fungsi untuk inisialisasi database
  Future<Database> _initDb() async {
    // set lokasi dan nama file database
    final path = join(await getDatabasesPath(), 'favorite_restaurant.db');

    // buka atau buat database baru
    return openDatabase(
      path,
      version: 2,

      // dijalankan pertama kali saat database dibuat
      onCreate: (db, version) async {
        // buat tabel favorite untuk simpan restaurant favorit
        await db.execute('''
      CREATE TABLE favorite (
        id TEXT PRIMARY KEY,
        name TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
    ''');
      },

      // dijalankan saat upgrade versi database
      onUpgrade: (db, oldVersion, newVersion) async {
        // buat tabel kalau belum ada di versi sebelumnya
        if (oldVersion < 2) {
          await db.execute('''
        CREATE TABLE IF NOT EXISTS favorite (
          id TEXT PRIMARY KEY,
          name TEXT,
          pictureId TEXT,
          city TEXT,
          rating REAL
        )
      ''');
        }
      },
    );
  }

  // insert restaurant ke tabel favorite
  Future<void> insertFavorite(Restaurant restaurant) async {
    // ambil instance database
    final db = await database;

    // simpan data restaurant ke tabel favorite
    await db.insert(
      'favorite',
      {
        'id': restaurant.id,
        'name': restaurant.name,
        'pictureId': restaurant.pictureId,
        'city': restaurant.city,
        'rating': restaurant.rating,
      },

      // replace kalau data sudah ada
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // hapus restaurant dari favorite berdasarkan id
  Future<void> removeFavorite(String id) async {
    // ambil instance database
    final db = await database;

    // delete data berdasarkan id
    await db.delete('favorite', where: 'id = ?', whereArgs: [id]);
  }

  // ambil semua data restaurant favorite
  Future<List<Restaurant>> getFavorites() async {
    // ambil instance database
    final db = await database;

    // query semua data dari tabel favorite
    final result = await db.query('favorite');

    // convert hasil query ke List<Restaurant>
    return result
        .map(
          (e) => Restaurant(
            id: e['id'] as String,
            name: e['name'] as String,
            pictureId: e['pictureId'] as String,
            city: e['city'] as String,
            rating: (e['rating'] as num).toDouble(),
            description: '', // kosong karena tidak disimpan di db
          ),
        )
        .toList();
  }

  // cek apakah restaurant sudah difavorite
  Future<bool> isFavorite(String id) async {
    // ambil instance database
    final db = await database;

    // query berdasarkan id
    final result = await db.query('favorite', where: 'id = ?', whereArgs: [id]);

    // return true kalau data ditemukan
    return result.isNotEmpty;
  }
}
