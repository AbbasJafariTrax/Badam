class PropertyType{

  static final  Map<int,String> propertyType ={

    65:"land",
    67:"home",
    47:"unit",
    40:"office",
    43:"shop",
    48:"apartment",
    46:"vela",
  };

  static List get list {
      return (propertyType.keys.map((num) {
        return (propertyType[num]);
      })).toList();
    }

  
}