import 'package:flutter/material.dart';
import 'package:flutter_app_bloc_sample/BlocBase.dart';
import 'package:flutter_app_bloc_sample/QuizBloc.dart';
import 'package:flutter_app_bloc_sample/model/Answer.dart';
import 'package:flutter_app_bloc_sample/model/Question.dart';

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
                return buildFinishBody(context, bloc);
              }
            }),
      ),
    );
  }

  Widget buildFinishBody(BuildContext context, QuizBloc bloc) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Text("Your tolal score is: ",
            style: DefaultTextStyle
                .of(context)
                .style
                .apply(fontSizeFactor: 2.0),
        ),
        new Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Text("${bloc.totalPoints} points.",
          style: DefaultTextStyle
              .of(context)
              .style
              .apply(fontSizeFactor: 2.0, color: Colors.blueAccent),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context, Question question, QuizBloc bloc) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Questions: ${question.question} ',
              style: _getDefaultTextStyle(context)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: _makeBodyWithAnswers(question, bloc),
        ),
      ],
    );
  }

  Widget _makeBodyWithAnswers(Question question, QuizBloc bloc) {
    if (question.inputType == InputType.select) {
      return _makeRadioTiles(question, bloc);
    } else {
      return StateTextInput(question, bloc);
    }
  }

  Widget _makeRadioTiles(Question question, QuizBloc bloc) {
    return StreamBuilder<Answer>(
        stream: bloc.outAnswer,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<Answer> snapshot) {
          final list = question.answers
              .map((ans) =>
              _makeRadioTitle(context, ans, snapshot.data, bloc.handleAnswer))
              .toList();
          list.add(
              Column(children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: MaterialButton(
                      color: Colors.blue,
                      child: Text("Next", style: _getDefaultTextStyle(context)),
                      onPressed: () {
                        if (question.answers.contains(bloc.currentAnswer)) {
                          bloc.requestController.add(question);
                        } else {
                          null;
                        }
                      }),
                ),
              ]));
          return Column(children: list);
        });
  }

  Widget _makeRadioTitle(BuildContext context,
      Answer answer,
      Answer currentAnswer,
      handleAnswer) {
    return RadioListTile<Answer>(
        value: answer,
        groupValue: currentAnswer,
        onChanged: handleAnswer,
        activeColor: Colors.green,
        controlAffinity: ListTileControlAffinity.trailing,
        title: Text('${answer.content}', style: _getDefaultTextStyle(context))
    );
  }
}

_getDefaultTextStyle(BuildContext context) {
  return DefaultTextStyle
      .of(context)
      .style
      .apply(fontSizeFactor: 1.5);
}

// ignore: must_be_immutable
class StateTextInput extends StatefulWidget {

  Question question;
  QuizBloc bloc;

  StateTextInput(Question question, QuizBloc bloc) {
    this.bloc = bloc;
    this.question = question;
  }

  @override
  State<StatefulWidget> createState() => _stateTextInput(question, bloc);
}

// ignore: camel_case_types
class _stateTextInput extends State<StateTextInput> {

  Question question;
  QuizBloc bloc;

  _stateTextInput(Question question, QuizBloc bloc) {
    this.bloc = bloc;
    this.question = question;
  }

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      new Padding(
        padding: EdgeInsets.all(16.0),
        child: TextFormField(
          controller: textController,
          validator: null,
          style: _getDefaultTextStyle(context),
        ),
      ),

      new Padding(
        padding: EdgeInsets.all(16.0),
        child: MaterialButton(
            color: Colors.blue,
            child: Text("Next", style: _getDefaultTextStyle(context)),
            onPressed: () {
              if (textController.text.trim().length == 0) {
                null;
              } else if (question.validator != null) {
                RegExp regex = RegExp(question.validator);
                if (regex.hasMatch(textController.text)) {
                  bloc.requestController.add(question);
                }
              } else {
                bloc.requestController.add(question);
              }
            }),
      ),
    ]);
  }
}