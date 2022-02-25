import 'package:flutter/foundation.dart';
import 'package:fwp/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const tablename = 'episodeplayable';

const id = 0;
const databaseName = 'database.db';
const databaseVersion = 5;

class DatabaseHandler {
  late Database database;

  Future<void> init() async {
    final path = await getDatabasesPath();

    database = await openDatabase(
      join(path, databaseName),
      onUpgrade: onUpgrade,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tablename(id INTEGER PRIMARY KEY, audioFileUrl TEXT, articleUrl TEXT, date TEXT, title TEXT, imageUrl TEXT, description TEXT, positionInSeconds INTEGER)',
        );
      },
      version: databaseVersion,
    );
  }

  void onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      switch (oldVersion) {
        case 3:
          try {
            db.execute(
                "ALTER TABLE $tablename ADD COLUMN articleUrl TEXT description TEXT;");
          } catch (error) {
            if (kDebugMode) {
              print(error);
            }
          }
          break;
        case 4:
          try {
            db.execute("ALTER TABLE $tablename ADD COLUMN description TEXT;");
          } catch (error) {
            if (kDebugMode) {
              print(error);
            }
          }
          break;
        default:
      }
    }
  }

  Future<void> dispose() async {
    final path = await getDatabasesPath();

    database = await openDatabase(join(path, databaseName));

    await database.close();
  }

  Future<void> insertEpisodePlayable(EpisodePlayable episodePlayable) async {
    try {
      await database.insert(
        tablename,
        EpisodePlayable(
          id: id,
          title: episodePlayable.title,
          date: episodePlayable.date,
          audioFileUrl: episodePlayable.audioFileUrl,
          articleUrl: episodePlayable.articleUrl,
          imageUrl: episodePlayable.imageUrl,
          positionInSeconds: episodePlayable.positionInSeconds,
          description: episodePlayable.description,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> updateEpisodePlayable(EpisodePlayable episodePlayable) async {
    final currentEpisodePlayable = await getFirstEpisodePlayable();

    final title = episodePlayable.title.isNotEmpty
        ? episodePlayable.title
        : currentEpisodePlayable.title;
    final date = episodePlayable.date.isNotEmpty
        ? episodePlayable.date
        : currentEpisodePlayable.date;
    final audioFileUrl = episodePlayable.audioFileUrl.isNotEmpty
        ? episodePlayable.audioFileUrl
        : currentEpisodePlayable.audioFileUrl;
    final articleUrl = episodePlayable.articleUrl.isNotEmpty
        ? episodePlayable.articleUrl
        : currentEpisodePlayable.articleUrl;
    final description = episodePlayable.description.isNotEmpty
        ? episodePlayable.description
        : currentEpisodePlayable.description;
    final imageUrl = episodePlayable.imageUrl.isNotEmpty
        ? episodePlayable.imageUrl
        : currentEpisodePlayable.imageUrl;

    final positionInSeconds = episodePlayable.positionInSeconds != 0
        ? episodePlayable.positionInSeconds
        : currentEpisodePlayable.positionInSeconds;

    final newEpisodePlayable = EpisodePlayable(
      id: id,
      title: title,
      date: date,
      audioFileUrl: audioFileUrl,
      articleUrl: articleUrl,
      imageUrl: imageUrl,
      positionInSeconds: positionInSeconds,
      description: description,
    );

    try {
      await database.update(
        tablename,
        newEpisodePlayable.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<List<EpisodePlayable>> getAllEpisodePlayables() async {
    final List<Map<String, dynamic>> maps = await database.query(tablename);

    return List.generate(maps.length, (i) {
      EpisodePlayable episode;
      try {
        episode = EpisodePlayable(
          id: maps[i]['id'] as int,
          title: maps[i]['title'] as String,
          date: maps[i]['date'] as String,
          audioFileUrl: maps[i]['audioFileUrl'] as String,
          articleUrl: maps[i]['articleUrl'] as String,
          imageUrl: maps[i]['imageUrl'] as String,
          positionInSeconds: maps[i]['positionInSeconds'] as int,
          description: maps[i]['description'] as String,
        );
      } catch (e) {
        episode = EpisodePlayable(
          id: 0,
          title: "",
          date: "",
          audioFileUrl: "",
          articleUrl: "",
          imageUrl: "",
          description: "",
          positionInSeconds: 0,
        );
      }
      return episode;
    });
  }

  Future<EpisodePlayable> getFirstEpisodePlayable() async {
    final episodePlayables = await getAllEpisodePlayables();

    if (episodePlayables.isNotEmpty) {
      return episodePlayables[0];
    } else {
      return EpisodePlayable(
        id: id,
        title: "",
        date: "",
        audioFileUrl: "",
        articleUrl: "",
        imageUrl: "",
        description: "",
        positionInSeconds: 0,
      );
    }
  }
}
