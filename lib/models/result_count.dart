
class ResultCount<T> {
  List<T> resultList;
  int count;

  ResultCount({required this.resultList, required this.count});

  factory ResultCount.fromJson(Map<String, dynamic> json) {
    return ResultCount(
        resultList: List<T>.from(json['resultList']),
        count: int.parse(json['count'])
    );
  }
}