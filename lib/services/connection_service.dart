import 'dart:io';

class ConnectionService{


  Future<bool> getConnectionState() async{
    
     try{
    final result = await InternetAddress.lookup('example.com').timeout(Duration(seconds: 3));
    print(result);

    if(result.isNotEmpty &&result[0].rawAddress.isNotEmpty){
      return true;
    }else{
      return false;
    }
  } on SocketException catch(_){
    return false;

  }

  }

 


}