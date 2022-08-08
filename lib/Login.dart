import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_01_08_2022/CreateAccount.dart';
import 'package:test_01_08_2022/DataBase.dart';
import 'Constvalue.screen.dart';
import 'Dbhelp.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  List<Map<String, dynamic>> _journals = [];

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;

    });
  }

  @override
  void initState() {
    _refreshJournals();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: height / 3),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: TextField(
                      controller: userName,
                      decoration: const InputDecoration(
                        // contentPadding: EdgeInsets.all(0),
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          CupertinoIcons.profile_circled,
                          size: 20,
                          color: Colors.black54,
                        ),
                        hintText: 'Enter User Name',
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: 15.0,
                        ),
                        focusColor: Colors.grey,
                        hoverColor: Colors.grey,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: TextField(
                      controller: password,
                      decoration: const InputDecoration(
                        // contentPadding: EdgeInsets.all(0),
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          CupertinoIcons.lock,
                          size: 20,
                          color: Colors.black54,
                        ),
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: 15.0,
                        ),
                        focusColor: Colors.grey,
                        hoverColor: Colors.grey,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAccount()));
                      },
                      child: Container(
                        child: Text(
                          'Create Account ?',style: TextStyle(color: Colors.green.shade900,fontSize: 18),),
                      ),
                    ),
                  ),

                  Container(
                    height: height / 15,
                    width: width / 2,
                    margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.brown,
                            Colors.brown,
                          ],
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: FlatButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      textColor: Colors.white,
                      onPressed: () async {
                        print('test');
                        if (userName.text.isEmpty) {
                          Toastmsg('Kindly Enter User Name..!');
                        } else if (password.text.isEmpty) {
                          Toastmsg('Kindly Enter Password..!');
                        }
                        else {
                          await SQLHelper.getDetails(
                              userName.text, password.text,context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _get() async {
    await SQLHelper.getDetails(
        userName.text, password.text,context);

  }

}
