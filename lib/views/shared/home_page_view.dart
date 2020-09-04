// import 'package:flutter/material.dart';
// import 'package:mycustomers/core/localization/app_localization.dart';
// import 'package:flutter_screenutil/screenutil.dart';
// import 'package:mycustomers/ui/shared/const_color.dart';
// import 'package:mycustomers/ui/shared/size_config.dart';
// import 'package:mycustomers/ui/views/home/home_page/tabs/debtors_view.dart';
// import 'package:stacked/stacked.dart';
// import 'package:flutter_screenutil/size_extension.dart';
// import 'home_page_viewmodel.dart';
// import 'tabs/creditors_view.dart';

// class HomePageView extends StatelessWidget {
//   const HomePageView({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     ScreenUtil.init(context, width: width, height: height);
//     return ViewModelBuilder<HomePageViewModel>.reactive(
//       onModelReady: (model) async {
//         model.getContacts();
//         model.getTransactions();
//       },
//       builder: (context, model, child) => DefaultTabController(
//         key: PageStorageKey('Page1'),
//         length: 2,
//         child: Scaffold(
//           body: Container(
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.0),
//                       border: Border(
//                           bottom: BorderSide(color: Colors.grey, width: 0.5))),
//                   child: TabBar(
//                     labelPadding: EdgeInsets.symmetric(horizontal: 1),
//                     unselectedLabelColor: Theme.of(context).cursorColor,
//                     labelColor: Theme.of(context).buttonColor,
//                     indicatorSize: TabBarIndicatorSize.label,
//                     indicatorColor: Theme.of(context).buttonColor,
//                     tabs: [
//                       Tab(
//                         child: Container(
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Text(
//                               AppLocalizations.of(context).customersOwingYou,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.yMargin(context, 2),
//                               ),
//                               //maxLines: 1,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Tab(
//                         child: Container(
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Text(
//                               AppLocalizations.of(context).peopleYouOwe,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.yMargin(context, 2),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Tab(
//                       //   child: Container(
//                       //     child: Align(
//                       //       alignment: Alignment.center,
//                       //       child: Text(
//                       //         "All Customers",
//                       //         textAlign: TextAlign.center,
//                       //          style: TextStyle(
//                       //           fontSize: SizeConfig.yMargin(context, 1.5),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     child: TabBarView(
//                       key: PageStorageKey('Page1'),
//                       children: <Widget>[
//                         DebtorsView(),
//                         CreditorsView(),
//                         // model.contacts.length == 0
//                         //     ? Center(
//                         //       child: Text('No Customer Added'),
//                         //     )
//                         //     : ContactList()
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//       viewModelBuilder: () => HomePageViewModel(),
//     );
//   }
// }

// class ContactList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<HomePageViewModel>.reactive(
//       builder: (context, model, child) => SingleChildScrollView(
//         child: Container(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding:
//                     const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
//                 child: TextField(
//                   textCapitalization: TextCapitalization.sentences,
//                   //controller: model.allCustomersController,
//                   //onChanged: model.searchAllCustomers,
//                   style: TextStyle(
//                     color: Theme.of(context).cursorColor,
//                     fontSize: 14,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: AppLocalizations.of(context).searchByName,
//                     hintStyle: TextStyle(
//                       color: Color(0xFFACACAC),
//                       fontSize: 14,
//                     ),
//                     contentPadding: const EdgeInsets.only(top: 18.0),
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: Theme.of(context).textSelectionColor,
//                     ),
//                     border: InputBorder.none,
//                   ),
//                   onChanged: model.searchName,
//                 ),
//               ),
//               model.sName != null && !model.contains
//                   ? Text(AppLocalizations.of(context).noCustomerFound)
//                   : SizedBox(),
//               for (var item in model.contacts)
//                 model.sName != null && model.contains
//                     ? item.name
//                             .toLowerCase()
//                             .contains(model.sName.toLowerCase())
//                         ? Container(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(vertical: 6),
//                               decoration: BoxDecoration(
//                                   border: Border(
//                                 top: BorderSide(color: Color(0xFFD1D1D1)),
//                                 //bottom: BorderSide(color: Color(0xFFD1D1D1))
//                               )),
//                               child: ListTile(
//                                 onTap: () => model.setContact(item),
//                                 leading: item.initials != null
//                                     ? CircleAvatar(
//                                         radius: 25,
//                                         backgroundColor: BrandColors.primary,
//                                         child: Text(item.initials),
//                                       )
//                                     : Container(
//                                         width: 50,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             color: Colors.black,
//                                             image: DecorationImage(
//                                                 image: AssetImage(
//                                                   'assets/images/man.png',
//                                                 ),
//                                                 fit: BoxFit.cover)),
//                                       ),
//                                 title: Text(item.name),
//                               ),
//                             ),
//                           )
//                         : SizedBox()
//                     : model.sName != null && !model.contains
//                         ? SizedBox()
//                         : Container(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(vertical: 6),
//                               decoration: BoxDecoration(
//                                   border: Border(
//                                 top: BorderSide(color: Color(0xFFD1D1D1)),
//                                 //bottom: BorderSide(color: Color(0xFFD1D1D1))
//                               )),
//                               child: ListTile(
//                                 onTap: () => model.setContact(item),
//                                 leading: item.initials != null
//                                     ? CircleAvatar(
//                                         radius: 25,
//                                         backgroundColor: BrandColors.primary,
//                                         child: Text(item.initials),
//                                       )
//                                     : Container(
//                                         width: 50,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             color: Colors.black,
//                                             image: DecorationImage(
//                                                 image: AssetImage(
//                                                   'assets/images/man.png',
//                                                 ),
//                                                 fit: BoxFit.cover)),
//                                       ),
//                                 title: Text(item.name,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize:
//                                             SizeConfig.yMargin(context, 2))),
//                               ),
//                             ),
//                           )
//             ],
//           ),
//         ),
//       ),
//       viewModelBuilder: () => HomePageViewModel(),
//     );
//   }
// }
