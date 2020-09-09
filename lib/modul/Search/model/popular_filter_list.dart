class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'اجانس',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'پارکینک',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'حوض',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'خواب گاه',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'وایرلس',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'همه',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'اپارتمان',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'خانه',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'زمین',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'دفتر',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'امبار',
      isSelected: false,
    ),
  ];
}