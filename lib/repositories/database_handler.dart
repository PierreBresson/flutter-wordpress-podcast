import 'package:fwp/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const tablename = 'episodeplayable';

const id = 0;

class DatabaseHandler {
  late Database database;

  Future<void> init() async {
    final path = await getDatabasesPath();

    database = await openDatabase(
      join(path, 'database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tablename(id INTEGER PRIMARY KEY, audioFileUrl TEXT, date TEXT, title TEXT, imageUrl TEXT, positionInSeconds INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertEpisodePlayable(EpisodePlayable episodePlayable) async {
    await database.insert(
      tablename,
      EpisodePlayable(
        id: id,
        title: episodePlayable.title,
        date: episodePlayable.date,
        audioFileUrl: episodePlayable.audioFileUrl,
        imageUrl: episodePlayable.imageUrl,
        positionInSeconds: episodePlayable.positionInSeconds,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
      imageUrl: imageUrl,
      positionInSeconds: positionInSeconds,
    );

    await database.update(
      tablename,
      newEpisodePlayable.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<EpisodePlayable>> getAllEpisodePlayables() async {
    final List<Map<String, dynamic>> maps = await database.query(tablename);

    return List.generate(maps.length, (i) {
      return EpisodePlayable(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        date: maps[i]['date'] as String,
        audioFileUrl: maps[i]['audioFileUrl'] as String,
        imageUrl: maps[i]['imageUrl'] as String,
        positionInSeconds: maps[i]['positionInSeconds'] as int,
      );
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
        imageUrl: "",
        positionInSeconds: 0,
      );
    }
  }
}
