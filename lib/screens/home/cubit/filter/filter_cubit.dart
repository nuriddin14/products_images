import 'package:cubit/cubit.dart';
import 'package:products_image/utils/filter_data.dart';

import '../../../../constants.dart';
import 'filter_state.dart';

FilterData filterData = FilterData(
    categoryId: 0,
    providerId: 0,
    saleTypeId: 0,
    unitId: 0,
    imageFilterEnum: ImageFilterEnum.allProducts);

class FiltersCubit extends Cubit<FiltersState> {
  FiltersCubit() : super(InitialState()) {
    _setFilterData();
  }

  saveFilterData(FilterData _filterData) async {
    filterData = _filterData;
  }

  deleteFilterData() {
    filterData = FilterData(
        categoryId: 0,
        providerId: 0,
        saleTypeId: 0,
        unitId: 0,
        imageFilterEnum: ImageFilterEnum.allProducts);
  }

  _setFilterData() {
    emit(SetFilterData(filterData));
  }
}
