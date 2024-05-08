class Url {
  //https://www.dev17.ivantechnology.in/doubtanddiscussion/api/user/login

  static const baseUrl = "dev17.ivantechnology.in";
  static const bool isStaging = true;
  static const path = "/doubtanddiscussion";
  static const login = path + "/api/user/login";
  static const register = path + "/api/user/register";
  static const countryList = path + "/api/country-list";
  static const emailVerify = path + "/api/email-verify";
  static const twoFactorLogin = path + "/api/user/login-with-2fa";
  static const phoneVerify = path + "/api/phone-verify";
  static const resendEmailOtp = path + "/api/resend-otp";
  static const socialLogin = path + "/api/user/social";
  static const updateCountry = path + "/api/user/country-update";
  static const categoryList = path + "/api/category-list";
  static const profileUpdate = path + "/api/user/profile-update";
  static const createPost = path + "/api/user/posts/create";
  static const posts = path + "/api/user/posts";
  static const postsDetails = path + "/api/user/posts/details";
  static const profilePictureUpdate = path + "/api/user/profile-picture-update";
  static const getProfile = path + "/api/user/get-profile";
  static const userPostList = path + "/api/user/posts/user-post-list";
  static const subscriptions = path + "/api/user/subscriptions";
  static const getSubscription = path + "/api/user/get-subscription";
  static const communityMemberList = path + "/api/user/community-member-list";
  static const postLike = path + "/api/user/posts/like";
  static const comment = path + "/api/user/posts/comment";
  static const commentLike = path + "/api/user/posts/comment-like";
  static const noticationPreference = path + "/api/user/notication-preference";
  static const notificationList = path + "/api/user/notifications";
  static const readNotification = path + "/api/user/read-notification";
  static const chatRequest = path + "/api/user/accept-reject-chat-request";
  static const sendChatRequest = path + "/api/user/send-chat-request";
  static const sendChatMessage = path + "/api/user/send-chat-message";
  static const chatHistory = path + "/api/user/chat-history";
  static const deletePost = path + "/api/user/posts/delete";
  static const viewNotificationPreference =
      path + "/api/user/view-notication-preference";

  static const chatMemberList = path + "/api/user/chat-members-list";

  static const activityCommentList =
      path + "/api/user/posts/activity/comment-list";

  static const accountDeletion = path + "/api/user/delete-account";

  static const activityLikeList = path + "/api/user/posts/activity/like-list";

  static const changePassword = path + "/api/user/change-password";

  static const forgotPassword = path + "/api/forgot-password";

  static const resetPassword = path + "/api/reset-password";

  static const stripePaymentIntent =
      path + "/api/user/create-stripe-payment-intent";
  static const braintreeClientToken =
      path + "/api/user/generate-braintree-client-token";
  static const processBraintreePayment =
      path + "/api/user/process-braintree-payment";

  static const retrieveStripePayment =
      path + "/api/user/retrieve-stripe-payment-intent";

  static const transactionList = path + "/api/user/transaction-list";
  static const disclaimer_terms = path + "/api/cms/terms_and_condition";
  static const about_us = path + "/api/cms/about_us";
  static const fileUploadUrl = path + "/api/user/file-upload";
  static const agoraToken = path + "/api/user/agora-token";
  static const coverPictureUpdate = path + "/api/user/cover-picture-update";
  static const userPostReport = path + "/api/user/posts/report";
}
