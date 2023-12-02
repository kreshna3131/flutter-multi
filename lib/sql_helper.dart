import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {

  static Future<sql.Database> dab() async {
    return sql.openDatabase("note.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTab(database);
    });
  }

  static Future<void> createTab(sql.Database database) async {
    await database.execute("""
      CREATE TABLE catatan(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        judul TEXT,
        deskripsi TEXT
      )
      """);
  }

  static Future<void> hapusNote(int id) async {
    final db = await SQLHelper.dab();
    await db.delete("catatan", where: "id = $id");
  }

  static Future<List<Map<String, dynamic>>> getNote() async {
    final db = await SQLHelper.dab();
    return db.query("catatan");
  }

  static Future<int> tambahNote(String judul, String deskripsi) async {
    final db = await SQLHelper.dab();
    final data = {'judul': judul, 'deskripsi': deskripsi};
    return await db.insert("catatan", data);
  }

  static Future<int> ubahNote(int id, String judul, String deskripsi) async {
    final db = await SQLHelper.dab();
    final data = {'judul': judul, 'deskripsi': deskripsi};
    return await db.update('catatan', data, where: "id = $id");
  }



  static Future<sql.Database> db() async {
    return sql.openDatabase("catatan.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
      CREATE TABLE catatan(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        judul TEXT,
        deskripsi TEXT,
        gambar TEXT
      )
      """);
  }

  static Future<int> tambahCatatan(String judul, String deskripsi, String gambar) async {
    final db = await SQLHelper.db();
    final data = {'judul': judul, 'deskripsi': deskripsi, 'gambar': gambar};
    return await db.insert("catatan", data);
  }

  static Future<void> hapusCatatan(int id) async {
    final db = await SQLHelper.db();
    await db.delete("catatan", where: "id=$id");
  }

  static Future<List<Map<String, dynamic>>> getCatatan() async {
    final db = await SQLHelper.db();
    return db.query("catatan");
  }

  static Future<int> ubahCatatan(int id, String judul, String deskripsi, String gambar) async {
    final db = await SQLHelper.db();
    final data = {'judul': judul, 'deskripsi': deskripsi, 'gambar': gambar};
    return await db.update('catatan', data, where: "id = $id");
  }

  static Future<sql.Database> da() async {
    return sql.openDatabase("catatan3.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTa(database);
    });
  }

  static Future<void> createTa(sql.Database database) async {
    await database.execute("""
      CREATE TABLE catatan(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        judul TEXT,
        deskripsi TEXT,
        gambar TEXT
      )
      """);
  }

  static Future<int> tambahCatatan3(String judul, String deskripsi, String gambar) async {
    final db = await SQLHelper.da();
    final data = {'judul': judul, 'deskripsi': deskripsi, 'gambar': gambar};
    return await db.insert("catatan", data);
  }

  static Future<void> hapusCatatan3(int id) async {
    final db = await SQLHelper.da();
    await db.delete("catatan", where: "id=$id");
  }

  static Future<List<Map<String, dynamic>>> getCatatan3() async {
    final db = await SQLHelper.da();
    return db.query("catatan");
  }

  static Future<int> ubahCatatan3(int id, String judul, String deskripsi, String gambar) async {
    final db = await SQLHelper.da();
    final data = {'judul': judul, 'deskripsi': deskripsi, 'gambar': gambar};
    return await db.update('catatan', data, where: "id = $id");
  }

  static Future<sql.Database> dbase() async {
    return sql.openDatabase("catatan3.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTa(database);
    });
  }
}