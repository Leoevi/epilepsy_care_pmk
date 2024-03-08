import 'dart:async';

import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:epilepsy_care_pmk/models/event.dart';
import 'package:epilepsy_care_pmk/models/med_allergy_event.dart';
import 'package:epilepsy_care_pmk/models/med_intake_event.dart';
import 'package:epilepsy_care_pmk/models/seizure_event.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Inspired by this: https://www.youtube.com/watch?v=q8UXj-44dk8
class DatabaseService {
  static const int _version = 1;
  static const String _dbName = "epilepsy_care_pmk.db";

  // Stream for sending out database changes, intend for refreshing page on change
  // inspired from: https://github.com/alextekartik/flutter_app_example/blob/master/notepad_sqflite/lib/provider/note_provider.dart
  static final _updateTriggerController = StreamController<bool>.broadcast();

  /// This will be called on every method that modified the database.
  /// By calling it, the stream can send out an event to let the listener
  /// know that they should reload data from the database
  static void _triggerUpdate() {
    _updateTriggerController.sink.add(true);
  }

  /// A stream that sends out an event when there is a change to the database,
  /// can be used to indicate that new data is available to reload.
  static final updateTriggerStream = _updateTriggerController.stream;

  // Table names for each of the tables in the db
  static const String seizureEventTableName = "SeizureEvent";
  static const String seizureEventTablePrimaryKeyName = "seizureId";
  static const String medAllergyEventTableName = "MedAllergyEvent";
  static const String medAllergyEventPrimaryKeyName = "medAllergyId";
  static const String medIntakeEventTableName = "MedIntakeEvent";
  static const String medIntakeEventTablePrimaryKeyName = "medIntakeId";

  /// Retrieve an instance of the database, will run onCreate once when
  /// there is no existing database.
  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      // onCreate will only run (because we specify the db version) once
      // sqflite create the database file at "/data/user/0/app_name/databases" (just use getDatabasePath() if unsure)
      // (https://stackoverflow.com/questions/68552185/where-is-my-sqflite-database-stored-inside-flutter-app)
      onCreate: (db, version) async {
        // db.execute only execute 1 statement. So we need to call it once for each table.
        await db.execute("""
          CREATE TABLE IF NOT EXISTS "$seizureEventTableName"
            ("$seizureEventTablePrimaryKeyName" INTEGER NOT NULL,
            "time" INTEGER NOT NULL,
            "seizureType" TEXT NOT NULL, 
            "seizureSymptom" TEXT NULL,
            "seizurePlace" TEXT NOT NULL,
            PRIMARY KEY ("$seizureEventTablePrimaryKeyName")) STRICT;
         """);  // STRICT is sqlite exclusive (https://www.sqlite.org/stricttables.html)
        await db.execute("""
          CREATE TABLE IF NOT EXISTS "$medAllergyEventTableName"
            ("$medAllergyEventPrimaryKeyName" INTEGER NOT NULL,
            "time" INTEGER NOT NULL,
            "med" TEXT NOT NULL,
            "medAllergySymptom" TEXT NOT NULL, 
            PRIMARY KEY ("$medAllergyEventPrimaryKeyName")) STRICT;
        """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS "$medIntakeEventTableName"
            ("$medIntakeEventTablePrimaryKeyName" INTEGER NOT NULL,
            "time" INTEGER NOT NULL,
            "med" TEXT NOT NULL,
            "mgAmount" REAL NOT NULL, 
            PRIMARY KEY ("$medIntakeEventTablePrimaryKeyName")) STRICT;
        """);
      },
      version: _version,
    );
  }

  /// Delete the whole database.
  static Future deleteDb() async {
    deleteDatabase(join(await getDatabasesPath(), _dbName));
    _triggerUpdate();
  }

  /// Add a SeizureEvent to the database.
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

  /// Edit a SeizureEvent in the database.
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

  /// Delete a SeizureEvent from the database.
  static Future<int> deleteSeizureEvent(SeizureEvent seizureEvent) async {
    final db = await _getDB();
    return await db.delete(seizureEventTableName,
        where: "$seizureEventTablePrimaryKeyName = ?",
        whereArgs: [seizureEvent.seizureId]).then((value) {
      _triggerUpdate();
      return value;
    });
  }

  /// Retrieve all SeizureEvent(s) from the database.
  /// Does not guarantee any sorting order.
  static Future<List<SeizureEvent>> getAllSeizureEvents() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
        await db.query(seizureEventTableName);
    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => SeizureEvent.fromJson(maps[index]));
  }

  /// Retrieve all SeizureEvent(s) from the database with a specific date range.
  /// Does not guarantee any sorting order.
  static Future<List<SeizureEvent>> getAllSeizureEventsFrom(DateTimeRange dateTimeRange) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
        seizureEventTableName,
        where: "time BETWEEN ? and ?",
        whereArgs: [dateTimeToUnixTime(dateTimeRange.start), dateTimeToUnixTime(dateTimeRange.end)]);

    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => SeizureEvent.fromJson(maps[index]));
  }

  /// Add a MedAllergyEvent to the database.
  static Future<int> addMedAllergyEvent(MedAllergyEvent medAllergyEvent) async {
    final db = await _getDB();
    return await db
        .insert(medAllergyEventTableName, medAllergyEvent.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _triggerUpdate();
      return value; // return the original value from insert
    });
  }

  /// Edit a MedAllergyEvent in the database.
  static Future<int> updateMedAllergyEvent(MedAllergyEvent medAllergyEvent) async {
    final db = await _getDB();
    return await db
        .update(medAllergyEventTableName, medAllergyEvent.toJson(),
        where: "$medAllergyEventPrimaryKeyName = ?",
        // This where args is plugged into the ? symbol
        whereArgs: [medAllergyEvent.medAllergyId],
        conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _triggerUpdate();
      return value;
    });
  }

  /// Delete a MedAllergyEvent from the database.
  static Future<int> deleteMedAllergyEvent(MedAllergyEvent medAllergyEvent) async {
    final db = await _getDB();
    return await db.delete(medAllergyEventTableName,
        where: "$medAllergyEventPrimaryKeyName = ?",
        whereArgs: [medAllergyEvent.medAllergyId]).then((value) {
      _triggerUpdate();
      return value;
    });
  }

  /// Retrieve all MedAllergyEvent(s) from the database.
  /// Does not guarantee any sorting order.
  static Future<List<MedAllergyEvent>> getAllMedAllergyEvents() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
    await db.query(medAllergyEventTableName);
    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => MedAllergyEvent.fromJson(maps[index]));
  }

  /// Retrieve all MedAllergyEvent(s) from the database with a specific date range.
  /// Does not guarantee any sorting order.
  static Future<List<MedAllergyEvent>> getAllMedAllergyEventsFrom(DateTimeRange dateTimeRange) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
        medIntakeEventTableName,
        where: "time BETWEEN ? and ?",
        whereArgs: [dateTimeToUnixTime(dateTimeRange.start), dateTimeToUnixTime(dateTimeRange.end)]);

    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => MedAllergyEvent.fromJson(maps[index]));
  }

  /// Add a MedIntakeEvent to the database.
  static Future<int> addMedIntakeEvent(MedIntakeEvent medIntakeEvent) async {
    final db = await _getDB();
    return await db
        .insert(medIntakeEventTableName, medIntakeEvent.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _triggerUpdate();
      return value; // return the original value from insert
    });
  }

  /// Edit a MedIntakeEvent in the database.
  static Future<int> updateMedIntakeEvent(MedIntakeEvent medIntakeEvent) async {
    final db = await _getDB();
    return await db
        .update(medIntakeEventTableName, medIntakeEvent.toJson(),
        where: "$medIntakeEventTablePrimaryKeyName = ?",
        // This where args is plugged into the ? symbol
        whereArgs: [medIntakeEvent.medIntakeId],
        conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _triggerUpdate();
      return value;
    });
  }

  /// Delete a MedIntakeEvent from the database.
  static Future<int> deleteMedIntakeEvent(MedIntakeEvent medIntakeEvent) async {
    final db = await _getDB();
    return await db.delete(medIntakeEventTableName,
        where: "$medIntakeEventTablePrimaryKeyName = ?",
        whereArgs: [medIntakeEvent.medIntakeId]).then((value) {
      _triggerUpdate();
      return value;
    });
  }

  /// Retrieve all MedIntakeEvent(s) from the database.
  /// Does not guarantee any sorting order.
  static Future<List<MedIntakeEvent>> getAllMedIntakeEvents() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
    await db.query(medIntakeEventTableName);
    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => MedIntakeEvent.fromJson(maps[index]));
  }

  /// Retrieve all MedIntakeEvent(s) from the database with a specific date range.
  /// Does not guarantee any sorting order.
  static Future<List<MedIntakeEvent>> getAllMedIntakeEventsFrom(DateTimeRange dateTimeRange) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
        medIntakeEventTableName,
        where: "time BETWEEN ? and ?",
        whereArgs: [dateTimeToUnixTime(dateTimeRange.start), dateTimeToUnixTime(dateTimeRange.end)]);

    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => MedIntakeEvent.fromJson(maps[index]));
  }

  /// Return all Event(s) from the database.
  /// Does not guarantee any sorting order.
  static Future<List<Event>> getAllEvents() async {
    List<SeizureEvent> allSeizureEvents = await getAllSeizureEvents();
    List<MedAllergyEvent> allMedAllergyEvent = await getAllMedAllergyEvents();
    List<MedIntakeEvent> allMedIntakeEvent = await getAllMedIntakeEvents();

    // Casting lists: https://stackoverflow.com/a/60461895
    // Casting subclass to superclass will still make each element type-checkable (x is SubClass)
    List<Event> allEvents = allSeizureEvents.cast<Event>() + allMedAllergyEvent.cast<Event>() + allMedIntakeEvent.cast<Event>();

    return allEvents;
  }

  /// Return all Event(s) from the database with a specific date range.
  /// Does not guarantee any sorting order.
  static Future<List<Event>> getAllEventsFrom(DateTimeRange dateTimeRange) async {
    List<SeizureEvent> allSeizureEvents = await getAllSeizureEventsFrom(dateTimeRange);
    List<MedAllergyEvent> allMedAllergyEvent = await getAllMedAllergyEventsFrom(dateTimeRange);
    List<MedIntakeEvent> allMedIntakeEvent = await getAllMedIntakeEventsFrom(dateTimeRange);

    // Casting lists: https://stackoverflow.com/a/60461895
    // Casting subclass to superclass will still make each element type-checkable (x is SubClass)
    List<Event> allEvents = allSeizureEvents.cast<Event>() + allMedAllergyEvent.cast<Event>() + allMedIntakeEvent.cast<Event>();

    return allEvents;
  }
}
