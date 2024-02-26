import 'dart:async';

import 'package:epilepsy_care_pmk/models/seizure_event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Inspired by this: https://www.youtube.com/watch?v=q8UXj-44dk8
class DatabaseService {
  static const int _version = 1;
  static const String _dbName = "epilepsy_care_pmk.db";

  // Stream for sending out database changes, intend for refreshing page on change
  // inspired from: https://github.com/alextekartik/flutter_app_example/blob/master/notepad_sqflite/lib/provider/note_provider.dart
  static final _updateTriggerController = StreamController<bool>.broadcast();

  static void _triggerUpdate() {
    _updateTriggerController.sink.add(true);
  }

  /// A stream that sends out an event when there is a change to the database,
  /// can be used to trigger rebuilds of a StreamBuilder widget.
  static final updateTriggerStream = _updateTriggerController.stream;

  // Table names for each of the tables in the db
  static const String seizureEventTableName = "SeizureEvent";
  static const String seizureEventTablePrimaryKeyName =
      "seizureId"; // Will use this for update and deletion of a row

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      // onCreate will only run (because we specify the db version) once
      // sqflite create the database file at "/data/user/0/app_name/databases" (just use getDatabasePath() if unsure)
      // (https://stackoverflow.com/questions/68552185/where-is-my-sqflite-database-stored-inside-flutter-app)
      onCreate: (db, version) async => await db.execute(
          'CREATE TABLE IF NOT EXISTS "$seizureEventTableName" ("$seizureEventTablePrimaryKeyName" INTEGER NOT NULL, "time" INTEGER NOT NULL, "seizureType" TEXT NOT NULL, "seizureSymptom" TEXT NULL, "seizurePlace" TEXT NOT NULL, PRIMARY KEY ("$seizureEventTablePrimaryKeyName"));'),
      // TODO: finish query for every table
      version: _version,
    );
  }

  static Future deleteDb() async {
    deleteDatabase(join(await getDatabasesPath(), _dbName));
    _triggerUpdate();
  }

  static Future<int> addSeizureEvent(SeizureEvent seizureEvent) async {
    final db = await _getDB();
    return await db
        .insert(seizureEventTableName, seizureEvent.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _triggerUpdate();
      return value; // return the original value from insert
    });
  }

  static Future<int> updateSeizureEvent(SeizureEvent seizureEvent) async {
    final db = await _getDB();
    return await db
        .update(seizureEventTableName, seizureEvent.toJson(),
            where: "$seizureEventTablePrimaryKeyName = ?",
            // This where args is plugged into the ? symbol
            whereArgs: [seizureEvent.seizureId],
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _triggerUpdate();
      return value;
    });
  }

  static Future<int> deleteSeizureEvent(SeizureEvent seizureEvent) async {
    final db = await _getDB();
    return await db.delete(seizureEventTableName,
        where: "$seizureEventTablePrimaryKeyName = ?",
        whereArgs: [seizureEvent.seizureId]).then((value) {
      _triggerUpdate();
      return value;
    });
  }

  static Future<List<SeizureEvent>?> getAllSeizureEvents() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
        await db.query(seizureEventTableName);
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => SeizureEvent.fromJson(maps[index]));
  }
}
