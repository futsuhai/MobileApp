// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserEntity _$$_UserEntityFromJson(Map<String, dynamic> json) =>
    _$_UserEntity(
      email: json['email'] as String,
      username: json['username'] as String,
      id: json['id'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      trueId: json['trueId'] as String?,
    );

Map<String, dynamic> _$$_UserEntityToJson(_$_UserEntity instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'id': instance.id,
      'description': instance.description,
      'image': instance.image,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'trueId': instance.trueId,
    };
