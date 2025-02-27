enum SpargoSortType {
  ascending,
  descending,
}

class SpargoSortModel {
  const SpargoSortModel({required this.columnIndex, required this.type});
  final int columnIndex;
  final SpargoSortType type;
}
