

class CityList {
  int number;
  static final Map<int, String> map = {
    66: "هرات",
    38: "کابل",
    41: "بلخ",
    51: "قندهار",
    50: "ننگرهار"
  };

  String get numberString {
    return (map.containsKey(number) ? map[number] : "unknown");
  }

  CityList(this.number);

  String toString() {
    return (" $numberString");
  }

  static List<CityList> get list {
    return (map.keys.map((num) {
      return (CityList(num));
    })).toList();
  }

  static String getKeylist(value) {
    String result = "";

    (map.keys.map((num) {

        (CityList(num)).toString() == value.toString() ? result = num.toString() : "";

    })).toList();

    return result;
  }
}
