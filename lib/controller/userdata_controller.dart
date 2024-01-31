import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram_flutter_clone/model/user.dart' as model;
import 'package:instagram_flutter_clone/resources/auth_method.dart';

class UserController extends GetxController {
  @override
  void onInit() async {
    await getuserdata();
    super.onInit();
  }

  var userData = Rxn<model.User>();
  getuserdata() async {
    userData.value = await AuthMethod().getdata();
  }
}
