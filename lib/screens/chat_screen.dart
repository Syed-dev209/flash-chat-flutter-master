import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
FirebaseUser loggedInUser;
class ChatScreen extends StatefulWidget {

  static String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgTextController= TextEditingController();
  final _auth=FirebaseAuth.instance;

  String msgText;
  final _fireStore=Firestore.instance;

  void getCurrentUser() async
  {
    try {
      final user = await _auth
          .currentUser(); //will return null if not logged in .Async method return future so await
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch(e)
    {
      print(e);
    }

  }

  @override
  void initState() {
     super.initState();
     getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    print('curently logged in :- ${loggedInUser.email}');
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                 // msgTream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('messages').snapshots() ,//important.Data kaha se aye ga woh yahan type
              builder: (context,snapshot){
                if(!snapshot.hasData)
                  {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white10,
                      ),
                    );
                  }
                    final messages = snapshot.data.documents.reversed;
                    List<MessageBubble> msgBubbles=[];
                    for(var msg in messages) {
                      final msgText = msg.data['text'];
                      final msgSender = msg.data['sender'];
                      final currentUser = loggedInUser.email;

                       final msgBubble=MessageBubble(sender: msgSender,
                         text: msgText,
                         isMe: currentUser==msgSender
                       );
                       msgBubbles.add(msgBubble);
                      }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                        children: msgBubbles,
                      ),
                    );


              } ,//important. Stream k update hony pr jo logic lagy gi woh yahan. Two parameters accept krta hai 1st context 2nd AsyncSnapshot(flutter ka snapshot hai jis me cloud fire store k QuerySnapShot pe kaam hota hai)
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        msgText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      msgTextController.clear();
                      //Implement send functionality.
                      _fireStore.collection('messages').add({
                        'text':msgText,
                        'sender':loggedInUser.email,
                      });

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
class MessageBubble extends StatelessWidget {
  final String sender,text;
  bool isMe;
    MessageBubble({this.sender,this.text,this.isMe});

  @override
  Widget build(BuildContext context) {
    print('$isMe');
    print('$sender');

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,

        children: <Widget>[
          Text(sender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54
          ),),
          Material(
            elevation: 5.0,
            borderRadius: isMe?BorderRadius.only(topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0))
            :BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0)
            ),
            color:isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:20.0 ),
              child: Text(
                  '$text',
                style: TextStyle(
                  color: isMe?Colors.white:Colors.black54,
                  fontSize: 15.0
                ),
              ),
            ),
          ),
        ],
      ),
    ) ;
  }
}
