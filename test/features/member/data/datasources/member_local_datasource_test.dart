import 'dart:convert';

import 'package:flutter_jpr_dashboard/core/error/exceptions.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/datasources/member_local_datasource.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/models/member_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'member_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MemberLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = MemberLocalDataSourceImpl(mockSharedPreferences);
  });

  group('Member Local Datasource', () {
    group("getLastMemberList", () {
      List<MemberModel> tMemberModels = MemberModel.fromJsonList(
          json.decode(fixture('cache_member_list.json')));

      test(
        "should return LastMemberList from SharedPreferences when there is present on cache",
        () async {
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture("cache_member_list.json"));

          final result = await dataSource.getLastMemberList();

          verify(mockSharedPreferences.getString(CACHED_MEMBER_LIST));
          expect(result, equals(tMemberModels));
        },
      );
      test(
        "should return CacheFailure when there is no value present on cache",
        () async {
          when(mockSharedPreferences.getString(any)).thenReturn(null);

          final call = dataSource.getLastMemberList;

          expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
        },
      );
    });
    group("cacheMemberList", () {
      const List<MemberModel> tMembersModelList = [
        MemberModel(id: 1, name: "Test Name 1", phoneNumber: "(11) 11111-1111"),
        MemberModel(id: 2, name: "Test Name 2", phoneNumber: "(22) 22222-2222"),
        MemberModel(id: 3, name: "Test Name 3", phoneNumber: "(33) 33333-3333"),
        MemberModel(id: 4, name: "Test Name 4", phoneNumber: "(44) 44444-4444"),
      ];

      test(
        "should call SheredPreferences to cache the data",
        () async {
          when(mockSharedPreferences.setString(any, any))
              .thenAnswer((_) async => true);

          dataSource.cacheMemberList(tMembersModelList);

          final expectedJsonString = json.encode(tMembersModelList);
          verify(mockSharedPreferences.setString(
              CACHED_MEMBER_LIST, expectedJsonString));
        },
      );
    });
  });
}
