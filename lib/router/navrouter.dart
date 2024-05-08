import 'package:get/get.dart';
import 'package:prospros/view/account/account_screen.dart';
import 'package:prospros/view/activity_comment.dart';
import 'package:prospros/view/activity_like_view.dart';
import 'package:prospros/view/activity_post.dart';
import 'package:prospros/view/change_password.dart';
import 'package:prospros/view/create_post/create_post_screen.dart';
import 'package:prospros/view/create_profile_details/create_profile_details.dart';
import 'package:prospros/view/edit_profile/edit_profile_screen.dart';
import 'package:prospros/view/filter/filter_screen.dart';
import 'package:prospros/view/notification_list.dart';
import 'package:prospros/view/opt_success.dart';
import 'package:prospros/view/phone_verfication.dart';
import 'package:prospros/view/post_details/post_details_screen.dart';
import 'package:prospros/view/activity.dart';
import 'package:prospros/view/chat_screen.dart';
import 'package:prospros/view/community.dart';
import 'package:prospros/view/drawer_navigation.dart';
import 'package:prospros/view/home.dart';
import 'package:prospros/view/message/message.dart';
import 'package:prospros/view/notification.dart';
import 'package:prospros/view/profile.dart';
import 'package:prospros/view/register.dart';
import 'package:prospros/view/reset_password/reset_password.dart';
import 'package:prospros/view/select_plan/select_plan.dart';
import 'package:prospros/view/transaction_list.dart';

import '../view/login.dart';
import 'navrouter_constants.dart';

class NavRouter {
  static final generateRoute = [
    GetPage(name: login, page: () => Login()),
    GetPage(name: register, page: () => Register()),
    GetPage(name: phoneVerification, page: () => PhoneVerification()),
    GetPage(name: otpSucess, page: () => const OPTSuccess()),
    GetPage(
        name: createProfileDetails, page: () => CreateProfileDetailsScreen()),
    GetPage(name: selectPlan, page: () => SelectPlanScreen()),
    GetPage(name: filterPosts, page: () => const FilterScreen()),
    GetPage(name: postDetails, page: () => const PostDetailsScreen()),
    GetPage(name: createPost, page: () => const CreatePostScreen()),
    GetPage(name: editProfile, page: () => const EditProfile()),
    GetPage(name: account, page: () => const AccountScreen()),
    GetPage(name: home, page: () => Home()),
    GetPage(name: community, page: () => Community()),
    GetPage(name: message, page: () => Message()),
    GetPage(name: profile, page: () => Profile()),
    GetPage(
      name: profileDetail,
      page: () => Profile(isDetail: true),
    ),
    GetPage(name: notification, page: () => Notification()),
    GetPage(name: drawerNavigation, page: () => const DrawerNavigation()),
    GetPage(name: activity, page: () => const Activity()),
    GetPage(name: chatScreen, page: () => ChatScreen()),
    GetPage(name: notificationList, page: () => NotificationList()),
    GetPage(name: activityPost, page: () => ActivityPost()),
    GetPage(name: activityComment, page: () => ActivityComment()),
    GetPage(name: activityLike, page: () => ActivityLike()),
    GetPage(name: changePassword, page: () => ChangePassword()),
    GetPage(name: resetPassword, page: () => ResetPassword()),
    GetPage(name: transactionList, page: () => TransactionList())
  ];
}
