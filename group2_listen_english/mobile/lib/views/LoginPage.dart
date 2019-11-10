import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/core/components/CustomIcons.dart';
import 'package:mobile/core/constant/Constant.dart';
import 'package:mobile/core/models/User.dart';
import 'package:mobile/core/services/authentication.dart';
import 'package:mobile/views/screen/HomeScreen.dart';
import 'package:mobile/views/widgets/SocialIcons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({this.auth,this.onSignedIn});
  final VoidCallback onSignedIn;

  final Auth auth;
  @override
  _LoginPageState createState() => new _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isSelected = false;
  String _email;
  String _password;
  String _username;
  bool isLogIn = true;
  bool isLoading = false;

  String actionString = "SIGN IN";

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen()),
          );
        }
      });
    });

    this.setState(() {
      isLoading = false;
    });
  }

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    setState((){
      isLoading = true;
    });
    if (validateAndSave()) {
      try {
        if (isLogIn) {
          final String userId = await widget.auth.signIn(_email, _password);
          Fluttertoast.showToast(msg: "Sign in as $userId");
          widget.onSignedIn();
        } else {
          final User user = await widget.auth.signUpFromStrapi(_username, _email, _password);
          Fluttertoast.showToast(msg: "Sign up successfully");
          widget.onSignedIn();
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Your email or password are incorrect");
      }
    }
    setState((){
      isLoading = false;
    });
  }

  Future<void> signinGG() async {
    setState((){
      isLoading = true;
    });
    final String userId = await widget.auth.signInGG();
    widget.onSignedIn();
    setState((){
      isLoading = false;
    });
    Fluttertoast.showToast(msg: "Sign in by Google account");
  }

  Future<void> signinFB() async {
    setState((){
      isLoading = true;
    });
    final String userId = await widget.auth.signInFB();
    widget.onSignedIn();
    setState((){
      isLoading = true;
    });
    Fluttertoast.showToast(msg: "Sign in by Facebook account");
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      isLogIn = false;
      actionString = "SIGN UP";
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      isLogIn = true;
      actionString = "SIGN IN";
    });
  }

  void _radio(){
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
      padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(width: 2.0,color: Colors.black)
    ),
    child: isSelected ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black
      ),
    ): Container(),
  );

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(70),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: screenSize.width,height: screenSize.height,allowFontScaling: true);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background_login.jpg"),
                      fit: BoxFit.fill
                  )
              )
          ),
          SingleChildScrollView(
//            scrollDirection: Axis.ve,
            child: Padding(
              padding: EdgeInsets.only(top: 60,left: 20,right: 20),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Image.asset("assets/images/appname.png"),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(20),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(280),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0,15.0),
                          blurRadius: 15.0
                        ),
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0,-10.0),
                            blurRadius: 10.0
                        )
                      ]),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0,right: 16.0,top: 16.0),
                      child: Form(
                        key: formKey,
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(isLogIn ? "Login": "Register",style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(30),
                                fontFamily: "Poppins-Bold",
                                letterSpacing: .6)),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(10),
                            ),
                            !isLogIn ? Text("Username",style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(16),
                                fontFamily: "Poppins-Medium",
                                letterSpacing: .6)): Container(),
                            !isLogIn ? TextFormField(
                              key: Key("username"),
                              decoration: InputDecoration(
                                  hintText: "Enter your username",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                              onSaved: (String value) => _username = value,
                            ): Container(),
                            Text("Email",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil.getInstance().setSp(16))),
                            TextFormField(
                              key: Key("email"),
                              decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                              validator: (value) => value.isEmpty ? "Email can not be empty": null,
                              onSaved: (String value) => _email = value,
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(15),
                            ),
                            Text("Password",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil.getInstance().setSp(16))),
                            TextFormField(
                              key: Key("password"),
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                              validator: (value) => (value.length < 6) ? "Password must be at least 6 characters": null,
                              onSaved: (String value) => _password = value,
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(15),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: isLogIn ? <Widget>[
                                Text("Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil.getInstance().setSp(18)
                                  ),)
                              ]: <Widget> [],
                            )
                          ],
                        ),
                      )
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("Remember Me", style: TextStyle(fontSize: 14, fontFamily: "Poppins-Medium"))
                        ],
                      ),
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(180),
                          height: ScreenUtil.getInstance().setHeight(50),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFF17ead9),
                                Color(0xFF6078ea),
                              ]),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(.3),
                                    offset: Offset(0.0,8.0),
                                    blurRadius: 8.0
                                )
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
//                              key: Key("signIn"),
                              onTap: validateAndSubmit,
                              child: Center(
                                  child: Text(actionString,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins-Bold",
                                          fontSize: 18,
                                          letterSpacing: 1.0))
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("Social Login",style: TextStyle(fontSize: 16.0,fontFamily: "Poppins-Medium")),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIcons(
                        colors: [
                          Color(0xFF102397),
                          Color(0xFF187adf),
                          Color(0xFF00aaf8),
                        ],
                        iconData: CustomIcons.facebook,
                        onPressed: signinFB,
                      ),
                      SocialIcons(
                        colors: [
                          Color(0xFFff4f38),
                          Color(0xFFff355d),
                        ],
                        iconData: CustomIcons.google,
                        onPressed: signinGG,
                      ),

                    ],
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(isLogIn ? "New User?": "Already an user?",style: TextStyle(fontFamily: "Poppins-Medium")),
                      InkWell(
                        onTap: isLogIn ? moveToRegister: moveToLogin,
                        child: Text(isLogIn? "Sign Up": "Sign In", style: TextStyle(color: Color(0xFF5d74e3),fontFamily: "Poppins-Bold")),
                      )
                    ],
                  )
                ],
              )
            ),
          ),
          Positioned(
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              ),
              color: Colors.white.withOpacity(0.8),
            )
                : Container(),
          ),
        ],
      )
    );
  }

}
