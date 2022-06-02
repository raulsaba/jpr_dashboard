import 'dart:convert';

import 'package:flutter_jpr_dashboard/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../models/member_model.dart';

abstract class MemberRemoteDataSource {
  Future<List<MemberModel>> getMemberList();
  Future<MemberModel> getMember(int id);
  Future<MemberModel> createMember(MemberModel memberModel);
  Future<MemberModel> updateMember(int id, MemberModel member);
  Future<bool> removeMember(int id);
}

@LazySingleton(as: MemberRemoteDataSource)
class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  final http.Client client;

  MemberRemoteDataSourceImpl({required this.client});

  @override
  Future<MemberModel> createMember(MemberModel memberModel) async {
    final response =
        await client.post(Uri.http("jprapi", "/api/v1/member/"), headers: {
      'Content-Type': 'application/json',
    }, body: {
      "newMember": memberModel.toJson(),
    });
    if (response.statusCode == 201) {
      return MemberModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<http.Response> _getFromPath(String path) {
    return client.get(Uri.http("jprapi", path), headers: {
      'Content-Type': 'application/json',
    });
  }

  @override
  Future<MemberModel> getMember(int id) async {
    final response = await _getFromPath("/api/v1/member/$id");
    if (response.statusCode == 200) {
      return MemberModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MemberModel>> getMemberList() async {
    final response = await _getFromPath("/api/v1/member/");
    if (response.statusCode == 200) {
      return MemberModel.fromJsonList(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> removeMember(int id) async {
    final response = await client.delete(
      Uri.http("jprapi", "/api/v1/member/$id"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MemberModel> updateMember(int id, MemberModel memberModel) async {
    final response =
        await client.put(Uri.http("jprapi", "/api/v1/member/$id"), headers: {
      'Content-Type': 'application/json',
    }, body: {
      "member": memberModel.toJson(),
    });
    if (response.statusCode == 200) {
      return MemberModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
