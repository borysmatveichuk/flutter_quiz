import 'package:json_annotation/json_annotation.dart';

part 'Answer.g.dart';

@JsonSerializable()
class Answer {
  String id;
  String content;
  int points;
  String next;

  Answer({
    this.id,
    this.content,
    this.points,
    this.next,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);

  @override
  String toString() {
    return 'Answer{id: $id, content: $content, points: $points, next: $next}';
  }

}
