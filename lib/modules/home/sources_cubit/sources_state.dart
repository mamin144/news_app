part of 'sources_cubit.dart';

@immutable
sealed class SourcesState {}

final class SourcesInitial extends SourcesState {}

final class SourcesLoading extends SourcesState{}

final class SourcesLoaded extends SourcesState{
  final SourcesResponse sources;
  SourcesLoaded(this.sources);
}

final class SourcesError extends SourcesState{}
