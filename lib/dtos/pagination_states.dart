class PaginationStates {
  final int range;
  final int limit;
  final int currentPage;
  final int count;
  final String path;
  final Map<String, dynamic> params;

  PaginationStates({
    required this.range,
    required this.limit,
    required this.currentPage,
    required this.count,
    required this.path,
    required this.params,
  });
}