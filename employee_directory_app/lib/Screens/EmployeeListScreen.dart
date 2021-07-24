import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_directory_app/Controllers/ListController.dart';
import 'package:employee_directory_app/Custom/TextDrawable/TextDrawableWidget.dart';
import 'package:employee_directory_app/Custom/TextDrawable/color_generator.dart';
import 'package:employee_directory_app/Models/EmployeeListModal.dart';
import 'package:employee_directory_app/Screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final _employeeListController = Get.find<ListController>();
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _employeeListController.getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return _employeeListController.dataIsFetching.value
                        ? LoadingScreen()
                        : _employeeListController.isError.value
                            ? Container()
                            : _buildEmployeeList();
                  }),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildEmployeeList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _employeeListController.employeesListFetched.length,
      itemBuilder: (context, index) {
        EmployeeListModal emp =
            _employeeListController.employeesListFetched[index];
        return eachEmployeeItem(index, emp);
      },
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      //controller: _itemsScrollController,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 65),
    );
  }

  eachEmployeeItem(int index, EmployeeListModal employee) {
    return InkWell(
      onTap: () {
        Get.toNamed("/detail-page", arguments: {"employeeInfo": employee});
      },
      child: Container(
        alignment: FractionalOffset.center,
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
                child: Container(
                  width: 60,
                  height: 60,
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: "${employee.profileImage ?? ""}",
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => TextDrawableWidget(
                        "${employee.name}", ColorGenerator.materialColors,
                        (bool selected) {
                      // on tap callback
                    }, true, 60.0, 60.0, BoxShape.rectangle,
                        TextStyle(color: Colors.white, fontSize: 17.0)),
                  ),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "${employee.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "${employee.company?.name ?? "n/a"}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                  ),
                ],
              ),
              flex: 1,
            ),
            IconButton(
              iconSize: 20,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Please press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}