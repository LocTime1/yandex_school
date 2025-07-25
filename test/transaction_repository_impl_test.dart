import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:yandex_homework_1/data/repositories/transaction_repository_impl.dart';
import 'package:yandex_homework_1/data/datasources/hive_transaction_ds.dart';
import 'package:yandex_homework_1/data/repositories/api_transaction_repository.dart';
import 'package:yandex_homework_1/data/datasources/backup_ds.dart';
import 'package:yandex_homework_1/domain/entities/transaction.dart';

@GenerateMocks([
  HiveTransactionDataSource,
  ApiTransactionRepository,
  BackupDataSource,
])
import 'transaction_repository_impl_test.mocks.dart';

void main() {
  late MockHiveTransactionDataSource local;
  late MockApiTransactionRepository remote;
  late MockBackupDataSource backup;
  late TransactionRepositoryImpl repo;

  final testTx = AppTransaction(
    id: 1,
    accountId: 5,
    categoryId: 6,
    amount: 10.0,
    transactionDate: DateTime(2024, 7, 19),
    comment: 'Test',
    createdAt: DateTime(2024, 7, 19),
    updatedAt: DateTime(2024, 7, 19),
  );

  setUp(() {
    local = MockHiveTransactionDataSource();
    remote = MockApiTransactionRepository();
    backup = MockBackupDataSource();
    repo = TransactionRepositoryImpl(
      local: local,
      remote: remote,
      backup: backup,
    );
  });

  test(
    'getTransactionsByAccountPeriod возвращает данные из remote при успехе',
    () async {
      final remoteList = [testTx];

      when(backup.syncPending(any, any)).thenAnswer((_) async {});
      when(
        remote.getTransactionsByAccountPeriod(
          accountId: 5,
          from: anyNamed('from'),
          to: anyNamed('to'),
        ),
      ).thenAnswer((_) async => remoteList);
      when(local.boxClearAndPutAll(remoteList)).thenAnswer((_) async {});

      final result = await repo.getTransactionsByAccountPeriod(
        accountId: 5,
        from: DateTime(2024, 7, 1),
        to: DateTime(2024, 7, 31),
      );

      expect(result, remoteList);
      verify(local.boxClearAndPutAll(remoteList)).called(1);
    },
  );

  test(
    'getTransactionsByAccountPeriod бросает OfflineException и возвращает локальные данные при ошибке remote',
    () async {
      final localList = [testTx];

      when(backup.syncPending(any, any)).thenAnswer((_) async {});
      when(
        remote.getTransactionsByAccountPeriod(
          accountId: 5,
          from: anyNamed('from'),
          to: anyNamed('to'),
        ),
      ).thenThrow(Exception('offline'));
      when(local.getAll()).thenAnswer((_) async => localList);

      expect(
        () => repo.getTransactionsByAccountPeriod(
          accountId: 5,
          from: DateTime(2024, 7, 1),
          to: DateTime(2024, 7, 31),
        ),
        throwsA(isA<OfflineException>()),
      );
    },
  );

  test(
    'getTransactionById возвращает локальную транзакцию если она есть',
    () async {
      when(local.getById(1)).thenAnswer((_) async => testTx);

      final result = await repo.getTransactionById(1);

      expect(result, testTx);
      verify(local.getById(1)).called(1);
      verifyNever(remote.getTransactionById(any));
    },
  );

  test(
    'getTransactionById получает из remote и кеширует когда локали нет',
    () async {
      when(local.getById(1)).thenAnswer((_) async => null);
      when(remote.getTransactionById(1)).thenAnswer((_) async => testTx);
      when(local.put(testTx)).thenAnswer((_) async => {});

      final result = await repo.getTransactionById(1);

      expect(result, testTx);
      verify(local.put(testTx)).called(1);
    },
  );

  test(
    'createTransaction возвращает созданную транзакцию из remote и синхронизирует локально и backup',
    () async {
      final createdTx = testTx.copyWith(id: 2);

      when(local.put(testTx)).thenAnswer((_) async => {});
      when(backup.addCreateOperation(testTx)).thenAnswer((_) async => {});
      when(remote.createTransaction(testTx)).thenAnswer((_) async => createdTx);
      when(local.delete(testTx.id)).thenAnswer((_) async => {});
      when(local.put(createdTx)).thenAnswer((_) async => {});
      when(backup.removeCreateOperation(testTx.id)).thenAnswer((_) async => {});

      final result = await repo.createTransaction(testTx);

      expect(result, createdTx);
      verify(local.put(testTx)).called(1);
      verify(backup.addCreateOperation(testTx)).called(1);
      verify(remote.createTransaction(testTx)).called(1);
      verify(local.delete(testTx.id)).called(1);
      verify(local.put(createdTx)).called(1);
      verify(backup.removeCreateOperation(testTx.id)).called(1);
    },
  );

  test(
    'createTransaction возвращает оригинальную транзакцию при ошибке remote',
    () async {
      when(local.put(testTx)).thenAnswer((_) async => {});
      when(backup.addCreateOperation(testTx)).thenAnswer((_) async => {});
      when(remote.createTransaction(testTx)).thenThrow(Exception('offline'));

      final result = await repo.createTransaction(testTx);

      expect(result, testTx);
    },
  );

  test(
    'updateTransaction возвращает обновлённую транзакцию из remote и синхронизирует backup',
    () async {
      final updatedTx = testTx.copyWith(comment: 'updated');

      when(local.put(testTx)).thenAnswer((_) async => {});
      when(backup.addUpdateOperation(testTx)).thenAnswer((_) async => {});
      when(remote.updateTransaction(testTx)).thenAnswer((_) async => updatedTx);
      when(local.put(updatedTx)).thenAnswer((_) async => {});
      when(backup.removeUpdateOperation(testTx.id)).thenAnswer((_) async => {});

      final result = await repo.updateTransaction(testTx);

      expect(result, updatedTx);
      verify(local.put(testTx)).called(1);
      verify(backup.addUpdateOperation(testTx)).called(1);
      verify(remote.updateTransaction(testTx)).called(1);
      verify(local.put(updatedTx)).called(1);
      verify(backup.removeUpdateOperation(testTx.id)).called(1);
    },
  );

  test(
    'deleteTransaction удаляет локально и синхронизирует backup после удаления на remote',
    () async {
      when(local.delete(1)).thenAnswer((_) async => {});
      when(backup.addDeleteOperation(1)).thenAnswer((_) async => {});
      when(remote.deleteTransaction(1)).thenAnswer((_) async => {});
      when(backup.removeDeleteOperation(1)).thenAnswer((_) async => {});

      await repo.deleteTransaction(1);

      verify(local.delete(1)).called(1);
      verify(backup.addDeleteOperation(1)).called(1);
      verify(remote.deleteTransaction(1)).called(1);
      verify(backup.removeDeleteOperation(1)).called(1);
    },
  );
}
