import 'dart:convert';

import 'package:employee_directory_app/Models/EmployeeListModal.dart';
import 'package:employee_directory_app/Repositories/EmployeeRepository.dart';
import 'package:employee_directory_app/Utilities/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  var dataIsFetching = true.obs;

  var employeesListFetched = [].obs;
  final EmployeeRepository _employeeRepository = EmployeeRepository();
  final dbHelper = DatabaseHelper.instance;
  TextEditingController searchController = TextEditingController();

  Future<Null> getEmployees() async {
    try {
      employeesListFetched.clear();
      dataIsFetching.value = true;
      List<EmployeeListModal> tempList = [];

      List<EmployeeListModal> tempSqlList = [];
      tempSqlList = await _queryEmployees();

      if (tempSqlList != null && tempSqlList.length > 0) {
        print('From db');
        tempList = tempSqlList;
        dataIsFetching.value = false;
        if (tempList != null && tempList.length > 0) {
          employeesListFetched.assignAll(tempList);
        }
      } else {
        print('From api');
        tempList = await _employeeRepository.getEmployeesInfo();
        Map<String, dynamic> row = {
          DatabaseHelper.columnInfo: jsonEncode(tempList)
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
        dataIsFetching.value = false;
        if (tempList != null && tempList.length > 0) {
          employeesListFetched.assignAll(tempList);
        }
      }
    } catch (exception) {
      dataIsFetching.value = false;
    }
  }

  Future<List<EmployeeListModal>> _queryEmployees() async {
    List<Map> allRows = await dbHelper.queryAllRows();
    List<EmployeeListModal> employees = [];
    if (allRows != null) {
      //print(allRows[0]['employee_data']);
      if (allRows.length != 0) {
        var info = jsonDecode(allRows[0]['employee_data']);
        if (info != null) {
          info.forEach((element) {
            final emp = EmployeeListModal.fromJson(element);
            employees.add(emp);
            print(emp);
          });

          if (employees != null && employees.length > 0) {
            return employees;
          }
          print('************************');
        }
      }
    }

    return null;
  }

  Future<Null> searchEmployees() async {
    print("search01");
    try {
      dataIsFetching.value = true;
      List<EmployeeListModal> tempList = [];
      employeesListFetched.forEach((element) {
        print("search02");
        final EmployeeListModal emp = element;
        if (emp.name.contains(searchController.text)) {
          print("search03");
          tempList.add(element);
        }
      });
      if (tempList.length == 0) {
        dataIsFetching.value = false;
        Fluttertoast.showToast(msg: "No matching results");
      } else {
        employeesListFetched.clear();
        dataIsFetching.value = false;
        employeesListFetched.assignAll(tempList);
      }
    } catch (exception) {
      print("search04");
      dataIsFetching.value = false;
    }
  }
}
