
import 'dart:async';
import 'package:flutter_app_bloc_sample/BlocBase.dart';

class IncrementBloc implements BlocBase {
  int _counter;

  StreamController<int> _counterController = StreamController<int>();
  StreamSink<int> get _inAdd => _counterController.sink;
  Stream<int> get outCounter => _counterController.stream;

  StreamController _actionController = StreamController();
  StreamSink get incrementController => _actionController.sink;

  IncrementBloc() {
    _counter = 0;
    _actionController.stream
        .listen(_handleLogic);
  }

  @override
  void dispose() {
    _actionController.close();
    _counterController.close();
  }


  void _handleLogic(event) {
    _counter = _counter + 1;
    _inAdd.add(_counter);
  }
}