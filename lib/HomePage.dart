import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';





class HomePage extends StatefulWidget
{
  HomePage(
  {
    this.auth,
    this.onSignedOut,

}
  );

  final AuthImplementation auth;
  final VoidCallback onSignedOut;


  @override
  State<StatefulWidget> createState()
  {
    return _HomePageState();
  }
}
class _HomePageState extends State<HomePage>
{
  List<Posts> postsList = [];



  @override
  void initState()
  {
    super.initState();


    DatabaseReference postRef = FirebaseDatabase.instance.reference().child("Posts");

    postRef.once().then((DataSnapshot snap)
        {
          var KEYS = snap.value.keys;
          var DATA = snap.value;

          postsList.clear();

          for(var individualkey in KEYS)

            {
              Posts posts = new Posts
                (
                DATA[individualkey]['image'],
                DATA[individualkey]['description'],
                DATA[individualkey]['date'],
                DATA[individualkey]['time'],
                );


              postsList.add(posts);

            }

              setState(()
              {
                print('Length: $postsList.length');
              });

        }
    );
  }




  void _logoutUser() async
  {
    try
        {
          await widget.auth.signOut();
          widget.onSignedOut();
        }
        catch(e)
    {
      print((e.toString()));
    }
  }




  @override
  Widget build(BuildContext context)
  {
    return new Scaffold
      (
      appBar: new AppBar
        (
        title: new Text("Home"),
      ),

      body: new Container
        (

        child: postsList.length == 0 ? new Text("No Blog Post Available!"): new ListView.builder
          (
          itemCount: postsList.length,
            itemBuilder: (_, index)
            {
              return PostsUI
                (
                postsList[index].image,
                postsList[index].description,
                postsList[index].date,
                postsList[index].time,
              );
            }
        ) ,


        ),

      bottomNavigationBar: new BottomAppBar
        (
        color: Colors.white,

        child: new Container
          (


          margin: const EdgeInsets.only(left: 60.0,right: 60.0),
            child: new Row
              (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>
              [
                  new IconButton
                    (

                      icon: new Icon(Icons.exit_to_app) ,
                    iconSize: 30,
                    color: Colors.black,
                    onPressed: _logoutUser,

                     ),
                new IconButton
                  (

                  icon: new Icon(Icons.add_a_photo) ,
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: ()
                  {
                    Navigator.push
                      (
                        context,
                        MaterialPageRoute(builder: (context)
                        {
                          return new UploadPhotoPage();
                        })
                      );
                  },

                ),

                
              ],

            ),
        ),
      ),

    );
  }



  Widget PostsUI(String image,String description,String date,String time)
  {
    return new Card
      (
        elevation: 10.0,
        margin: EdgeInsets.all(15.0),
      
      
        child: new Container
          (
          padding: new EdgeInsets.all(14.0),
          
          child: new Column
            (
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: <Widget>
            [
              new Row
                (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>
                [
                  new Text
                    (
                    date,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  new Text
                    (
                    time,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  )
                ],
              ),

              SizedBox(height: 10.0,),

              new Image.network(image, fit: BoxFit.cover,),

              SizedBox(height: 10.0,),

              new Text
                (
                description,
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.center,
              ),

            ],

          ),



        ),

      );

  }
}