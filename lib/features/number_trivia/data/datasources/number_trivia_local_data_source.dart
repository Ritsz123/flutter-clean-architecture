import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  //gets the last cached number trivia
  Future<NumberTriviaModel> getLastNumberTrivia();

  //cache the number trivia
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
