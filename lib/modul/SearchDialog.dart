// import 'package:badam/model/city.dart';
// import 'package:flutter/material.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';

// class SearchDialog extends StatefulWidget {
//   @override
//   _SearchDialogState createState() => _SearchDialogState();
// }

// enum AimCharacter { buy, run, graw }
// enum TypeCharacter { all, land, home, unit, office, shop, apartment, vela }

// class _SearchDialogState extends State<SearchDialog> {

//   String leastMount = "";
//   String lastMount = "";
//   String leastMeter = "";
//   String lastMeter = "";
//   String selectedValue = "";

//   CityList cityList;
//   final List<DropdownMenuItem> items = [];

//   @override
//   void initState() {
//     CityList.list.forEach((word) {
//       items.add(DropdownMenuItem(
//         child: Text(word.toString()),
//         value: word.toString(),
//       ));
//     });
//     super.initState();
//   }

//   AimCharacter _aim = AimCharacter.buy;
//   TypeCharacter _typeProperty = TypeCharacter.all;

//   void searchString() {
//     String mainSearchQuery = "";
//     if (_aim == AimCharacter.buy) {
//       mainSearchQuery += "?property-statuses=31";
//     } else if (_aim == AimCharacter.graw) {
//       mainSearchQuery += "?property-statuses=32";
//     } else if (_aim == AimCharacter.run) {
//       mainSearchQuery += "?property-statuses=30";
//     }
//     if (_typeProperty == TypeCharacter.all) {
//     } else if (_typeProperty == TypeCharacter.apartment) {
//       mainSearchQuery += "&property-types=48";
//     } else if (_typeProperty == TypeCharacter.home) {
//       mainSearchQuery += "&property-types=67";
//     } else if (_typeProperty == TypeCharacter.office) {
//       mainSearchQuery += "&property-types=40";
//     } else if (_typeProperty == TypeCharacter.shop) {
//       mainSearchQuery += "&property-types=43";
//     } else if (_typeProperty == TypeCharacter.land) {
//       mainSearchQuery += "&property-types=65";
//     } else if (_typeProperty == TypeCharacter.unit) {
//       mainSearchQuery += "&property-types=47";
//     } else if (_typeProperty == TypeCharacter.vela) {
//       mainSearchQuery += "&property-types=46";
//     }

//     if (lastMount != "" && leastMount != "") {
//       mainSearchQuery +=
//           "&filter[meta_query][0][key]=REAL_HOMES_property_price&filter[meta_query][0][value][0]=" +
//               leastMount +
//               "&filter[meta_query][0][value][1]=" +
//               lastMount +
//               "&filter[meta_query][0][compare]=BETWEEN&filter[meta_query][0][type]=numeric";
//     }
//     if (lastMeter != "" && leastMeter != "") {
//       mainSearchQuery +=
//           "&filter[meta_query][1][key]=REAL_HOMES_property_size&filter[meta_query][1][value][0]=" +
//               leastMeter +
//               "&filter[meta_query][1][value][1]=" +
//               lastMeter +
//               "&filter[meta_query][1][compare]=BETWEEN&filter[meta_query][1][type]=numeric";
//     }
//     print(selectedValue);
//     if (selectedValue != "") {
//       mainSearchQuery +=
//           "&property-cities=" + CityList.getKeylist(selectedValue);
//     }

//     Navigator.pop(context, mainSearchQuery);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("فلتر کردن املاک"),
//         leading: FlatButton(
//             onPressed: () => Navigator.pop(context),
//             child: Icon(
//               Icons.close,
//               color: Colors.white,
//               size: 28,
//             )),
//       ),
//       body: Center(
//         child: ListView(
//           children: <Widget>[
//             ListTile(
//               title: Text("هدف"),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Text('کرایی'),
//                     Radio(
//                       value: AimCharacter.run,
//                       groupValue: _aim,
//                       onChanged: (AimCharacter value) {
//                         setState(() {
//                           _aim = value;
//                         });
//                       },
//                     )
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('فروشی'),
//                     Radio(
//                       value: AimCharacter.buy,
//                       groupValue: _aim,
//                       onChanged: (AimCharacter value) {
//                         setState(() {
//                           _aim = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('گروه'),
//                     Radio(
//                       value: AimCharacter.graw,
//                       groupValue: _aim,
//                       onChanged: (AimCharacter value) {
//                         setState(() {
//                           _aim = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             ListTile(
//               title: Text("مکان ملک"),
//             ),
//             SearchableDropdown.single(
//               items: items,
//               value: selectedValue,
//               hint: "شهر مورد نظر را انتخاب کنید",
//               searchHint: "لیست شهر ها",
//               onChanged: (value) {
//                 setState(() {
//                   selectedValue = value;
//                 });
//               },
//               doneButton: "انتخاب",
//               displayItem: (item, selected) {
//                 return (Row(children: [
//                   selected
//                       ? Icon(
//                           Icons.radio_button_checked,
//                           color: Colors.grey,
//                         )
//                       : Icon(
//                           Icons.radio_button_unchecked,
//                           color: Colors.grey,
//                         ),
//                   SizedBox(width: 7),
//                   Expanded(
//                     child: item,
//                   ),
//                 ]));
//               },
//               isExpanded: true,
//             ),
//             ListTile(
//               title: Text("نوعیت ملک"),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Text('ّهمه'),
//                     Radio(
//                       value: TypeCharacter.all,
//                       groupValue: _typeProperty,
//                       onChanged: (TypeCharacter value) {
//                         setState(() {
//                           _typeProperty = value;
//                         });
//                       },
//                     )
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('زمین'),
//                     Radio(
//                       value: TypeCharacter.land,
//                       groupValue: _typeProperty,
//                       onChanged: (TypeCharacter value) {
//                         setState(() {
//                           _typeProperty = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('خانه'),
//                     Radio(
//                       value: TypeCharacter.home,
//                       groupValue: _typeProperty,
//                       onChanged: (TypeCharacter value) {
//                         setState(() {
//                           _typeProperty = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('دفتر'),
//                     Radio(
//                       value: TypeCharacter.office,
//                       groupValue: _typeProperty,
//                       onChanged: (TypeCharacter value) {
//                         setState(() {
//                           _typeProperty = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Text('دوکان'),
//                     Radio(
//                       value: TypeCharacter.shop,
//                       groupValue: _typeProperty,
//                       onChanged: (TypeCharacter value) {
//                         setState(() {
//                           _typeProperty = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('واحد'),
//                     Radio(
//                       value: TypeCharacter.unit,
//                       groupValue: _typeProperty,
//                       onChanged: (TypeCharacter value) {
//                         setState(() {
//                           _typeProperty = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('اپارتمان'),
//                     Radio(
//                       value: TypeCharacter.apartment,
//                       groupValue: _typeProperty,
//                       onChanged: (TypeCharacter value) {
//                         setState(() {
//                           _typeProperty = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('ویلا'),
//                     Radio(
//                       value: TypeCharacter.vela,
//                       groupValue: _typeProperty,
//                       onChanged: (TypeCharacter value) {
//                         setState(() {
//                           _typeProperty = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             ListTile(
//               title: Text("قمیت ملک ( افغانی ) "),
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     child: TextField(
//                       onChanged: (value) {
//                         leastMount = value;
//                       },
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         hintText: 'کمترین مقدار',
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     child: TextField(
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         lastMount = value;
//                       },
//                       decoration: const InputDecoration(
//                         hintText: 'بیشترین مقدار',
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             ListTile(
//               title: Text("متراژ ( متر مربع ) "),
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     child: TextField(
//                       onChanged: (value) {
//                         leastMeter = value;
//                       },
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         hintText: 'کمترین مقدار',
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     child: TextField(
//                       onChanged: (value) {
//                         lastMeter = value;
//                       },
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         hintText: 'بیشترین مقدار',
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               width: 100,
//               padding: EdgeInsets.all(10),
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(30),
//                   ),
//                 ),
//                 child: FlatButton(
//                   onPressed: searchString,
//                   child: Text(
//                     "حستجو",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // http://192.168.43.186/sanhome/wp-json/wp/v2/properties?filter[meta_query][0][key]=REAL_HOMES_property_price&filter[meta_query][0][value][0]=10&filter[meta_query][0][value][1]=3000&filter[meta_query][0][compare]=BETWEEN&filter[meta_query][0][type]=numeric
// // http://192.168.43.186/sanhome/wp-json/wp/v2/properties?title=hello&content=test contect&property_meta[REAL_HOMES_property_price]=10000

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Search/RangeSliderView.dart';
import 'Search/hotel_app_theme.dart';
import 'Search/model/popular_filter_list.dart';
import 'Search/slider_view.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<PopularFilterListData> accomodationListData =
      PopularFilterListData.accomodationList;

  RangeValues _values = const RangeValues(100, 600);
  double distValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    priceBarFilter(),
                    const Divider(
                      height: 1,
                    ),
                    popularFilter(),
                    const Divider(
                      height: 1,
                    ),
                    distanceViewUI(),
                    const Divider(
                      height: 1,
                    ),
                    allAccommodationUI()
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'فلتر کردن',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget allAccommodationUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'نوعیت ملک',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getAccomodationListUI(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  List<Widget> getAccomodationListUI() {
    final List<Widget> noList = <Widget>[];
    for (int i = 0; i < accomodationListData.length; i++) {
      final PopularFilterListData date = accomodationListData[i];
      noList.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            onTap: () {
              setState(() {
                checkAppPosition(i);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      date.titleTxt,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: date.isSelected
                        ? HotelAppTheme.buildLightTheme().primaryColor
                        : Colors.grey.withOpacity(0.6),
                    onChanged: (bool value) {
                      setState(() {
                        checkAppPosition(i);
                      });
                    },
                    value: date.isSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      if (i == 0) {
        noList.add(const Divider(
          height: 1,
        ));
      }
    }
    return noList;
  }

  void checkAppPosition(int index) {
    if (index == 0) {
      if (accomodationListData[0].isSelected) {
        accomodationListData.forEach((d) {
          d.isSelected = false;
        });
      } else {
        accomodationListData.forEach((d) {
          d.isSelected = true;
        });
      }
    } else {
      accomodationListData[index].isSelected =
          !accomodationListData[index].isSelected;

      int count = 0;
      for (int i = 0; i < accomodationListData.length; i++) {
        if (i != 0) {
          final PopularFilterListData data = accomodationListData[i];
          if (data.isSelected) {
            count += 1;
          }
        }
      }

      if (count == accomodationListData.length - 1) {
        accomodationListData[0].isSelected = true;
      } else {
        accomodationListData[0].isSelected = false;
      }
    }
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'فاصله از مرگز شهر',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
          distValue: distValue,
          onChangedistValue: (double value) {
            distValue = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'فلتر ها',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < popularFilterListData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final PopularFilterListData date = popularFilterListData[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            date.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: date.isSelected
                                ? HotelAppTheme.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            date.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < popularFilterListData.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'قمیت ',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView(
          values: _values,
          onChangeRangeValues: (RangeValues values) {
            _values = values;
          },
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            ),
            Expanded(
              child: Center(
                child: Text(
                  'فلتر ها',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
