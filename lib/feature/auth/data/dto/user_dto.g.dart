// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      description: json['description'],
      accsessToken: json['accsessToken'],
      refreshToken: json['refreshToken'],
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'description': instance.description,
      'accsessToken': instance.accsessToken,
      'refreshToken': instance.refreshToken,
    };
