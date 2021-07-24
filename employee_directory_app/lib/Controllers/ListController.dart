import 'dart:convert';

import 'package:employee_directory_app/Models/EmployeeListModal.dart';
import 'package:employee_directory_app/Repositories/EmployeeRepository.dart';
import 'package:employee_directory_app/Utilities/db_helper.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  var dataIsFetching = true.obs;
  var isError = false.obs;
  var errorInfo = "".obs;

  var employeesListFetched = [].obs;
  final EmployeeRepository _employeeRepository = EmployeeRepository();
  final dbHelper = DatabaseHelper.instance;

  Future<Null> getEmployees() async {
    try {
      dataIsFetching.value = true;
      List<EmployeeListModal> tempList = [];

      List<EmployeeListModal> tempSqlList = [];
      tempSqlList = await _queryEmployees();

      if (tempSqlList != null && tempSqlList.length > 0) {
        print('From db');
        tempList = tempSqlList;

        if (tempList != null && tempList.length > 0) {
          isError.value = false;
          dataIsFetching.value = false;
          employeesListFetched.assignAll(tempList);
        } else {
          isError.value = true;
          errorInfo.value = "Something went wrong";
        }
      } else {
        print('From api');
        tempList = await _employeeRepository.getEmployeesInfo();
        Map<String, dynamic> row = {
          DatabaseHelper.columnInfo: jsonEncode(tempList)
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');

        if (tempList != null && tempList.length > 0) {
          isError.value = false;
          dataIsFetching.value = false;
          employeesListFetched.assignAll(tempList);
        } else {
          isError.value = true;
          errorInfo.value = "Something went wrong";
        }
      }
    } catch (exception) {
      dataIsFetching.value = false;
      isError.value = true;
      errorInfo.value = "Something went wrong";
    }
  }

  Future<List<EmployeeListModal>> _queryEmployees() async {
    List<Map> allRows = await dbHelper.queryAllRows();
    List<EmployeeListModal> employees = [];
    if (allRows != null) {
      //print(allRows[0]['employee_data']);
      var info = jsonDecode(allRows[0]['employee_data']);
      info.forEach((element) {
        final emp = EmployeeListModal.fromJson(element);
        employees.add(emp);
        print(emp);
      });

      if (employees.length > 0) {
        return employees;
      }
      print('************************');
    }

    return null;
  }
}
