import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_flutter/core/util/input_converter.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = "SERVER FAILURE";
const String CACHE_FAILURE_MESSAGE = "cache failure";
const String INPUT_FAILURE_MESSAGE = "Invalid Input";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required this.getConcreteNumberTrivia,
    @required this.getRandomNumberTrivia,
    @required this.inputConverter,
  }) : super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInt(event.numberString);
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INPUT_FAILURE_MESSAGE);
        },
        (integer) => throw UnimplementedError(),
      );
    }
  }
}
