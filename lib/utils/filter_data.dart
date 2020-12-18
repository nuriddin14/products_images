import 'package:flutter/cupertino.dart';

import '../constants.dart';

class FilterData {
  int unitId;
  int providerId;
  int saleTypeId;
  int categoryId;
  ImageFilterEnum imageFilterEnum;

  FilterData({
    @required this.unitId,
    @required this.providerId,
    @required this.categoryId,
    @required this.saleTypeId,
    @required this.imageFilterEnum,
  });
}
