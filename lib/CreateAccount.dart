import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';

import 'Constvalue.screen.dart';
import 'DataBase.dart';
import 'Dbhelp.dart';


class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  Dbhelper dbhelper=Dbhelper();
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
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
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: TextField(
                  controller: confirmpassword,
                  decoration: const InputDecoration(
                    // contentPadding: EdgeInsets.all(0),
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      CupertinoIcons.lock,
                      size: 20,
                      color: Colors.black54,
                    ),
                    hintText: 'Enter Confirm Password',
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
                    'Create',
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
                    else if(confirmpassword.text.isEmpty){
                      Toastmsg('Kindly Enter Confirm Password..!');
                    }
                    else {
                      if(password.text.toLowerCase()==confirmpassword.text.toLowerCase()){

                   /*     var name= userName.text.toString();
                        var password=  confirmpassword.text.toString();

                        dbhelper.UserDetailsinsert(name,password,context);*/
                        await _addItem();

                      }else{
                        Toastmsg('Kindly Check Confirm Password..!');
                      }
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

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        userName.text, confirmpassword.text,context);

  }




}
