import 'package:clean_flutter/core/error/failures.dart';
import 'package:clean_flutter/core/usecases/usecase.dart';
import 'package:clean_flutter/core/util/input_converter.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia concreteNumberTrivia;
  MockRandomNumberTrivia randomNumberTrivia;
  MockInputConverter inputConverter;

  setUp(() {
    concreteNumberTrivia = MockGetConcreteNumberTrivia();
    randomNumberTrivia = MockRandomNumberTrivia();
    inputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: concreteNumberTrivia,
      getRandomNumberTrivia: randomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('Initial state should be empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTrivia for concrete number', () {
    final tNumberString = "1";
    final tNumber = 1;
    final tNumberTrivia = new NumberTrivia(text: "test trivia", number: 1);

    voidSetupMockInputConverterSuccess() {
      when(inputConverter.stringToUnsignedInt(any)).thenReturn(Right(tNumber));
    }

    test(
      'should call the input converter to validate and convert the string to integer',
      () async {
        // arrange
        voidSetupMockInputConverterSuccess();
        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(inputConverter.stringToUnsignedInt(any));
        //assert
        verify(inputConverter.stringToUnsignedInt(tNumberString));
      },
    );

    test(
      'should emit [ErrorState] when the input is invalid',
      () async {
        // arrange
        when(inputConverter.stringToUnsignedInt(any))
            .thenReturn(Left(InvalidInputFailure()));
        //assert later
        final expected = [
          Error(message: INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        voidSetupMockInputConverterSuccess();
        when(concreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(concreteNumberTrivia(any));

        //  assert
        verify(concreteNumberTrivia(Params(number: tNumber)));
      },
    );

    test(
      'should emit [loading] & [loaded] when data loaded success',
      () async {
        // arrange
        voidSetupMockInputConverterSuccess();
        when(concreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //  assert later
        final expected = [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [loading] & [error] when data loading fails',
      () async {
        // arrange
        voidSetupMockInputConverterSuccess();
        when(concreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        //  assert later
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTrivia for Random number', () {
    final tNumberTrivia = new NumberTrivia(text: "test trivia", number: 1);

    test(
      'should get data from the random use case',
      () async {
        // arrange

        when(randomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(randomNumberTrivia(any));

        //  assert
        verify(randomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [loading] & [loaded] when data loaded success',
      () async {
        // arrange
        when(randomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //  assert later
        final expected = [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [loading] & [error] when data loading fails',
      () async {
        // arrange
        when(randomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        //  assert later
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));

        //act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
