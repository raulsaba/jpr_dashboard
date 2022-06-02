// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_jpr_dashboard/core/error/exceptions.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/member_model.dart';

const CACHED_MEMBER_LIST = 'CACHED_MEMBER_LIST';

abstract class MemberLocalDataSource {
  Future<List<MemberModel>> getLastMemberList();
  Future<void> cacheMemberList(List<MemberModel> memberListToCache);
}

@LazySingleton(as: MemberLocalDataSource)
class MemberLocalDataSourceImpl implements MemberLocalDataSource {
  final SharedPreferences sharedPreferences;

  MemberLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheMemberList(List<MemberModel> memberListToCache) {
    return sharedPreferences.setString(
        CACHED_MEMBER_LIST, jsonEncode(memberListToCache));
  }

  @override
  Future<List<MemberModel>> getLastMemberList() {
    final jsonString = sharedPreferences.getString(CACHED_MEMBER_LIST);
    if (jsonString != null) {
      return Future.value(MemberModel.fromJsonList(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
