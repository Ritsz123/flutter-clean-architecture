import 'package:clean_flutter/core/error/exceptions.dart';
import 'package:clean_flutter/core/error/failures.dart';
import 'package:clean_flutter/core/network/NetworkInfo.dart';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_flutter/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repositoryImpl;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetWorkInfo networkInfo;

  runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetWorkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group(
    'getConcreteNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel(text: "test trivia", number: tNumber);
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the device is online',
        () async {
          //arrange
          when(networkInfo.isConnected).thenAnswer((_) async => true);
          //act
          repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(networkInfo.isConnected);
        },
      );

      runTestOnline(() {
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            //arrange
            when(remoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result =
                await repositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          'should cache the data when the call to remote data source is successful',
          () async {
            //arrange
            when(remoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTriviaModel);
            //act

            await repositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return serverException when the call to remote data source is unsuccessful',
          () async {
            //arrange
            when(remoteDataSource.getConcreteNumberTrivia(any))
                .thenThrow(ServerException());
            //act
            final result =
                await repositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyZeroInteractions(localDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      runTestOffline(() {
        setUp(
          () {
            when(networkInfo.isConnected).thenAnswer((_) async => false);
          },
        );
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            //arrange
            when(localDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result =
                await repositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verifyZeroInteractions(remoteDataSource);
            verify(localDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          'should return CacheFailure when there is no cached data present',
          () async {
            //arrange
            when(localDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result =
                await repositoryImpl.getConcreteNumberTrivia(tNumber);
            //assert
            verifyZeroInteractions(remoteDataSource);
            verify(localDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      });
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel(text: "test trivia", number: 1);
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the device is online',
        () async {
          //arrange
          when(networkInfo.isConnected).thenAnswer((_) async => true);
          //act
          repositoryImpl.getRandomNumberTrivia();
          //assert
          verify(networkInfo.isConnected);
        },
      );

      runTestOnline(() {
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            //arrange
            when(remoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await repositoryImpl.getRandomNumberTrivia();
            //assert
            verify(remoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          'should cache the data when the call to remote data source is successful',
          () async {
            //arrange
            when(remoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act

            await repositoryImpl.getRandomNumberTrivia();
            //assert
            verify(remoteDataSource.getRandomNumberTrivia());
            verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return serverException when the call to remote data source is unsuccessful',
          () async {
            //arrange
            when(remoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());
            //act
            final result = await repositoryImpl.getRandomNumberTrivia();
            //assert
            verify(remoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(localDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      runTestOffline(() {
        setUp(
          () {
            when(networkInfo.isConnected).thenAnswer((_) async => false);
          },
        );
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            //arrange
            when(localDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await repositoryImpl.getRandomNumberTrivia();
            //assert
            verifyZeroInteractions(remoteDataSource);
            verify(localDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          'should return CacheFailure when there is no cached data present',
          () async {
            //arrange
            when(localDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result = await repositoryImpl.getRandomNumberTrivia();
            //assert
            verifyZeroInteractions(remoteDataSource);
            verify(localDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      });
    },
  );
}
