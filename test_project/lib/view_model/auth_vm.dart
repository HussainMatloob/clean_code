import 'package:get/get.dart';
import 'package:test_project/core/exceptions/server_exceptions.dart';
import 'package:test_project/core/networks/response_results.dart';
import 'package:test_project/core/services/api_requests_service.dart';

class AuthVm extends GetxController {
  // Future<void> getDashboardData() async {
  //   try {
  //     final response = await ApiRequest().getRequest(
  //       AppUrl.getdashboardDataPoint,
  //       isAuthenticated: true,
  //     );

  //     if (response.statusCode == 200) {
  //       dashboardData = DashboardDataModel.fromJson(response.data["data"]);
  //       update();
  //     }
  //   } on AppException catch (error) {
  //     ResponseResult.failure(error);
  //     update();
  //   } catch (error) {
  //     ResponseResult.failure(UnknownException());
  //     update();
  //   }
  // }
}
