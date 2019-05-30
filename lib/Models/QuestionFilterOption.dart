class QuestionFilterOption {
//  Product product;
  DateTime startTime;
  DateTime endTime;
  SearchType searchType;
  String searchText;

  QuestionFilterOption({
//    this.product,
    this.startTime,
    this.endTime,
    this.searchType = SearchType.ID,
    this.searchText,
  }) {
    if (startTime == null)
      startTime = DateTime.now().subtract(Duration(days: 30));
    if (endTime == null) endTime = DateTime.now();
  }
}

enum SearchType {
  ID,
  Title,
  Creator,
  EndUser,
  Content,
}
