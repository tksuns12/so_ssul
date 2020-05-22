import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/actions/actions.dart';
import 'package:sossul/middleware/list_middlewares.dart';
import 'package:sossul/middleware/user_middlewares.dart';
import 'package:sossul/store/app_state.dart';

List getMiddleware() {
  return [fetchNovelsListMiddleware, fetchUserDataMiddleware];
}