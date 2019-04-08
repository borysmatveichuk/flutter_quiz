import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_bloc_sample/BlocBase.dart';
import 'package:flutter_app_bloc_sample/model/Answer.dart';
import 'package:flutter_app_bloc_sample/model/Question.dart';

class QuizBloc implements BlocBase {
  List<Question> _questions;
  List<Answer> _answers;
  BuildContext _context;

  Answer currentAnswer;

  StreamController<Question> _questionsController =
  StreamController<Question>();

  StreamSink<Question> get _inAddQuestions => _questionsController.sink;

  Stream<Question> get outQuestions => _questionsController.stream;

  StreamController _actionController = StreamController();

  StreamSink get requestController => _actionController.sink;

  StreamController<Answer> _answerController = StreamController();

  StreamSink<Answer> get inAnswer => _answerController.sink;

  Stream<Answer> get outAnswer => _answerController.stream;

  QuizBloc(BuildContext context) {
    _context = context;
    _questions = List<Question>();
    _actionController.stream.listen(_handleLogic);
  }

  @override
  void dispose() {
    _actionController.close();
    _questionsController.close();
    _answerController.close();
    print("dispose, unsubscribed!");
  }

  void handleAnswer(Answer event) {
    inAnswer.add(event);
  }

  void _handleLogic(event) async {
    if (event == null) {
      final parsed = json.decode(questionsJson).cast<Map<String, dynamic>>();
      _questions =
          parsed.map<Question>((json) => Question.fromJson(json)).toList();
      print(_questions);

      _inAddQuestions.add(_questions[0]);
    } else if (event is Question) {
      _questions
          .where((q) => q.id == event.next)
          .forEach((element) => _inAddQuestions.add(element));

      }
  }


  final questionsJson = """
  [
  {
    "id": "1",
    "question": "What is your name?",
    "inputType": "text",
    "validator": "[A-Za-z ]",
    "points": 3,
    "next": "2"
  },
  {
    "id": "2",
    "question": "What is your sex?",
    "inputType": "select",
    "answers": [
      {
        "id": "man",
        "content": "Man",
        "points": 4,
        "next": "3"
      },
      {
        "id": "women",
        "content": "Woman",
        "points": 4,
        "next": "3"
      },
      {
        "id": "special",
        "content": "Special",
        "points": 3,
        "next": "4"
      }
    ]
  },
  {
    "id": "3",
    "question": "Life is good?",
    "inputType": "select",
    "answers": [
      {
        "id": "yes",
        "content": "Of Course",
        "points": 50
      },
      {
        "id": "undefined",
        "content": "Not sure",
        "points": 10,
        "next": "5"
      },
      {
        "id": "no",
        "content": "No",
        "points": 1,
        "next": "4"
      }
    ]
  },
  {
    "id": "4",
    "question": "Is the glass half empty or half full?",
    "inputType": "select",
    "answers": [
      {
        "id": "full",
        "content": "Full:)",
        "points": 40
      },
      {
        "id": "2",
        "content": "Empty:(",
        "points": 1,
        "next": "4"
      }
    ]
  },
  {
    "id": "5",
    "question": "What are you wish?",
    "inputType": "text",
    "point": 2
  }
]
  """;
}
