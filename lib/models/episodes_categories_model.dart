class EpisodesCategory {
  String name;
  int id;
  EpisodesCategory({
    required this.name,
    required this.id,
  });

  factory EpisodesCategory.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json['id'] as int;
      final String name = json['name'] as String;

      return EpisodesCategory(name: name, id: id);
    } catch (error) {
      return EpisodesCategory(name: "", id: 0);
    }
  }
}

class EpisodesCategories {
  final List<EpisodesCategory> items;
  final int total;

  EpisodesCategories({
    required this.items,
    required this.total,
  });
}
