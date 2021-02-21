import 'dart:convert';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSource dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setupMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  group('get concrete number trivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform GET request with number being endpoint & with application/json header',
        () async {
      //  arrange
      setupMockHttpClientSuccess();
      //  act
      dataSource.getConcreteNumberTrivia(tNumber);
      //  assert
      verify(
        mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {'Content-type': 'application/json'},
        ),
      );
    });

    test('should return number trivia when request is success', () async {
      //  arrange
      setupMockHttpClientSuccess();
      //  act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //  assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('get random number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform GET request for random number & with application/json header',
        () async {
      //  arrange
      setupMockHttpClientSuccess();
      //  act
      dataSource.getRandomNumberTrivia();
      //  assert
      verify(
        mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {'Content-type': 'application/json'},
        ),
      );
    });

    test('should return number trivia when request is success', () async {
      //  arrange
      setupMockHttpClientSuccess();
      //  act
      final result = await dataSource.getRandomNumberTrivia();
      //  assert
      expect(result, tNumberTriviaModel);
    });
  });
}
