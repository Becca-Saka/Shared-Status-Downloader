
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService{

   DynamicLinkParameters parameters;
  Future<void> retriveDynamicLinks() async{
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if(deepLink !=null){
      final query = deepLink.queryParameters;
      if(query.length>0){
       final uid = query['userId'];
       print(uid);
      }
    }
    print(deepLink);

  }
    Future<void> retriveDynamicKnownLinks(PendingDynamicLinkData data) async{
   final Uri deepLink = data?.link;
    if(deepLink !=null){
      final query = deepLink.queryParameters;
      if(query.length>0){
       final uid = query['userId'];
       print(uid);
      }
    }
    print(deepLink);

  }
  
   Future<String> createDynamicLink(String linkType,String userID,
    String path,{String uploadType}) async{
     parameters = DynamicLinkParameters(
    uriPrefix: 'https://sharedstatusdownloader.page.link',
     link: Uri.parse('https://sharedstatusdownloader.page.link/$linkType?uploadType=$uploadType?userid=$userID?data=$path'),
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