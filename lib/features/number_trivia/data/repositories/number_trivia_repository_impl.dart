import 'package:clean_flutter/core/error/exceptions.dart';
import 'package:clean_flutter/core/error/failures.dart';
import 'package:clean_flutter/core/network/NetworkInfo.dart';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

typedef _concreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  //actual working function
  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _concreteOrRandomChooser getConcreteOrRandomTrivia,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandomTrivia();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
