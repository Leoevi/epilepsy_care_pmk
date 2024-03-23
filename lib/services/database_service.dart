import 'dart:async';
import 'dart:math';

import 'package:epilepsy_care_pmk/helpers/date_time_helpers.dart';
import 'package:epilepsy_care_pmk/models/alarm.dart';
import 'package:epilepsy_care_pmk/models/event.dart';
import 'package:epilepsy_care_pmk/models/med_allergy_event.dart';
import 'package:epilepsy_care_pmk/models/med_intake_event.dart';
import 'package:epilepsy_care_pmk/models/med_intake_per_day.dart';
import 'package:epilepsy_care_pmk/models/seizure_event.dart';
import 'package:epilepsy_care_pmk/models/seizure_per_day.dart';
import 'package:epilepsy_care_pmk/screens/wiki/medication/medication.dart';
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

  /// A stream that sends out an event when there is a change to the database,
  /// can be used to indicate that new data is available to reload.
  static final updateTriggerStream = _updateTriggerController.stream;

  /// This will be called on every method that modified the database.
  /// By calling it, the stream can send out an event to let the listener
  /// know that they should reload data from the database.
  static void _triggerUpdate() {
    _updateTriggerController.sink.add(true);
  }

  // Table names for each of the tables in the db
  static const String seizureEventTableName = "SeizureEvent";
  static const String seizureEventTablePrimaryKeyName = "seizureId";
  static const String medAllergyEventTableName = "MedAllergyEvent";
  static const String medAllergyEventPrimaryKeyName = "medAllergyId";
  static const String medIntakeEventTableName = "MedIntakeEvent";
  static const String medIntakeEventTablePrimaryKeyName = "medIntakeId";
  static const String alarmTableName = "Alarm";
  static const String alarmTablePrimaryKeyName = "alarmId";

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
            PRIMARY KEY ("$seizureEventTablePrimaryKeyName"));
         """);  // Older versions of sqlite doesn't work with STRICT, so we won't use them anymore.
        await db.execute("""
          CREATE TABLE IF NOT EXISTS "$medAllergyEventTableName"
            ("$medAllergyEventPrimaryKeyName" INTEGER NOT NULL,
            "time" INTEGER NOT NULL,
            "med" TEXT NOT NULL,
            "medAllergySymptom" TEXT NOT NULL, 
            PRIMARY KEY ("$medAllergyEventPrimaryKeyName"));
        """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS "$medIntakeEventTableName"
            ("$medIntakeEventTablePrimaryKeyName" INTEGER NOT NULL,
            "time" INTEGER NOT NULL,
            "med" TEXT NOT NULL,
            "mgAmount" REAL NOT NULL, 
            PRIMARY KEY ("$medIntakeEventTablePrimaryKeyName"));
        """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS "$alarmTableName" (
	          "$alarmTablePrimaryKeyName" INTEGER NOT NULL,
          	"hour" INTEGER NOT NULL,
	          "minute" INTEGER NOT NULL,
	          "med" TEXT NOT NULL,
          	"quantity" REAL NOT NULL,
	          "unit" TEXT NOT NULL,
	          "enable" INTEGER NOT NULL,
            PRIMARY KEY ("alarmID"));
        """);
      },
      version: _version,
    );
  }

  /// Generate dummy data for our database, for development purposes only.
  static void generateDummyData(int setCount, int eachSet) {
    Random random = Random();

    for (int i = 0; i < setCount; i++) {
      for (int j = 0; j < eachSet; j++) {
        SeizureEvent seizureEvent = SeizureEvent(
            time: dateTimeToUnixTime(DateTime.now().subtract(Duration(days: setCount - i, hours: random.nextInt(24)))),
            seizureType: "ชักเฉพาะ",
            seizurePlace: "home"
        );
        DatabaseService.addSeizureEvent(seizureEvent);

        MedAllergyEvent medAllergyEvent = MedAllergyEvent(
            time: dateTimeToUnixTime(DateTime.now().subtract(Duration(days: setCount - i, hours: random.nextInt(24)))),
            med: medicationEntries[random.nextInt(medicationEntries.length)].name,
            medAllergySymptom: "bruh this is a test"
        );
        DatabaseService.addMedAllergyEvent(medAllergyEvent);

        MedIntakeEvent medIntakeEvent = MedIntakeEvent(
            time: dateTimeToUnixTime(DateTime.now().subtract(Duration(days: setCount - i, hours: random.nextInt(24)))),
            med: medicationEntries[random.nextInt(medicationEntries.length)].name,
            mgAmount: random.nextDouble()*250
        );
        DatabaseService.addMedIntakeEvent(medIntakeEvent);
      }
    }
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

  /// Retrieve all SeizureEvent(s) from the database within the specify date range
  /// (inclusive). Does not guarantee any sorting order.
  static Future<List<SeizureEvent>> getAllSeizureEventsFrom(DateTimeRange dateTimeRange) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
        seizureEventTableName,
        where: "time BETWEEN ? and ?",  // TODO: use and clause to exclude midnight of next day
        whereArgs: [dateTimeToUnixTime(dateTimeRange.start), dateTimeToUnixTime(dateTimeRange.end.add(Duration(days: 1)))]);

    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => SeizureEvent.fromJson(maps[index]));
  }

  static Future<List<SeizurePerDay>> getAllSeizurePerDayFrom(DateTimeRange dateTimeRange) async {
    final db = await _getDB();
    // We get this raw query by experimenting in other querying programs.
    // Use ? as placeholder to prevent SQL injection.
    // Derived from the query in _getAllMedIntakePerDayFromOf
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
-- Generate column with each date between the start date and end date (inclusive).
WITH Dates(dateRange) AS (
   SELECT DATE(?, ?)
   UNION ALL
   SELECT DATE(dateRange, '+1 day') 
   FROM Dates
   WHERE dateRange < DATE(?)
)

-- Join the earlier table with our actual table for all dates
-- Gotta count with the SeizureEvent row.
-- Otherwise, it will count at least 1 from the dateRange column.
SELECT d.dateRange AS date, COUNT(s.seizureId) AS seizureOccurrence
   FROM Dates d LEFT JOIN SeizureEvent s
      ON DATE(s.time, 'unixepoch', 'localtime') = d.dateRange 
      -- by default, sqlite's DATE function will assume that the given time
      -- value is already in local time, however, since we stored time in UTC, we
      -- will tell it to convert the UTC time to local time with the modifier.
      AND s.time >= STRFTIME('%s', DATE(?, ?))
      AND s.time < STRFTIME('%s', DATE(?, '+1 day'))
   GROUP BY d."dateRange"
   ORDER BY d."dateRange";
    """, [
      dateTimeRange.end.toIso8601String(),
      "-${dateTimeRange.end.difference(dateTimeRange.start).inDays} days",
      dateTimeRange.end.toIso8601String(),
      dateTimeRange.end.toIso8601String(),
      "-${dateTimeRange.end.difference(dateTimeRange.start).inDays} days",
      dateTimeRange.end.toIso8601String(),
    ]);

    return List.generate(maps.length, (index) => SeizurePerDay.fromJson(maps[index]));
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

  /// Retrieve all MedAllergyEvent(s) from the database with a specific date range
  /// (inclusive). Does not guarantee any sorting order.
  static Future<List<MedAllergyEvent>> getAllMedAllergyEventsFrom(DateTimeRange dateTimeRange) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
        medAllergyEventTableName,
        where: "time BETWEEN ? and ?",
        whereArgs: [dateTimeToUnixTime(dateTimeRange.start), dateTimeToUnixTime(dateTimeRange.end.add(Duration(days: 1)))]);

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

  /// Aggregate all MedicationIntakeEvent (without discerning differing medications)
  /// and sum up each day's intake. Will always sort from oldest to newest.
  /// For dev purposes only.
  @Deprecated("For dev purposes only.")
  static Future<List<MedIntakePerDay>> getAllMedIntakePerDay() async {
    final db = await _getDB();
    // We get this raw query from experimenting them in other programs
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT DATE(time, 'unixepoch') AS date, SUM(mgAmount) AS totalDose
      FROM MedIntakeEvent
      GROUP BY DATE(time, 'unixepoch')
      ORDER BY DATE(time, 'unixepoch');
    """);
    // https://www.sqlite.org/lang_datefunc.html
    // https://stackoverflow.com/questions/17821136/sqlite-group-by-count-hours-days-weeks-year
    // https://stackoverflow.com/questions/40199091/group-by-day-when-column-is-in-unixtimestamp
    // https://mode.com/sql-tutorial/sql-group-by
    // Add order by just in case.
    //
    // So, what is happening here? Well, for starters, we used a sqlite helper fn called DATE
    // Which will return date in the from of "YYYY-MM-DD" String, but we need to first give it
    // the time that we want to convert, which is the "time" column. And since we are storing time
    // in the unix timestamp format, we'll need to specify a modifier to tell the helper function
    // what are we converting from. In this case, we use 'unixepoch'
    //
    // After that, we then used the group by clause to group all rows with the same date.
    // Simple as that.

    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(maps.length, (index) => MedIntakePerDay.fromJson(maps[index]));
  }

  /// Aggregate all MedicationIntakeEvent of a specified medication and sum up each day's intake
  /// from a given [DateTimeRange] (inclusive). Will always sort from oldest to newest.
  ///
  /// If the given [Medication] haven't been recorded in the specified [DateTimeRange],
  /// this method will return an empty list instead.
  static Future<List<MedIntakePerDay>> _getAllMedIntakePerDayFromOf(Medication med, DateTimeRange dateTimeRange) async {
    final db = await _getDB();
    // We get this raw query by experimenting in other querying programs.
    // Use ? as placeholder to prevent SQL injection.
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
-- Adapted from https://stackoverflow.com/a/70529890

-- Generate column with each date between the start date and end date (inclusive).
WITH Dates(dateRange) AS (
  SELECT DATE(?, ?)
  UNION ALL
  SELECT DATE(dateRange, '+1 day') 
  FROM Dates
  WHERE dateRange < DATE(?)
)

-- Join the earlier table with our actual table for all dates, even if there is no data for that date.
-- COALESCE is used for replacing null from the SUM function with 0 (https://365datascience.com/question/sum-for-columns-with-null-values/)
-- In this case, we want a double 0, not an int 0, so we do 0.0
SELECT d.dateRange AS date, COALESCE(SUM(m.mgAmount), 0.0) AS totalDose
   FROM Dates d LEFT JOIN MedIntakeEvent m
      ON DATE(m.time, 'unixepoch', 'localtime') = d.dateRange
      -- by default, sqlite's DATE function will assume that the given time
      -- value is already in local time, however, since we stored time in UTC, we
      -- will tell it to convert the UTC time to local time with the modifier.
      AND med = ?
      AND TIME >= STRFTIME('%s', DATE(?, ?))
      AND TIME < STRFTIME('%s', DATE(?, '+1 day'))  -- Add 1 day (except the last second) so that data of the end day is also counted
      -- When doing outer joins, DON'T use WHERE, use ON instead;
      -- otherwise, WHERE will throw missing values away
      -- https://stackoverflow.com/a/12467772
   GROUP BY d.dateRange
   ORDER BY d.dateRange;
    """, [
      dateTimeRange.end.toIso8601String(),
      "-${dateTimeRange.end.difference(dateTimeRange.start).inDays} days",
      dateTimeRange.end.toIso8601String(),
      med.name,
      dateTimeRange.end.toIso8601String(),
      "-${dateTimeRange.end.difference(dateTimeRange.start).inDays} days",
      dateTimeRange.end.toIso8601String(),
    ]);
    // STRFTIME is also another helper function that returns time in the format of our desire
    // In this case, since we are storing time in the unix timestamp format, we'll
    // specify the function to also return unix timestamp by specifying the %s modifier.
    // and the ? is just DateTime in String.
    //
    // Also, the reason that we used < on the end of the range is because otherwise
    // it will include the first second of the midnight of the next day, which we don't want.
    //
    // PS. You don't need any quotation marks around ?
    // Okay, you CAN'T use quotation marks around ?, it'll cause syntax errors.
    // Because ? itself is a String.
    List<MedIntakePerDay> result = List.generate(maps.length, (index) => MedIntakePerDay.fromJson(maps[index]));

    // Check for at least one day with non-zero med intake; otherwise, return an empty list
    int index = 0;
    bool valid = false;
    while (!valid) {
      if (index < result.length) {
        if (result[index].totalDose != 0) valid = true;
        index++;
      } else {
        return List.empty();
      }
    }
    return result;
  }

  /// Aggregate all MedicationIntakeEvent of each medication and sum up each of that medication total
  /// daily intake from a given [DateTimeRange] (inclusive).
  ///
  /// Will return a map with each member reflecting that medication's output of
  /// [_getAllMedIntakePerDayFromOf], but if the output of [_getAllMedIntakePerDayFromOf] is an empty list,
  /// then that map entry will be omitted.
  static Future<Map<Medication, List<MedIntakePerDay>>> getAllMedIntakePerDayFrom(DateTimeRange dateTimeRange) async {
    Map<Medication, List<MedIntakePerDay>> medIntakeMap = {};
    for (Medication med in medicationEntries) {
      List<MedIntakePerDay> eachMedIntakePerDay = await _getAllMedIntakePerDayFromOf(med, dateTimeRange);
      if (eachMedIntakePerDay.isNotEmpty) {
        medIntakeMap[med] = eachMedIntakePerDay;
      }
    }
    return medIntakeMap;
  }

  /// Retrieve all MedIntakeEvent(s) from the database with a specific date range
  /// (inclusive). Does not guarantee any sorting order.
  static Future<List<MedIntakeEvent>> getAllMedIntakeEventsFrom(DateTimeRange dateTimeRange) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
        medIntakeEventTableName,
        where: "time BETWEEN ? and ?",
        whereArgs: [dateTimeToUnixTime(dateTimeRange.start), dateTimeToUnixTime(dateTimeRange.end.add(Duration(days: 1)))]);

    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => MedIntakeEvent.fromJson(maps[index]));
  }

  /// Return all Event(s) from the database.
  /// Also sorts from newest to oldest event.
  static Future<List<Event>> getAllSortedEvents() async {
    List<SeizureEvent> allSeizureEvents = await getAllSeizureEvents();
    List<MedAllergyEvent> allMedAllergyEvent = await getAllMedAllergyEvents();
    List<MedIntakeEvent> allMedIntakeEvent = await getAllMedIntakeEvents();

    // Casting lists: https://stackoverflow.com/a/60461895
    // Casting subclass to superclass will still make each element type-checkable (x is SubClass)
    List<Event> allEvents = allSeizureEvents.cast<Event>() + allMedAllergyEvent.cast<Event>() + allMedIntakeEvent.cast<Event>();
    allEvents.sort((a, b) => b.compareTo(a));  // reverse the order so that latest events comes first
    // I'm not 100% sure, but I think sorting in async method still blocks the UI, but if this
    // was ever a concern, we can look into isolates and stuff

    return allEvents;
  }

  /// Return all Event(s) from the database with a specific date range.
  /// Also sorts from newest to oldest event.
  static Future<List<Event>> getAllSortedEventsFrom(DateTimeRange dateTimeRange) async {
    List<SeizureEvent> allSeizureEvents = await getAllSeizureEventsFrom(dateTimeRange);
    List<MedAllergyEvent> allMedAllergyEvent = await getAllMedAllergyEventsFrom(dateTimeRange);
    List<MedIntakeEvent> allMedIntakeEvent = await getAllMedIntakeEventsFrom(dateTimeRange);

    List<Event> allEvents = allSeizureEvents.cast<Event>() + allMedAllergyEvent.cast<Event>() + allMedIntakeEvent.cast<Event>();
    allEvents.sort((a, b) => b.compareTo(a));

    return allEvents;
  }

  /// Add an Alarm to the database.
  static Future<int> addAlarm(Alarm alarm) async {
    final db = await _getDB();
    return await db
        .insert(alarmTableName, alarm.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _triggerUpdate();
      return value; // return the original value from insert
    });
  }

  /// Edit an Alarm in the database.
  static Future<int> updateAlarm(Alarm alarm) async {
    final db = await _getDB();
    return await db
        .update(alarmTableName, alarm.toJson(),
        where: "$alarmTablePrimaryKeyName = ?",
        // This where args is plugged into the ? symbol
        whereArgs: [alarm.alarmId],
        conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      _triggerUpdate();
      return value;
    });
  }

  /// Delete an Alarm from the database.
  static Future<int> deleteAlarm(Alarm alarm) async {
    final db = await _getDB();
    return await db.delete(alarmTableName,
        where: "$alarmTablePrimaryKeyName = ?",
        whereArgs: [alarm.alarmId]).then((value) {
      _triggerUpdate();
      return value;
    });
  }

  /// Update the enable status of an alarm according to the passed in Alarm.
  ///
  /// This method is similar to [updateAlarm], but doesn't sent out stream,
  /// so that lists that display alarms won't rebuild.
  static Future<int> updateAlarmEnable(Alarm alarm) async {
    final db = await _getDB();
    return await db.rawUpdate("""
      UPDATE $alarmTableName SET enable = ? WHERE $alarmTablePrimaryKeyName = ?
    """, [alarm.enable ? 1 : 0, alarm.alarmId]);
  }

  /// Return all Alarms from the Database.
  /// Sorted by creation from first to last.
  static Future<List<Alarm>> getAllAlarm() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
    await db.query(alarmTableName, orderBy: alarmTablePrimaryKeyName);

    if (maps.isEmpty) {
      return List.empty();
    }
    return List.generate(
        maps.length, (index) => Alarm.fromJson(maps[index]));
  }
}
