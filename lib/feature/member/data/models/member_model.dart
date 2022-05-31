import '../../domain/entities/member_entity.dart';
import 'dart:convert';

class MemberModel extends Member {
  const MemberModel(
      {int? id, required String name, required String phoneNumber})
      : super(id: id, name: name, phoneNumber: phoneNumber);

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  static List<MemberModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MemberModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  factory MemberModel.fromMember(Member member) {
    return MemberModel(name: member.name, phoneNumber: member.phoneNumber);
  }
}
