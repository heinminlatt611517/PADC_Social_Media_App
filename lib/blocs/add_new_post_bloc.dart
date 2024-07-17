import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/analytics/firebase_analytics_tracker.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/remote_config/firebase_remote_config.dart';

class AddNewPostBloc extends ChangeNotifier {
  /// State
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;
  bool isLoading = false;
  UserVO? _loggedInUser;

  Color themeColor = Colors.black;

  /// Image
  File? chosenImageFile;

  /// For Edit Mode
  bool isInEditMode = false;
  String userName = "";
  String profilePicture = "";
  NewsFeedVO? mNewsFeed;

  /// Model
  final SocialModel _model = SocialModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  /// Remote Configs
  final FirebaseRemoteConfigs _firebaseRemoteConfig = FirebaseRemoteConfigs();

  AddNewPostBloc({int? newsFeedId}) {
    _loggedInUser = _authenticationModel.getLoggedInUser();
    if (newsFeedId != null) {
      isInEditMode = true;
      _prepopulateDataForEditMode(newsFeedId);
    } else {
      _prepopulateDataForAddNewPost();
    }

    /// Firebase
    _sendAnalyticsData(addNewPostScreenReached, null);
    _getRemoteConfigAndChangeTheme();
  }

  void _getRemoteConfigAndChangeTheme() {
    themeColor = _firebaseRemoteConfig.getThemeColorFromRemoteConfig();
    _notifySafely();
  }

  void _prepopulateDataForAddNewPost() {
    userName = _loggedInUser?.userName ?? "";
    profilePicture =
        "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
    _notifySafely();
  }

  void _prepopulateDataForEditMode(int newsFeedId) {
    _model.getNewsFeedById(newsFeedId).listen((newsFeed) {
      userName = newsFeed.userName ?? "";
      profilePicture = newsFeed.profilePicture ?? "";
      newPostDescription = newsFeed.description ?? "";
      mNewsFeed = newsFeed;
      _notifySafely();
    });
  }

  void onImageChosen(File imageFile) {
    chosenImageFile = imageFile;
    _notifySafely();
  }

  void onTapDeleteImage() {
    chosenImageFile = null;
    _notifySafely();
  }

  void onNewPostTextChanged(String newPostDescription) {
    this.newPostDescription = newPostDescription;
  }

  Future onTapAddNewPost() {
    if (newPostDescription.isEmpty) {
      isAddNewPostError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isLoading = true;
      _notifySafely();
      isAddNewPostError = false;
      if (isInEditMode) {
        return _editNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
          _sendAnalyticsData(
              editPostAction, {postId: mNewsFeed?.id.toString() ?? ""});
        });
      } else {
        return _createNewNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
          _sendAnalyticsData(addNewPostAction, null);
        });
      }
    }
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future<dynamic> _editNewsFeedPost() {
    mNewsFeed?.description = newPostDescription;
    if (mNewsFeed != null) {
      return _model.editPost(mNewsFeed!, chosenImageFile);
    } else {
      return Future.error("Error");
    }
  }

  Future<void> _createNewNewsFeedPost() {
    return _model.addNewPost(newPostDescription, chosenImageFile);
  }

  /// Analytics
  void _sendAnalyticsData(String name, Map<String, String>? parameters) async {
    await FirebaseAnalyticsTracker().logEvent(name, parameters);
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
