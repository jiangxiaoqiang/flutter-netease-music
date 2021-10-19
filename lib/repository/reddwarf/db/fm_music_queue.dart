import 'package:quiet/model/fm_music.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FmMusicQueue{

  static Future<Database> initialDatabase() async{
    final database = openDatabase(
        join(await getDatabasesPath(),'netease2.db'),
        onCreate: (db,version){
          return db.execute(
            'CREATE TABLE fm_queue(id INTEGER PRIMARY KEY, musicinfo TEXT, createdtime INTEGER)',
          );
        },
        version: 1
    );
    return database;
  }

  static Future<void> insertFmMusic(FmMusic fmMusic) async {
    final db = await initialDatabase();
    await db.insert(
      'fm_queue',
      fmMusic.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteFmMusic(int id) async {
    final db = await initialDatabase();
    await db.delete(
      'fm_queue',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> getFmCachedMusicCount() async {
    Database db = await initialDatabase();
    final cachedMusicCount = await db.rawQuery('SELECT COUNT (*) from fm_queue');
    final int? count = Sqflite.firstIntValue(cachedMusicCount);
    return count ?? 0;
  }

  static Future<FmMusic?> getFmMusic() async {
    final db = await initialDatabase();
    List<Map<String, dynamic>> maps =await db.query(
      'fm_queue',
      orderBy: "createdtime asc",
      limit: 1
    );
    if(maps.isNotEmpty){
      return FmMusic.fromJson(maps[0]);
    }
    return Future.value(null);
  }

  static Future<FmMusic?> getFmMusicById(int id) async {
    final db = await initialDatabase();
    List<Map<String, dynamic>> maps =await db.query(
        'fm_queue',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1
    );
    if(maps.isNotEmpty){
      return FmMusic.fromJson(maps[0]);
    }
    return Future.value(null);
  }
}


