part of 'search_bloc.dart';

@immutable
sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPostsEvent extends SearchEvent {
  final String fieldSearch;
  final String searchContent;
  final String sort;
  final String sortField;
  final String page;
  final int? limit;

  const LoadPostsEvent({
    required this.fieldSearch,
    required this.searchContent,
    required this.sort,
    required this.sortField,
    required this.page,
    required this.limit
  });

  @override
  List<Object?> get props => [fieldSearch, searchContent, sort, sortField, page, limit];
}

final class LoadSeriesEvent extends SearchEvent {
  final String fieldSearch;
  final String searchContent;
  final String sort;
  final String sortField;
  final String page;
  final int? limit;

  const LoadSeriesEvent({
    required this.fieldSearch,
    required this.searchContent,
    required this.sort,
    required this.sortField,
    required this.page,
    required this.limit
  });

  @override
  List<Object?> get props => [fieldSearch, searchContent, sort, sortField, page, limit];
}