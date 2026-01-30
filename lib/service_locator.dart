import 'package:todoon/routes/app_exports.dart';

final sl = GetIt.asNewInstance();

Future<void> configureDependencies({
  bool isFirebaseEmulator = true,
  emulatorHost = '192.168.1.5',
}) async {
  // == Core ==
  sl.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(InternetConnectionChecker.instance),
  );
  // == Firebase ==
  sl.registerSingletonAsync<FirebaseAuthService>(
    () async => await FirebaseAuthService.init(
      useEmulator: isFirebaseEmulator,
      emulatorHost: emulatorHost,
    ),
  );
  sl.registerSingletonAsync<FirestoreService>(
    () async => await FirestoreService.init(
      useEmulator: isFirebaseEmulator,
      emulatorHost: emulatorHost,
    ),
  );
  // == Hives ===
  sl.registerSingletonAsync<HiveService>(() async => await HiveService.init());
  // Tag
  sl.registerSingletonAsync<TagLocalDataSource>(
    () async => TagLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<TagRemoteDataSource>(
    () async => TagRemoteDataSourceImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
    ),
    dependsOn: [HiveService],
  );
  // Note
  sl.registerSingletonAsync<NoteLocalDataSource>(
    () async => NoteLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<NoteRemoteDataSource>(
    () async => NoteRemoteDataSourceImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
    ),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<NoteTagLocalDataSource>(
    () async => NoteTagLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<NoteTagRemoteDataSource>(
    () async => NoteTagRemoteDataSourceImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
    ),
    dependsOn: [HiveService],
  );
  // Todo
  sl.registerSingletonAsync<TodoLocalDataSource>(
    () async => TodoLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<TodoRemoteDataSource>(
    () async => TodoRemoteDataSourceImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
    ),
    dependsOn: [HiveService],
  );
  // Todo List
  sl.registerSingletonAsync<TodoListLocalDataSource>(
    () async => TodoListLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<TodoListRemoteDataSource>(
    () async => TodoListRemoteDataSourceImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
    ),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<TodoTagLocalDataSource>(
    () async => TodoTagLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<TodoTagRemoteDataSource>(
    () async => TodoTagRemoteDataSourceImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
    ),
    dependsOn: [HiveService],
  );
  // Plan
  sl.registerSingletonAsync<PlanLocalDataSource>(
    () async => PlanLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<PlanRemoteDataSource>(
    () async => PlanRemoteDataSourceImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
    ),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<PlanBlockLocalDataSource>(
    () async => PlanBlockLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<PlanBlockRemoteDataSource>(
    () async => PlanBlockRemoteDataSourceImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
    ),
    dependsOn: [HiveService],
  );

  // == Repositories ==
  sl.registerSingletonAsync<AuthRepository>(
    () async => AuthRepositoryImpl(
      sl.get<FirebaseAuthService>(),
      sl.get<FirestoreService>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [FirebaseAuthService, FirestoreService],
  );
  // Tag
  sl.registerSingletonAsync<TagRepository>(
    () async => TagRepositoryImpl(
      sl.get<TagLocalDataSource>(),
      sl.get<TagRemoteDataSource>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [TagLocalDataSource, TagRemoteDataSource],
  );
  // Note
  sl.registerSingletonAsync<NoteRepository>(
    () async => NoteRepositoryImpl(
      sl.get<NoteLocalDataSource>(),
      sl.get<NoteRemoteDataSource>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [NoteLocalDataSource, NoteRemoteDataSource],
  );
  sl.registerSingletonAsync<NoteTagRepository>(
    () async => NoteTagRepositoryImpl(
      sl.get<NoteTagLocalDataSource>(),
      sl.get<NoteTagRemoteDataSource>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [NoteTagLocalDataSource, NoteTagRemoteDataSource],
  );
  // Todo
  sl.registerSingletonAsync<TodoRepository>(
    () async => TodoRepositoryImpl(
      sl.get<TodoLocalDataSource>(),
      sl.get<TodoRemoteDataSource>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [TodoLocalDataSource, TodoRemoteDataSource],
  );
  // Todo List
  sl.registerSingletonAsync<TodoListRepository>(
    () async => TodoListRepositoryImpl(
      sl.get<TodoListLocalDataSource>(),
      sl.get<TodoListRemoteDataSource>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [TodoListLocalDataSource, TodoListRemoteDataSource],
  );
  sl.registerSingletonAsync<TodoListTagRepository>(
    () async => TodoListTagRepositoryImpl(
      sl.get<TodoTagLocalDataSource>(),
      sl.get<TodoTagRemoteDataSource>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [TodoTagLocalDataSource, TodoTagRemoteDataSource],
  );
  // Plan
  sl.registerSingletonAsync<PlanRepository>(
    () async => PlanRepositoryImpl(
      sl.get<PlanLocalDataSource>(),
      sl.get<PlanRemoteDataSource>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [PlanLocalDataSource, PlanRemoteDataSource],
  );
  sl.registerSingletonAsync<PlanBlockRepository>(
    () async => PlanBlockRepositoryImpl(
      sl.get<PlanBlockLocalDataSource>(),
      sl.get<PlanBlockRemoteDataSource>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [PlanBlockLocalDataSource, PlanBlockRemoteDataSource],
  );

  // == Sync ==
  // PendingActionReducer
  sl.registerSingletonAsync<PendingActionLocalDataSource>(
    () async => PendingActionLocalDataSourceImpl(sl.get<HiveService>()),
    dependsOn: [HiveService],
  );
  sl.registerSingletonAsync<PendingActionReducer>(
    () async => PendingActionReducerImpl(
      sl.get<NoteTagRemoteDataSource>(),
      sl.get<TodoTagRemoteDataSource>(),
      sl.get<TodoRemoteDataSource>(),
      sl.get<PlanBlockRepository>(),
    ),
    dependsOn: [
      NoteTagRemoteDataSource,
      TodoTagRemoteDataSource,
      TodoRemoteDataSource,
      PlanBlockRepository,
    ],
  );
  sl.registerSingletonAsync<PendingActionSyncService>(
    () async => PendingActionSyncService(
      sl.get<PendingActionLocalDataSource>(),
      sl.get<PendingActionReducer>(),
      sl.get<NetworkInfo>(),
    ),
    dependsOn: [PendingActionLocalDataSource, PendingActionReducer],
  );

  // Bootstrap
  sl.registerSingletonAsync<AppBootstrapService>(
    () async => AppBootstrapService(sl.get<PlanLocalDataSource>()),
    dependsOn: [PlanLocalDataSource],
  );

  // == AppSync ==
  // Tag
  sl.registerSingletonAsync<TagSyncService>(
    () async => TagSyncService(
      sl.get<TagLocalDataSource>(),
      sl.get<TagRemoteDataSource>(),
    ),
    dependsOn: [TagLocalDataSource, TagRemoteDataSource],
  );
  // Note
  sl.registerSingletonAsync<NoteSyncService>(
    () async => NoteSyncService(
      sl.get<NoteLocalDataSource>(),
      sl.get<NoteRemoteDataSource>(),
    ),
    dependsOn: [NoteLocalDataSource, NoteRemoteDataSource],
  );
  sl.registerSingletonAsync<NoteTagSyncService>(
    () async => NoteTagSyncService(
      sl.get<NoteTagLocalDataSource>(),
      sl.get<NoteTagRemoteDataSource>(),
    ),
    dependsOn: [NoteTagLocalDataSource, NoteTagRemoteDataSource],
  );
  // Todo
  sl.registerSingletonAsync<TodoSyncService>(
    () async => TodoSyncService(
      sl.get<TodoLocalDataSource>(),
      sl.get<TodoRemoteDataSource>(),
    ),
    dependsOn: [TodoLocalDataSource, TodoRemoteDataSource],
  );
  // TodoList
  sl.registerSingletonAsync<TodoListSyncService>(
    () async => TodoListSyncService(
      sl.get<TodoListLocalDataSource>(),
      sl.get<TodoListRemoteDataSource>(),
    ),
    dependsOn: [TodoListLocalDataSource, TodoListRemoteDataSource],
  );
  sl.registerSingletonAsync<TodoTagSyncService>(
    () async => TodoTagSyncService(
      sl.get<TodoTagLocalDataSource>(),
      sl.get<TodoTagRemoteDataSource>(),
    ),
    dependsOn: [TodoTagLocalDataSource, TodoTagRemoteDataSource],
  );
  // Plan
  sl.registerSingletonAsync<PlanSyncService>(
    () async => PlanSyncService(
      sl.get<PlanLocalDataSource>(),
      sl.get<PlanRemoteDataSource>(),
    ),
    dependsOn: [PlanLocalDataSource, PlanRemoteDataSource],
  );
  sl.registerSingletonAsync<PlanBlockSyncService>(
    () async => PlanBlockSyncService(
      sl.get<PlanBlockLocalDataSource>(),
      sl.get<PlanBlockRemoteDataSource>(),
    ),
    dependsOn: [PlanBlockLocalDataSource, PlanBlockRemoteDataSource],
  );

  sl.registerSingletonAsync<AppSyncService>(
    () async => AppSyncService(sl.get<NetworkInfo>(), [
      sl.get<TagSyncService>(),
      sl.get<NoteSyncService>(),
      sl.get<NoteTagSyncService>(),
      sl.get<TodoSyncService>(),
      sl.get<TodoListSyncService>(),
      sl.get<TodoTagSyncService>(),
      sl.get<PlanSyncService>(),
      sl.get<PlanBlockSyncService>(),
      sl.get<PendingActionSyncService>(),
    ]),
    dependsOn: [
      TagSyncService,
      NoteSyncService,
      NoteTagSyncService,
      TodoSyncService,
      TodoListSyncService,
      TodoTagSyncService,
      PlanSyncService,
      PlanBlockSyncService,
      PendingActionSyncService,
    ],
  );

  // == Wating all ready ==
  await sl.allReady();
}
