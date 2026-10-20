import 'package:flutter/material.dart';
import 'icon_code.dart';

class IconMapper {
  static Map<IconCode, IconData> iconMapper = {
    IconCode.cosmetics : Icons.color_lens_rounded,
    IconCode.generalExp : Icons.wallet,
    IconCode.medicalExp : Icons.medical_services_rounded,
    IconCode.shopping : Icons.shopping_basket,
    IconCode.snack : Icons.fastfood,
    IconCode.transpotation : Icons.train
  };

  static IconData icon(String iconCode) => iconMapper[_finder(iconCode)]!;
  static IconData iconFromIconCode(IconCode iconCode) => iconMapper[iconCode]!;

  static IconCode _finder(String iconCode){
    IconCode gic = IconCode.generalExp;
    for (IconCode ic in IconCode.values) {
      if(iconCode == ic.name){
        gic = ic;
        break;
      }
    }
    return gic;
  }
  
}


