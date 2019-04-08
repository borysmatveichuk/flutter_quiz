import 'package:flutter_app_bloc_sample/model/Answer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Question.g.dart';

@JsonSerializable()
class Question {
  String id;
  String question;
  InputType inputType;
  String validator;
  List<Answer> answers;
  int points;
  String next;

  Question({
    this.id,
    this.question,
    this.inputType,
    this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  String toString() {
    return 'Question{id: $id, question: $question, inputType: $inputType, validator: $validator, answers: $answers}';
  }

}

enum InputType {
  text,
  select
}
