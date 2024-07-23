
import 'package:complete_advanced_flutter_app/data/mapper/mapper.dart';

///extension on String

extension NonNullString on String?{
  String orEmpty(){
    if(this == null){
      return EMPTY;
    }
    else{
      return this!;
    }
  }
}

///extension on Integer

extension NonNullInteger on int?{
  int orZero(){
    if(this == null){
      return ZERO;
    }
    else{
      return this!;
    }
  }
}


