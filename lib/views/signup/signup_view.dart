import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/widget.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import 'signup_viewmodel.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    GlobalKey<State> globalKey = new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<SignUpViewModel>.reactive(
        builder: (context, model, child) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0.0,
              leading: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            body: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        SizedBox(height: SizeConfig.yMargin(context, 15)),

                      Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: width / 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Create an account ',
                          style: TextStyle(
                              fontSize: width / 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.black)),
                      SizedBox(
                        height: 20,
                      ),
                      textViewCard(
                        'Name',
                        nameController,
                        Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                        TextInputType.text,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      textViewCard(
                        'Email',
                        emailController,
                        Icon(
                          Icons.email,
                          color: Colors.green,
                        ),
                        TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      textViewCard(
                        'Password',
                        passwordController,
                        Icon(
                          Icons.lock,
                          color: Colors.green,
                        ),
                        TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        color: Colors.green,
                        onPressed: () async {
                           
                          await model.doSignUp(emailController.text,
                              passwordController.text, nameController.text,context, globalKey);
                        },
                        child: Center(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: width / 25,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text('Already have an account? Log in',
                              style: TextStyle(
                                  fontSize: width / 25,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => SignUpViewModel());
  }
}
