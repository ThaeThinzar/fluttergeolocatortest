import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappgeolocator/blocs/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:trust_fall/trust_fall.dart';

import 'detail_view.dart';
import 'models/employee.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 10,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
  ),
);

void main() {
  runApp(
      BlocProvider(
        create: (context) {
          return EmployeeLeaveRequestBloc()..add(LoadEmployee());
        },
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: MyApp2(),
            )
        ),
      )
  );
}

class MyApp2 extends StatelessWidget {
  static final List<String> _listViewData = [
    "100016",
    "10012",
    "100013",
    "100010",
  ];

  final _months = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December'
  };

  String _branch = 'Yangon';
  String _department = 'Admin';
  int year = 2020;
  final focus = FocusNode();
  final _userIDController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<EmployeeLeaveRequestBloc, EmployeeLeaveRequestState>(
        builder: (context, state) {
            if (state is EmployeeLoaded) {
              logger.i("Testing");
              final employees = state.employees;

            final searchButton = Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: SizedBox(
                width: 300.0,
                height: 40.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                 // onPressed: _onApproveButtonClick(),
                  padding: EdgeInsets.all(2.0),
                  color: Colors.blue,
                  child: Text(
                    'SEARCH',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
              Widget _selectBranch() {
                int index=0;
                return new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _branch,
                      onChanged: (String newValue) {
                        setState(){
                          _branch = newValue;
                        }
                      },
                      items: <String>['Yangon', 'Mandalay', 'JC KBZ']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList(),
                    ),

                  ],
                );
              }
              Widget _selectDepartment() {
                int index=0;
                return new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _department,
                      onChanged: (String newValue) {
                        setState(){
                          _department = newValue;
                        }
                      },
                      items: <String>['Admin', 'User',]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList(),
                    ),

                  ],
                );
              }
              Widget _monthSelectOption() {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButton<int>(
                        items: <int> [1,2,3,4].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              _months[value],
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        value: 1,
                        hint: new Text('Pls Select Month'),
                        isExpanded: false,
                        style: new TextStyle(color: Colors.blueGrey),
                        onChanged: _onMonthOptionChange,
                      )
                    ],
                  ),
                );
              }

              Widget _yearSelectOption() {
                return new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButton<int>(
                      onChanged: (int value){
                        setState(){
                          year = value;
                        }
                      },
                      items: <int> [2020,2018,2019,2017].map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: new Text(
                            '$year',
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      value: year,
                      isExpanded: false,
                      style: new TextStyle(color: Colors.white),
                      hint: new Text('Pls Select Year'),
                    )
                  ],
                );
              }
              final userId = SizedBox(

                child: Padding(
                  padding:  EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  child: TextFormField(
                    key: Key('user_id'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                    inputFormatters: [

                    ],
                    autofocus: false,
                    style: new TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Employee ID',
                      hintStyle: TextStyle(
                          fontSize: 15.0, color: Colors.black),
                      contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),),
                      fillColor: Colors.blue,),
                    controller: _userIDController,
                    validator: validateID,
                  ),
                )
              );
            List<ExpansionTile> _listOfExpansions = List<ExpansionTile>.generate(
                employees.length,
                    (i) =>
                    ExpansionTile(
                      backgroundColor: Colors.black12,
                   /*   leading: Checkbox(
                        value: employees[i].isCheck,
                        onChanged: (_) {
                          BlocProvider.of<EmployeeLeaveRequestBloc>(context).add(
                            UpdateEmployee(employees[i].copyWith(isCheck: !employees[i].isCheck))
                          );
                        },
                      ),*/
                      title:new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              'Jame (100016)',
                              style: TextStyle(fontSize: 15, color: Colors.blue)),
                          Text(
                              '20/03/2020',
                              style: TextStyle(fontSize: 15, color: Colors.blue)),
                        ],
                      ),
                      children:
                      employees
                          .map((data) =>
                          Card(
                            child: ListTile(
                            /*  leading: Checkbox(
                                value: data.isChecked,
                                onChanged: (_) {
                                  BlocProvider.of<EmployeeLeaveRequestBloc>(context).add(
                                      UpdateSingleLeaveRequest(employees[i], data.copyWith(isChecked: !data.isChecked))
                                  );
                                },
                              ),*/
                              title:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5,),
                                  Text(" Attendance Date : 05/02/2020",
                                    style: TextStyle(
                                        fontSize: 12
                                    ),),
                                  SizedBox(height: 5,),
                                  Text(" Attendance Time: 08: 00 - 18:00",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12
                                    ),),
                                  SizedBox(height: 5,),
                                  Text(" OverTime Hour: 08:00",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12
                                    ),),
                                  SizedBox(height: 5,),
                                  Text(" Attendance Time: 08: 00 - 18:00",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12
                                    ),),
                                  SizedBox(height: 5,)
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5,),
                                  Text(" Reason: ",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12
                                    ),),
                                  SizedBox(height: 5,),
                                  Text(" Testing ",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12
                                    ),),
                                ],
                              ),
/*                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  FlatButton(
                                    textColor: Colors.blue,
                                    child: Text(
                                      "Test",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: () {
                                      logger.i("Test");
                                    },
                                  ),
                                  FlatButton(
                                    textColor: Colors.blue,
                                    child: Text(
                                      "Test",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: () {
                                      logger.i("Test");
                                    },
                                  )
                                ],
                              )*/
                            ),
                          ))
                          .toList(),
                    ));
               _myListView() {
                return ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ListTile(
                        title: Text('Sun'),
                      ),
                      ListTile(
                        title: Text('Moon'),
                      ),
                      ListTile(
                        title: Text('Star'),
                      ),
                    ],
                  ).toList(),
                );
              }
              Widget _getItemUI(Employee employee) {
                //DateTime otDateTime = DateTime.fromMillisecondsSinceEpoch(employee.);
                return new Card(
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                        child: ListTile(
                         /* leading:Checkbox(
                            value: employee.isCheck,
                            onChanged: (_) {
                              BlocProvider.of<EmployeeLeaveRequestBloc>(context).add(
                                  UpdateEmployee(employee.copyWith(isCheck: !employee.isCheck))
                              );
                            },
                          ),*/
                          title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    '${employee.name}(${employee.id})',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14.0),
                                  ),
                                  SizedBox(height: 5.0),
                                  new Text(
                                    'Department : Admin',
                                    style: TextStyle(color : Colors.blueGrey,fontSize: 14.0),
                                  ),
                                  SizedBox(height: 5.0),
                                 /* new Text(
                                    'OT Hrs: 03: 00 ',
                                    style:
                                    TextStyle(fontSize: 12.0, color: Colors.lightBlue),
                                  ),
                                  SizedBox(height: 5.0),
                                  new Text(
                                    'Reason: because of client urgent case',
                                    style: TextStyle(fontSize: 12.0),
                                  )*/
                                ],
                              ),
                              new Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 4.0),
                                    child: SizedBox(
                                      width: 70.0,
                                      height: 25.0,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24.0)),
                                        onPressed: () {_navigateDetailView(context, 'hello');},
                                        padding: EdgeInsets.all(2.0),
                                        color: Colors.blue,
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 10.0),
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              )
                            ],
                          ),
                          onTap: () {
                           // _openOvertimeDetailsDialog(context, response);
                          },
                        ),
                      )
                    ],
                  ),
                );
              }

              Widget _buildItems() {
                return ListView.builder(
                    itemCount:state.employees.length ,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return _getItemUI(employees[index]);
                    });
              }
              Widget _buildAppBar() {
                return PreferredSize(
                  preferredSize: Size.fromHeight(250.0),
                  child: AppBar(
                    leading: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    title: Text(
                      'Leave Report',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    bottom: PreferredSize(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: new Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: new Column(

                              children: <Widget>[
                                userId,
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    _selectDepartment(),
                                    SizedBox(width: 50,),
                                    _selectBranch()
                                  ],
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 5,),
                                    _yearSelectOption(),
                                    SizedBox(width: 50,),
                                    _monthSelectOption()
                                  ],
                                ),
                                searchButton
                              ],
                            ),
                          ),
                        ),
                        preferredSize: Size(0.0, 10.0)),
                  ),
                );
              }

            return WillPopScope(
              child: Scaffold(
                  backgroundColor: Color(0xFFE0E0E0),
                  appBar: _buildAppBar(),
                  body: new Column(
                    children: <Widget>[
                   /*  new Container(
                       height : 50,
                       child:   FlatButton(
                         child: Text("Approve",
                           style: TextStyle(
                               color: Colors.blue
                           ),),
                         onPressed: _onApproveButtonClick,
                       ),
                     )*/

                      new Container(
                       height: 300,
                        child:_buildItems() /*ListView(
                            padding: EdgeInsets.all(8.0),
                            children: ,
                           // _listOfExpansions.map((expansionTile) => expansionTile).toList()
                        ),*/

                      )
                    ],
                  )
              ),
            );

        }
          return Container(
          );
        }
    );
  }
  _onApproveButtonClick(){
    showToast("Approve");
  }
  String validateID(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "ID is Required";
    } else if (!regExp.hasMatch(value)) {
      return "ID Number must be digits";
    }
    return null;
  }
  _onSearchButtonClick(List<Employee> employees, BuildContext context) {
     Employee employee;
     for(int i = 0; i< employees.length; i++){
       employee = employees[i];
       if(employee.isCheck){
         String empID = employee.id;
         showToast("Approve employee $empID");
       }
     }
  }
  void _navigateDetailView(BuildContext context, String screenName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Detailview()),
    );
  }

  showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  void _onMonthOptionChange(int newValue) {


  }
}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentPosition;
  bool _fakeLocationOn;

  @override
  void initState() {
//    logger.d("This is initState");
//    TrustFall.canMockLocation
//        .then(_checkFakeGPS)
//        .then((data) => _getCurrentPosition());
//    TrustFall.canMockLocation.then((data) => _checkFakeGPS(data));
//  _getCurrentPosition();
  }

  _checkFakeGPS(bool data) {
    logger.d("Checking fake gps", data);
    _fakeLocationOn = data;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
//        body: Center(
////          child: Column(
////            mainAxisAlignment: MainAxisAlignment.center,
////            children: <Widget>[
////              Text('Position $_currentPosition'),
////              MaterialButton(
////                child: Text('Get Location'),
////                onPressed: _getCurrentPosition,
////              )
////            ],
////          ),
//        ),
        body: ExpandableListView(context),
      ),
    );
  }

  _getCurrentPosition() async {
    logger.i("get current position");
    if (_currentPosition == null) {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          logger.d("Position $position");
          logger.d("isFackLocOn $_fakeLocationOn");
          _currentPosition = position;
        });
      });
    } else {
      logger.d("Position $_currentPosition");
      logger.d("isFackLocOn $_fakeLocationOn");
    }
  }
}

class ExpandableListView extends StatelessWidget {
  ExpandableListView(this.context);

  final BuildContext context;
  List<String> employeeNames = ["James", "Tonny", "Robin", "Jenny"];
  static final List<String> _listViewData = [
    "100016",
    "10012",
    "100013",
    "100010",
  ];

  @override
  Widget build(BuildContext context) {
    List<ExpansionTile> _listOfExpansions = List<ExpansionTile>.generate(
        employeeNames.length,
            (i) =>
            ExpansionTile(
              title: Text(
                  employeeNames[i] + "              Requested : 10/02/2020",
                  style: TextStyle(fontSize: 15, color: Colors.blue)),
              children: _listViewData
                  .map((data) =>
                  Card(
                    child: ListTile(
                      title: Text(
                        employeeNames[i] + " - " + data,
                        style:
                        TextStyle(color: Colors.blueGrey, fontSize: 15),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text(
                              "Test",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              logger.i("Test");
                            },
                          ),
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text(
                              "Test",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              logger.i("Test");
                            },
                          )
                        ],
                      ),
                    ),
                  ))
                  .toList(),
            ));
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children:
        _listOfExpansions.map((expansionTile) => expansionTile).toList(),
      ),
    );
  }
}
