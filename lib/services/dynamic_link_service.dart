
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/models/status_details.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/router/routes.dart';
import 'package:status_downloader/services/firebase_service.dart';

class DynamicLinkService{

  NavigationService _navigationService = locator<NavigationService>();
  // FireBaseService _fireBaseService = locator<FireBaseService>();

   DynamicLinkParameters parameters;
  Future<void> retriveDynamicLinks() async{
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
   
   
     _handleDeepLink(data);
  
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData data) async{
         _handleDeepLink(data);

      }
    );

  }
    Future<void> retriveDynamicKnownLinks() async{

      String path ='https://sharedstatusdownloader.page.link/TAiCAZJHieztf6tM9';
      final PendingDynamicLinkData data = 
      await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(path));
      _handleDeepLink(data);
  
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData data) async{
         _handleDeepLink(data);

      }
    );

  }

   Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
  
      final Uri deepLink = data?.link;
    if(deepLink !=null){
      final query = deepLink.queryParameters;
      final uploadType = query['uploadType'];
       final userId = query['userid'];
      final docId = query['docid'];
       final url =deepLink.queryParameters['data'].replaceFirst('Statuses/$uploadType/', 
       'Statuses%2F$uploadType%2F');
       print(docId);
        final token =deepLink.queryParameters['token'];
        FireBaseService().updateSharedWithYou(docId);
      StatusDetails details = StatusDetails(
        url: '$url&token=$token',
        userId: userId,
        uid: docId,
        shareLink: data?.link.toString()
      );
       print(uploadType);
      
      uploadType=='Image'?
       _navigationService.navigateTo(RoutesNames.databaseImagePreview,
      arguments:details ): _navigationService.navigateTo(RoutesNames.databaseVideoPreview,
      arguments:details );
      }
     
   }
  
   Future<String> createDynamicLink(String linkType,String docId,String userID,
    String path,{String uploadType}) async{
     parameters = DynamicLinkParameters(
    uriPrefix: 'https://sharedstatusdownloader.page.link',
    link: Uri.parse('https://sharedstatusdownloader.page.link/invite?uploadType=$uploadType&userid=$userID&docid=$docId&data=$path'),
     
     androidParameters: AndroidParameters(
       packageName: 'com.status_downloader',
       minimumVersion: 1,
       ),
       );


    final link = await parameters.buildUrl();
     print(link);
    final ShortDynamicLink shortDynamicLink =await DynamicLinkParameters.shortenUrl(link,
    DynamicLinkParametersOptions(shortDynamicLinkPathLength:ShortDynamicLinkPathLength.unguessable)
    );

    print(shortDynamicLink.shortUrl);

    return shortDynamicLink.shortUrl.toString();

  }


}