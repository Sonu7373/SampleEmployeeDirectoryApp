import 'package:employee_directory_app/Models/EmployeeListModal.dart';
import 'package:employee_directory_app/ServiceManager/ApiProvider.dart';
import 'package:employee_directory_app/ServiceManager/RemoteConfig.dart';

class EmployeeRepository {
  ApiProvider apiProvider;

  EmployeeRepository() {
    apiProvider = new ApiProvider();
  }

  Future<List<EmployeeListModal>> getEmployeesInfo() async {
    List<EmployeeListModal> list = [];
    final response =
        await apiProvider.getInstance().get(RemoteConfig.getEmployeesList);
    try {
      if (response.data != null) {
        response.data.forEach((element) {
          final emp = EmployeeListModal.fromJson(element);
          list.add(emp);
          print(emp);
        });
        print("${list.length}");
      } else {
        print("employee list is null");
      }
    } catch (e) {
      print("${e.toString()}");
    }

    return list;
  }
}
