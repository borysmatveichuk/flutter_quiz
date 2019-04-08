import 'package:flutter/material.dart';
import 'package:flutter_app_bloc_sample/BlocBase.dart';
import 'package:flutter_app_bloc_sample/QuizBloc.dart';
import 'package:flutter_app_bloc_sample/model/Answer.dart';
import 'package:flutter_app_bloc_sample/model/Question.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streams Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<QuizBloc>(
        bloc: QuizBloc(context),
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QuizBloc bloc = BlocProvider.of<QuizBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Quiz App')),
      body: Center(
        child: StreamBuilder<Question>(
            stream: bloc.outQuestions,
            initialData: null,
            builder:
                (BuildContext context, AsyncSnapshot<Question> snapshot) {
              if (snapshot.data != null) {
                return buildBody(context, snapshot.data, bloc);
              } else {
                return buildStartBody(bloc);
              }
            }),
      ),
    );
  }

  Widget buildStartBody(QuizBloc bloc) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.all(8.0),
        ),
        Text('To start Quiz press Start!'),
        new Padding(
          padding: new EdgeInsets.all(8.0),
        ),
        new MaterialButton(
          color: Colors.blue,
          child: Text("Start"),
          onPressed: () => { bloc.requestController.add(null) },
        )
      ],
    );
  }

  Widget buildBody(BuildContext context, Question question, QuizBloc bloc) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.all(8.0),
        ),
        Text('Questions: ${question.question} '),
        new Padding(
          padding: new EdgeInsets.all(8.0),
        ),
        _makeBodyWithAnswers(question, bloc),
        _makeNextButton(question, bloc),
      ],
    );
  }

  Widget _makeNextButton(Question question, QuizBloc bloc) {
    return MaterialButton(
      color: Colors.blue,
      child: Text("Next"),
      onPressed: () => { bloc.requestController.add(question) },
    );
  }

  Widget _makeBodyWithAnswers(Question question, QuizBloc bloc) {
    Fluttertoast.showToast(msg: "question type ${question.inputType}");
    if (question.inputType == InputType.select) {
      return _makeRadioTiles(question.answers, bloc);
    } else {
      return _makeTextInput(question, bloc);
    }
  }

  Widget _makeTextInput(Question question, QuizBloc bloc) {
    return Column(children: <Widget>[
      new Padding(
        padding: new EdgeInsets.all(16.0),
        child: TextField(
          onChanged: (text) {
            print(text);
          },
        ),
      ),
    ]);
  }

  Widget _makeRadioTiles(List<Answer> answers, QuizBloc bloc) {
    return StreamBuilder<Answer>(
        stream: bloc.outAnswer,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<Answer> snapshot) {
          final list = answers
              .map((ans) =>
                  _makeRadioTitle(ans, snapshot.data, bloc.handleAnswer))
              .toList();
          return Column(children: list);
        });
  }

  Widget _makeRadioTitle(Answer answer, Answer currentAnswer, handleAnswer) {
    return RadioListTile<Answer>(
      value: answer,
      groupValue: currentAnswer,
      onChanged: handleAnswer,
      activeColor: Colors.green,
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text('${answer.content}'),
    );
  }
}
