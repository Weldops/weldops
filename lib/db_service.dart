import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'features/arc_service/presentation/data/model/lens.dart';

class DbService {
  static final DbService instance = DbService._init();
  static Database? _database;

  DbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smart_helmet.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
        ALTER TABLE devices ADD COLUMN status TEXT
      ''');
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    print("Creating database and tables...");

    await db.execute('''
  CREATE TABLE devices (
    deviceId TEXT PRIMARY KEY,
    deviceModel TEXT NOT NULL,
    deviceName TEXT NOT NULL,
    displayName TEXT NOT NULL,
    macAddress TEXT,
    imageUrl TEXT,
    createdAt TEXT,
    data TEXT
  )
''');

    await db.execute('''
      CREATE TABLE adf_settings (
        id TEXT PRIMARY KEY,
        deviceId TEXT,
        workingType TEXT,
        configType TEXT,
        deviceName TEXT,
        isSelected INTEGER,
        "values" TEXT,
        FOREIGN KEY (deviceId) REFERENCES devices(id)
      )
    ''');

    // Create lens_records table
    await db.execute('''
        CREATE TABLE lens_records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          imageUrl TEXT NOT NULL,
          percentage INTEGER NOT NULL,
          hours TEXT NOT NULL,
          lastUpdated TEXT NOT NULL,
          comments TEXT
        )
      ''');

    // Create lens_replacement table for replacement logs
    await db.execute('''
      CREATE TABLE lens_replacement (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lens_record_id INTEGER NOT NULL,
        title TEXT,
        imageUrl TEXT,
        percentage INTEGER,
        hours TEXT,
        lastUpdated TEXT,
        comments TEXT,
        FOREIGN KEY (lens_record_id) REFERENCES lens_records(id)
      )
    ''');

    /// Insert initial data for lens
    print("Inserting initial data into lens_records");
    await db.insert('lens_records', {
      'title': 'Outer Lens Cover',
      'imageUrl': 'assets/images/outer_lens.png',
      'percentage': 80,
      'hours': '80',
      'lastUpdated': DateTime.now().toIso8601String(),
    });

    await db.insert('lens_records', {
      'title': 'Inner Lens Cover',
      'imageUrl': 'assets/images/inner_lens.png',
      'percentage': 10,
      'hours': '10',
      'lastUpdated': DateTime.now().toIso8601String(),
    });
  }

// CRUD Operations
  Future<int> insertRecord(LensRecord record) async {
    final db = await instance.database;
    return await db.insert('lens_records', record.toMap());
  }

  Future<List<LensRecord>> getAllLogs() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('lens_records');
    return List.generate(maps.length, (i) => LensRecord.fromMap(maps[i]));
  }


  Future<int> updateRecord(LensRecord record) async {
    final db = await instance.database;
    return await db.update(
      'lens_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<List<LensRecord>> fetchRecordsById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'lens_replacement',
      where: 'lens_record_id = ?',
      whereArgs: [id],
      orderBy: 'lastUpdated DESC',
    );
    return result.map((map) => LensRecord.fromMap(map)).toList();
  }

  Future<int> addLog(LensRecord record) async {
    final db = await instance.database;
    final logEntry = {
      'lens_record_id': record.id,
      'title': record.title,
      'imageUrl': record.imageUrl,
      'percentage': record.percentage,
      'hours': record.hours,
      'lastUpdated': record.lastUpdated.toIso8601String(),
      'comments': record.comments,
    };
    return await db.insert('lens_replacement', logEntry);
  }
}
