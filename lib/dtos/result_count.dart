class ResultCount<T> {
  List<T> resultList;
  int count;

  ResultCount({required this.resultList, required this.count});

  factory ResultCount.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ResultCount(
        resultList: json['resultList'] == null ? [] : json['resultList'].map<T>((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
        count: json['count']
    );
  }
}
