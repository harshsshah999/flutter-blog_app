import "package:flutter/material.dart";
import 'package:flutter_blog_app/Authentication.dart';
import 'package:flutter_blog_app/DialogBox.dart';
import 'package:flutter_blog_app/main.dart';
import 'Authentication.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget
{
  LoginRegisterPage
  (
  {
    this.auth,
    this.onSignedIn,
  }
  );

  final AuthImplementation auth;
  final VoidCallback onSignedIn;


State<StatefulWidget> createState()
  {
  return _LoginRegisterState();
  }

}

enum FormType
{
  login,
  register
}


class  _LoginRegisterState extends State<LoginRegisterPage>
{
  DialogBox dialogBox = new DialogBox();




  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";


  //methods
  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  void validateAndSubmit() async
  {
    if (validateAndSave())
    {
      try
      {
        if (_formType == FormType.login)
        {
          String userId = await widget.auth.SignIn(_email, _password);
          //dialogBox.information(context, "Congratulations", "You are Logged in successfully!");
          print("Login userId = " + userId);
        }
        else
         {
          String userId = await widget.auth.SignUp(_email, _password);
          //dialogBox.information(context, "Congratulations", "Your Account has been created successfully!");
          print("Register userId = " + userId);
         }

        widget.onSignedIn();
        }
      catch(e)
      {


        dialogBox.information(context, "Error", e.toString());
        print("Error = " + e.toString());
      }
    }
  }


    void moveToRegister()
  {
  formKey.currentState.reset();

  setState(()
  {
  _formType = FormType.register;
  });
  }

  void moveToLogin()
  {
  formKey.currentState.reset();

  setState(()
  {
  _formType = FormType.login;
  });
  }


  //Design
  @override
  Widget build(BuildContext context)
  {
  return new Scaffold
  (
  appBar: new AppBar
  (
  title: new Text("Vu"),
  ),

  body: new Container
  (
  margin: EdgeInsets.all(15.0),

  child: new Form
  (
  key: formKey,


  child: new Column
  (
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: createInputs() + createButtons(),
  ),
  ),
  ),
  );
  }


  List<Widget> createInputs()
  {
  return
  [
  SizedBox(height: 10.0,),
  logo(),
  SizedBox(height: 20.0,),

  new TextFormField
  (
  decoration: new InputDecoration(labelText: 'Email'),

  validator: (value)
  {
  return value.isEmpty ? 'Email is required.' : null;
  },

  onSaved: (value)
  {
  return _email = value;
  },
  ),
  SizedBox(height: 10.0,),
  new TextFormField
  (
  decoration: new InputDecoration(labelText: 'Password'),
  obscureText: true,
  validator: (value)
  {
  return value.isEmpty ? 'Password is required.' : null;
  },

  onSaved: (value)
  {
  return _password = value;
  },
  ),
  SizedBox(height: 20.0,),
  ];
  }

  Widget logo()
  {
  return new Hero
  (
  tag: 'hero',
  child: new CircleAvatar
  (
  backgroundColor: Colors.transparent,
  radius: 110.0,
  child: Image.asset('images/logo.jpg'),
  ),

  );
  }


    List<Widget> createButtons()
    {
    if(_formType == FormType.login)
    {
    return
    [
      new RaisedButton
      (
        child: new Text("Login",style: new TextStyle(fontSize: 20.0)),
        textColor: Colors.white,
        color: Colors.pink,
        onPressed: validateAndSubmit,
      ),
      new FlatButton
      (
        child: new Text("Don't have an Account? Create Account?",style: new TextStyle(fontSize: 14.0),),
        textColor: Colors.red,
        onPressed: moveToRegister,
      ),
    ];

    }
    else
    {
    return

        [ new RaisedButton
          (
            child: new Text("Create Account",style: new TextStyle(fontSize: 20.0),),
            textColor: Colors.white,
            color: Colors.pink,
            onPressed: validateAndSubmit,
          ),
          new FlatButton
          (
            child: new Text("Already having an Account? Login",style: new TextStyle(fontSize: 14.0),),
            textColor: Colors.red,
            onPressed: moveToLogin,
          ),
        ];


        }
      }

  }


