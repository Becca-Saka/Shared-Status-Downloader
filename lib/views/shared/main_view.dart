// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:mycustomers/core/models/store.dart';
// import 'package:mycustomers/core/extensions/string_extension.dart';
// import 'package:mycustomers/ui/shared/const_color.dart';
// import 'package:mycustomers/ui/shared/const_widget.dart';
// import 'package:mycustomers/ui/shared/size_config.dart';
// import 'package:mycustomers/ui/theme/theme_viewmodel.dart';
// import 'package:mycustomers/ui/views/business/business_home_page/business_homepage_view.dart';
// import 'package:mycustomers/ui/views/customer/customer_homepage/customer_home_view.dart';
// import 'package:mycustomers/ui/views/home/home_page/home_page_view.dart';
// import 'package:mycustomers/ui/views/marketing/marketing_home_page/marketing_homepage_view.dart';
// import 'package:mycustomers/ui/widgets/shared/partial_build.dart';
// import 'package:mycustomers/ui/widgets/stateful/lazy_index_stacked.dart';
// import 'package:stacked/stacked.dart';
// import 'package:stacked_hooks/stacked_hooks.dart';
// import 'package:mycustomers/core/localization/app_localization.dart';

// import 'main_view_model.dart';

// part '../../widgets/main/main_menu.dart';

// part '../../widgets/main/business_menu.dart';

// part '../../widgets/main/menu_buttons.dart';

// part '../../widgets/main/main_header.dart';

// class MainView extends StatelessWidget {
//   final String home = 'assets/icons/svg/home.svg';
//   final String marketing = 'assets/icons/svg/marketing.svg';
//   final String business = 'assets/icons/svg/business.svg';
//   final String customer = 'assets/icons/svg/customer.svg';

//   final _views = <Widget>[
//     HomePageView(key: PageStorageKey('Page1')),
//     CustomerView(),
//     MarketingHomePageView(),
//     BusinessHomePageView(),
//   ];

//   final PageStorageBucket bucket = PageStorageBucket();

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<MainViewModel>.reactive(
//       viewModelBuilder: () => MainViewModel(),
//       onModelReady: (model) {
//         model.gettransactions();
//         model.getcurr();
//         model.getCustomers();
//       },
//       builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle(
//           statusBarColor: BrandColors.primary,
//           statusBarIconBrightness: Brightness.light,
//         ),
//         child: WillPopScope(
//           onWillPop: () async {
//             if (model.index != 0) {
//               model.changeTab(0);
//               return false;
//             }
//             return true;
//           },
//           child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             body: Stack(
//               children: <Widget>[
//                 mainView(context, model),
//                 model.index == 0 || model.index == 1 || model.index == 3
//                     ? MainMenu()
//                     : Container(),
//                 model.index == 0 || model.index == 1 || model.index == 3
//                     ? MainHeader()
//                     : Container()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget mainView(BuildContext context, MainViewModel model) {
//     return Positioned(
//       top: model.index == 2
//           ? SizeConfig.yMargin(context, 0)
//           : SizeConfig.yMargin(context, 12),
//       bottom: 0,
//       width: SizeConfig.xMargin(context, 100),
//       child: Scaffold(
//         body: PageStorage(
//           bucket: bucket,
//           child: LazyIndexedStack(
//             reuse: true,
//             index: model.index,
//             itemCount: _views.length,
//             itemBuilder: (_, index) => _views[index],
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           selectedFontSize: SizeConfig.textSize(context, 3.1),
//           unselectedFontSize: SizeConfig.textSize(context, 3.1),
//           showUnselectedLabels: true,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Theme.of(context).backgroundColor,
//           selectedItemColor: Theme.of(context).textSelectionColor,
//           unselectedItemColor: ThemeColors.inactive,
//           currentIndex: model.index,
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               title: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: SizeConfig.textSize(context, 1.3),
//                   ),
//                   Text(
//                     AppLocalizations.of(context).home,
//                   ),
//                 ],
//               ),
//               icon: SvgPicture.asset(
//                 home,
//                 height: SizeConfig.textSize(context, 4),
//                 color: ThemeColors.inactive,
//                 semanticsLabel: 'Home',
//               ),
//               activeIcon: SvgPicture.asset(
//                 home,
//                 height: SizeConfig.textSize(context, 4),
//                 color: Theme.of(context).textSelectionColor,
//                 semanticsLabel: 'Home Navigator is Active',
//               ),
//             ),
//             BottomNavigationBarItem(
//               title: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: SizeConfig.textSize(context, 1.3),
//                   ),
//                   Text(
//                     AppLocalizations.of(context).customer,
//                   ),
//                 ],
//               ),
//               icon: SvgPicture.asset(
//                 customer,
//                 height: SizeConfig.textSize(context, 3.5),
//                 color: ThemeColors.inactive,
//                 semanticsLabel: 'Customer',
//               ),
//               activeIcon: SvgPicture.asset(
//                 customer,
//                 height: SizeConfig.textSize(context, 3.5),
//                 color: Theme.of(context).textSelectionColor,
//                 semanticsLabel: 'Customer Navigator is Active',
//               ),
//             ),
//             BottomNavigationBarItem(
//               title: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: SizeConfig.textSize(context, 1.3),
//                   ),
//                   Text(
//                     AppLocalizations.of(context).marketing,
//                   ),
//                 ],
//               ),
//               icon: SvgPicture.asset(
//                 marketing,
//                 height: SizeConfig.textSize(context, 3.5),
//                 color: ThemeColors.inactive,
//                 semanticsLabel: 'Marketing',
//               ),
//               activeIcon: SvgPicture.asset(
//                 marketing,
//                 height: SizeConfig.textSize(context, 3.5),
//                 color: Theme.of(context).textSelectionColor,
//                 semanticsLabel: 'Marketing Navigator is Active',
//               ),
//             ),
//             BottomNavigationBarItem(
//               title: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: SizeConfig.textSize(context, 1.3),
//                   ),
//                   Text(
//                     AppLocalizations.of(context).business,
//                   ),
//                 ],
//               ),
//               icon: SvgPicture.asset(
//                 business,
//                 height: SizeConfig.textSize(context, 4),
//                 color: ThemeColors.inactive,
//                 semanticsLabel: AppLocalizations.of(context).business,
//               ),
//               activeIcon: SvgPicture.asset(
//                 business,
//                 height: SizeConfig.textSize(context, 4),
//                 color: Theme.of(context).textSelectionColor,
//                 semanticsLabel: 'Business Navigator is Active',
//               ),
//             ),
//           ],
//           onTap: model.changeTab,
//         ),
//       ),
//     );
//   }
// }
