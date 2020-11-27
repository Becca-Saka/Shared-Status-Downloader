import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/signup/signup_view.dart';
import 'package:status_downloader/views/widget.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import 'signin_viewmodel.dart';

class SignInView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    GlobalKey<State> globalKey = new GlobalKey<State>();
//  GlobalKey<FormState> _scaffoldKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<SignInViewModel>.reactive(
      builder: (context, model, child){
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            leading: Icon(Icons.arrow_back, color: Colors.black,),
          ),
          
          body: Container(
            
            child: Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: 20
              ),
              child: SingleChildScrollView(
                              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      SizedBox(height: SizeConfig.yMargin(context, 15)),

                        Text('Sign In',
                        style:  TextStyle(
                          fontSize:  width/15,
                          fontWeight: FontWeight.w800, 
                          color: Colors.black),),
                        SizedBox(height: 5,),
                        Text('Log in to continue',
                        style:  TextStyle(fontSize:  width/20, fontWeight: FontWeight.w300,  color: Colors.black)),
                        
                      SizedBox(height: 20,),
                       textViewCard('Email',
                       emailController,
                        Icon(Icons.email, color: Colors.green,),
                         TextInputType.emailAddress,),
                      SizedBox(height: 15,),
                      textViewCard('Password',
                      passwordController,
                        Icon(Icons.lock, color: Colors.green,),
                         TextInputType.visiblePassword,),
                      SizedBox(height: 20,),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10
                        ),
                        color: Colors.green,
                        onPressed: () async{
                        
                          await model.doSignIn(emailController.text, passwordController.text, context, globalKey);
                               
                        },
                        child: Center(
                          child: Row(

                            children: <Widget>[
                              Expanded(
                 child: Center(
                   child: Text('Log in', style: TextStyle(
                    color: Colors.white,
                    fontSize:  width/25,
                ),),
                 ),
                              ),
                               SizedBox(height: 5,),
                              Icon(Icons.arrow_forward_ios, color: Colors.white,size: width/25,)
                            ],
                          ),
                        ),
                      ),
                       SizedBox(height: 5,),
                      Center(
                        child: InkWell(
                          onTap: (){
                             Navigator.push(context, CupertinoPageRoute(builder: (context)=>
                      SignUpView()));

                          },
                  child: Text('Don\'t have an account? Sign up',
                          style:  TextStyle(fontSize:  width/25, fontWeight: FontWeight.w300,  color: Colors.black)),
                        ),
                      ),
                        
                    
                    ],
                  ),
              ),
            ),
          ),

        );
      }, 
      viewModelBuilder: ()=> SignInViewModel());
  }
}