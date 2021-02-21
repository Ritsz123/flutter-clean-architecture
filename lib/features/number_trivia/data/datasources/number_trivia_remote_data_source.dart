import 'dart:convert';

import 'package:clean_flutter/core/error/exceptions.dart';
import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  ///calls http://numbersapi.com/{number} endpoint
  ///server exception for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  ///calls http://numbersapi.com/random endpoint
  ///server exception for all other error
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response =
        await client.get(url, headers: {'Content-type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
