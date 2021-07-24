import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_directory_app/Custom/TextDrawable/TextDrawableWidget.dart';
import 'package:employee_directory_app/Custom/TextDrawable/color_generator.dart';
import 'package:employee_directory_app/Models/EmployeeListModal.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class EmployeeDetailScreen extends StatefulWidget {
  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  EmployeeListModal employee;

  @override
  void initState() {
    print('Arguments: ${Get.arguments}');
    Map<String, dynamic> data = Get.arguments;
    if (data != null) {
      if (data.containsKey("employeeInfo")) {
        employee = data["employeeInfo"];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Get.back();
          return Future.value(true);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: Container(
              height: double.infinity,
              color: Colors.black,
              alignment: FractionalOffset.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    iconSize: 20,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        alignment: FractionalOffset.centerLeft,
                        child: Text("Employee Info",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600))),
                    flex: 1,
                  )
                ],
              ),
            ),
          ),
          body: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 45),
                  child: Column(
                    children: [
                      _buildImageSection(),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                        alignment: FractionalOffset.center,
                        child: Text(
                          "${employee.name}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0),
                        ),
                      ),
                      _buildInfoSection(
                          Icons.mail_outline, "${employee.email ?? ""}"),
                      _buildInfoSection(
                          Icons.phone_in_talk, "${employee.phone ?? ""}"),
                      commonDetailPageInfoItem(
                          "User Name", "${employee.username}"),
                      commonDetailPageInfoItem(
                          "Company Name", "${employee.company?.name ?? "n/a"}"),
                      commonDetailPageInfoItem(
                          "Website url", "${employee.website ?? "n/a"}"),
                      commonDetailPageInfoItem("Address",
                          "${employee.address?.street}, ${employee.address?.city}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildImageSection() {
    return Container(
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 180,
      color: Colors.transparent,
      child: Container(
        width: 160,
        height: 160,
        decoration: new BoxDecoration(
          color: Colors.black26,
          borderRadius: new BorderRadius.all(new Radius.circular(80.0)),
          border: new Border.all(
            color: Colors.black,
            width: 5.0,
          ),
        ),
        child: ClipOval(
          child: SizedBox.expand(
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
              imageUrl: getImage(),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => TextDrawableWidget(
                "${employee.name}",
                ColorGenerator.materialColors,
                (bool selected) {
                  // on tap callback
                },
                false,
                150.0,
                150.0,
                BoxShape.circle,
                TextStyle(color: Colors.white, fontSize: 50.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildInfoSection(IconData icon, String info) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      alignment: FractionalOffset.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 20,
            icon: Icon(
              icon,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              "$info",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  commonDetailPageInfoItem(String label, String data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Divider(),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
          alignment: FractionalOffset.centerLeft,
          child: Text(
            "$label",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          alignment: FractionalOffset.centerLeft,
          child: Text(
            "$data",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.8,
                fontSize: 13.0),
          ),
        ),
      ],
    );
  }

  String getImage() {
    String img = "";
    if (employee != null) {
      if (employee.profileImage != null) {
        if (employee.profileImage != "") {
          img = employee.profileImage;
        }
      }
    }
    return img;
  }
}
