import 'dart:convert';

import 'package:flutter_jpr_dashboard/feature/member/data/models/member_model.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/entities/member_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  group("Member Model", () {
    setUp(() {});
    const tMemberModel =
        MemberModel(id: 1, name: "Test Name", phoneNumber: "(00) 00000-0000");

    const List<MemberModel> tMembersModelList = [
      MemberModel(id: 1, name: "Test Name 1", phoneNumber: "(11) 11111-1111"),
      MemberModel(id: 2, name: "Test Name 2", phoneNumber: "(22) 22222-2222"),
      MemberModel(id: 3, name: "Test Name 3", phoneNumber: "(33) 33333-3333"),
      MemberModel(id: 4, name: "Test Name 4", phoneNumber: "(44) 44444-4444"),
    ];

    test(
      "should be a subclass of Members entity",
      () async {
        expect(tMemberModel, isA<MemberModel>());
      },
    );

    group('fromJson', () {
      test(
        "should return a valid member model when the JSON return just one member",
        () async {
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('member.json'));

          final result = MemberModel.fromJson(jsonMap);

          expect(result, tMemberModel);
        },
      );

      test(
        "should return a valid list of members model when the JSON return just a list of members",
        () async {
          final result = MemberModel.fromJsonList(
              json.decode(fixture('members_list.json')));

          expect(result, tMembersModelList);
        },
      );
    });

    group("toJson", () {
      test(
        "should return a JSON map containing the proper data",
        () async {
          final result = tMemberModel.toJson();

          final expectedMap = {
            "id": 1,
            "name": "Test Name",
            "phoneNumber": "(00) 00000-0000"
          };

          expect(result, expectedMap);
        },
      );
    });

    group("from Member Entity", () {
      const tMember = Member(name: "Test Name", phoneNumber: "(00) 00000-0000");
      test(
        "should retunr a valid MemberModel when set up from a Member Entity",
        () async {
          final result = MemberModel.fromMember(tMember);

          const expectedMemberModel =
              MemberModel(name: "Test Name", phoneNumber: "(00) 00000-0000");

          expect(result, expectedMemberModel);
        },
      );
    });
  });
}
