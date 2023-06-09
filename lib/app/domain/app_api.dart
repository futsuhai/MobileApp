import 'package:dio/dio.dart';

abstract class AppApi {
  Future<dynamic> singUp({
    required String password,
    required String username,
    required String email,
  });

  Future<dynamic> singIn({
    required String password,
    required String username,
  });

  Future<dynamic> getProfile();

  Future<dynamic> userUpdate({
    String? username,
    String? email,
    String? description,
    String? image,
  });

  Future<dynamic> passwordUpdate({
    required String oldPassword,
    required String newPassword,
  });

  Future<dynamic> refreshToken({String? refreshToken});

  Future<dynamic> request(String path);

  Future<dynamic> fetch(RequestOptions requestOptions);

  Future<dynamic> fetchPosts();

  Future<dynamic> fetchPostsWithId(String id);

  //
  Future<dynamic> fetchPostsWithTrueId(String id);

  Future<dynamic> getProfileWithId(String id);

  Future<dynamic> createPost({String? content, String? image});

  Future<dynamic> deletePost(String id);

  Future<dynamic> getAllUsers();

  Future<dynamic> getAllFriends();

  Future<dynamic> addFriend(String id);

  Future<dynamic> deleteFriend(String id);

  Future<dynamic> fetchChats();

  Future<dynamic> createChat(String id);

  Future<dynamic> deleteChat(String id);

  Future<dynamic> sendMessage(int chatId, String text);

  Future<dynamic> fetchMessages(String id);

  Future<dynamic> deleteMessage(String id);

  Future<dynamic> fetchLastMessage(String id);

}
