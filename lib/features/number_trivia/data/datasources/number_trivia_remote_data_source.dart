import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  ///calls http://numbersapi.com/{number} endpoint
  ///server exception for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  ///calls http://numbersapi.com/random endpoint
  ///server exception for all other error
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
