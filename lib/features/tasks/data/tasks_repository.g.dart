// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksRepositoryHash() => r'03b0f5c7367428c1b919ebfb8eb836381a64d799';

/// See also [tasksRepository].
@ProviderFor(tasksRepository)
final tasksRepositoryProvider = Provider<TasksRepository>.internal(
  tasksRepository,
  name: r'tasksRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tasksRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TasksRepositoryRef = ProviderRef<TasksRepository>;
String _$tasksQueryHash() => r'0de60d3d88530de394ed0f6cf04c8137046ea97a';

/// See also [tasksQuery].
@ProviderFor(tasksQuery)
final tasksQueryProvider = AutoDisposeProvider<Query<Task>>.internal(
  tasksQuery,
  name: r'tasksQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tasksQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TasksQueryRef = AutoDisposeProviderRef<Query<Task>>;
String _$taskStreamHash() => r'f85ac337670831426f8005d3f175463dedcf2ebc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [taskStream].
@ProviderFor(taskStream)
const taskStreamProvider = TaskStreamFamily();

/// See also [taskStream].
class TaskStreamFamily extends Family<AsyncValue<Task>> {
  /// See also [taskStream].
  const TaskStreamFamily();

  /// See also [taskStream].
  TaskStreamProvider call(
    String TaskId,
  ) {
    return TaskStreamProvider(
      TaskId,
    );
  }

  @override
  TaskStreamProvider getProviderOverride(
    covariant TaskStreamProvider provider,
  ) {
    return call(
      provider.TaskId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskStreamProvider';
}

/// See also [taskStream].
class TaskStreamProvider extends AutoDisposeStreamProvider<Task> {
  /// See also [taskStream].
  TaskStreamProvider(
    String TaskId,
  ) : this._internal(
          (ref) => taskStream(
            ref as TaskStreamRef,
            TaskId,
          ),
          from: taskStreamProvider,
          name: r'taskStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskStreamHash,
          dependencies: TaskStreamFamily._dependencies,
          allTransitiveDependencies:
              TaskStreamFamily._allTransitiveDependencies,
          TaskId: TaskId,
        );

  TaskStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.TaskId,
  }) : super.internal();

  final String TaskId;

  @override
  Override overrideWith(
    Stream<Task> Function(TaskStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskStreamProvider._internal(
        (ref) => create(ref as TaskStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        TaskId: TaskId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Task> createElement() {
    return _TaskStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskStreamProvider && other.TaskId == TaskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, TaskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskStreamRef on AutoDisposeStreamProviderRef<Task> {
  /// The parameter `TaskId` of this provider.
  String get TaskId;
}

class _TaskStreamProviderElement extends AutoDisposeStreamProviderElement<Task>
    with TaskStreamRef {
  _TaskStreamProviderElement(super.provider);

  @override
  String get TaskId => (origin as TaskStreamProvider).TaskId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
