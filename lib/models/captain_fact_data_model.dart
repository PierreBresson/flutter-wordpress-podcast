// https://javiercbk.github.io/json_to_dart/
// ignore_for_file: unnecessary_
// ignore_for_file: argument_type_not_assignable
// ignore_for_file: invalid_assignment

class CaptainFactData {
  Video? video;

  CaptainFactData({this.video});

  CaptainFactData.fromJson(Map<String, dynamic> json) {
    video = json['video'] != null ? Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }
}

class Video {
  List<Statements>? statements;
  String? id;

  Video({this.statements, this.id});

  Video.fromJson(Map<String, dynamic> json) {
    if (json['statements'] != null) {
      statements = <Statements>[];
      json['statements'].forEach((v) {
        statements!.add(Statements.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.statements != null) {
      data['statements'] = this.statements!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Statements {
  int? time;
  String? text;
  List<Comments>? comments;

  Statements({this.time, this.text, this.comments});

  Statements.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    text = json['text'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['time'] = this.time;
    data['text'] = this.text;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? text;
  Source? source;
  int? score;
  String? replyToId;
  bool? approve;

  Comments({this.text, this.source, this.score, this.replyToId, this.approve});

  Comments.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
    score = json['score'];
    replyToId = json['replyToId'];
    approve = json['approve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.text;
    if (this.source != null) {
      data['source'] = this.source!.toJson();
    }
    data['score'] = this.score;
    data['replyToId'] = this.replyToId;
    data['approve'] = this.approve;
    return data;
  }
}

class Source {
  String? url;

  Source({this.url});

  Source.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
