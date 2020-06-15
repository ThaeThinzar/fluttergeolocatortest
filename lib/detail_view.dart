import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Detailview extends StatelessWidget {
  List <String> leaveTypes=  new List();
  @override
  Widget build(BuildContext context) {
    leaveTypes.add("Causual");
    leaveTypes.add("Earned ");
    leaveTypes.add("Medical");
    leaveTypes.add("Holiday");
    Widget _buildAppBar() {
      return PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Text(
            'Leave Report Detail',
            style: TextStyle(color: Colors.white, fontSize: 18.0),),
             /* SizedBox(height: 5,),
              Text(
                'Leave Report for Employee1',
                style: TextStyle(color: Colors.white, fontSize: 18.0),),*/
            ]
          ),
          ),
      );
    }
    Widget _buildLeaveSummaryItem(BuildContext context, int index) {
            return Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: ListTile(
                      title: new Text(
                        leaveTypes[index],
                        style: new TextStyle(color: Colors.lightBlue),
                      ),
                      subtitle: new Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.5,
                                  child: new Text(
                                    "New Given",
                                    style: new TextStyle(fontSize: 13.0),
                                  ),
                                ),
                                new Text(
                                  '0.0',
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.lightBlue),
                                )
                              ],
                            ),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.5,
                                  child: new Text(
                                    "Carry Over",
                                    style: new TextStyle(fontSize: 13.0),
                                  ),
                                ),
                                new Text(
                                  '6.0',
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.lightBlue),
                                )
                              ],
                            ),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.5,
                                  child: new Text(
                                    "Taken",
                                    style: new TextStyle(fontSize: 13.0),
                                  ),
                                ),
                                new Text(
                                  '3.0',
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.red),
                                )
                              ],
                            ),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.5,
                                  child: new Text(
                                    "Balance",
                                    style: new TextStyle(fontSize: 13.0),
                                  ),
                                ),
                                new Text(
                                  '3.0',
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.lightBlue),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
    }
    Widget _buildLeaveSummary() {
            return ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return _buildLeaveSummaryItem(context, index);
                });

    }

    return Scaffold(
        backgroundColor: Color(0xFFE0E0E0),
      appBar: _buildAppBar(),
      body: new Column(
        children: <Widget>[
          new Container(
            height: 400,

            child: _buildLeaveSummary(),
            /*new Row(

              children: <Widget>[
                Text("Leave Report For Employee1",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15
                  ),),

              ],
            ) ,*/
          )
        ],
      )
    );
  }
}