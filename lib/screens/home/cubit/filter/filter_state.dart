import 'package:equatable/equatable.dart';
import 'package:products_image/utils/filter_data.dart';

abstract class FiltersState extends Equatable {}

class InitialState extends FiltersState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class SetFilterData extends FiltersState {
  final FilterData filterData;
  SetFilterData(this.filterData);
  @override
  List<Object> get props => [filterData];
}
