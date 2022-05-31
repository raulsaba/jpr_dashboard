import 'dart:convert';

import 'package:flutter_jpr_dashboard/core/error/exceptions.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/datasources/member_remote_datasource.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/models/member_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'member_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late MemberRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockClient();
    dataSource = MemberRemoteDataSourceImpl(client: mockClient);
  });

  group('Member Remote DataSource', () {
    void setUpMockHttpClientGETFailure404() {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response("Something went wrong", 404));
    }

    group("getMemberList", () {
      void setUpMockHttpClientGETSuccess200ListResponse() {
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (realInvocation) async =>
                http.Response(fixture('members_list.json'), 200));
      }

      final tMemberModelList =
          MemberModel.fromJsonList(json.decode(fixture('members_list.json')));
      test(
        "should perform a GET request on URL with no number being the endpoint",
        () async {
          setUpMockHttpClientGETSuccess200ListResponse();
          dataSource.getMemberList();

          verify(
              mockClient.get(Uri.http("jprapi", "/api/v1/member/"), headers: {
            'Content-Type': 'application/json',
          }));
        },
      );

      test(
        "should return a List of MemberModel when perform a GET request on URL",
        () async {
          setUpMockHttpClientGETSuccess200ListResponse();
          final result = await dataSource.getMemberList();

          expect(result, equals(tMemberModelList));
        },
      );

      test(
        "should throw a ServerException when the response code is a 404 or other",
        () async {
          setUpMockHttpClientGETFailure404();

          final call = dataSource.getMemberList;

          expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
        },
      );
    });

    group("getMember", () {
      void setUpMockHttpClientGETSuccess200SingleMemberResponse() {
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (realInvocation) async =>
                http.Response(fixture('member.json'), 200));
      }

      const tId = 1;
      final tMemberModel =
          MemberModel.fromJson(json.decode(fixture('member.json')));
      test(
        "should perform a GET request on URL with a number being the endpoint",
        () async {
          setUpMockHttpClientGETSuccess200SingleMemberResponse();
          dataSource.getMember(tId);

          verify(mockClient
              .get(Uri.http("jprapi", "/api/v1/member/$tId"), headers: {
            'Content-Type': 'application/json',
          }));
        },
      );

      test(
        "should return a MemberModel when perform a GET request on URL",
        () async {
          setUpMockHttpClientGETSuccess200SingleMemberResponse();
          final result = await dataSource.getMember(tId);

          expect(result, equals(tMemberModel));
        },
      );

      test(
        "should throw a ServerException when the response code is a 404 or other",
        () async {
          setUpMockHttpClientGETFailure404();

          final call = dataSource.getMember;

          expect(
              () => call(tId), throwsA(const TypeMatcher<ServerException>()));
        },
      );
    });

    group("createMember", () {
      void setUpPOSTMockHttpClientSuccess201Response() {
        when(mockClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((realInvocation) async =>
                http.Response(fixture('member.json'), 201));
      }

      void setUpMockHttpClientPOSTFailure500() {
        when(mockClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((realInvocation) async =>
                http.Response("Something went wrong", 500));
      }

      final tMemberModel =
          MemberModel.fromJson(json.decode(fixture('member.json')));
      test(
        "should perform a POST request on URL",
        () async {
          setUpPOSTMockHttpClientSuccess201Response();
          dataSource.createMember(tMemberModel);

          verify(
              mockClient.post(Uri.http("jprapi", "/api/v1/member/"), headers: {
            'Content-Type': 'application/json',
          }, body: {
            "newMember": tMemberModel.toJson(),
          }));
        },
      );

      test(
        "should return a MemberModel when perform a POST request on URL",
        () async {
          setUpPOSTMockHttpClientSuccess201Response();
          final result = await dataSource.createMember(tMemberModel);

          expect(result, equals(tMemberModel));
        },
      );

      test(
        "should throw a ServerException when the response code is a 404 or other",
        () async {
          setUpMockHttpClientPOSTFailure500();

          final call = dataSource.createMember;

          expect(() => call(tMemberModel),
              throwsA(const TypeMatcher<ServerException>()));
        },
      );
    });

    group("updateMember", () {
      void setUpPUTMockHttpClientSuccess200Response() {
        when(mockClient.put(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((realInvocation) async =>
                http.Response(fixture('member.json'), 200));
      }

      void setUpMockHttpClientPUTFailure500() {
        when(mockClient.put(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((realInvocation) async =>
                http.Response("Something went wrong", 500));
      }

      final tMemberModel =
          MemberModel.fromJson(json.decode(fixture('member.json')));
      test(
        "should perform a PUT request on URL",
        () async {
          setUpPUTMockHttpClientSuccess200Response();
          dataSource.updateMember(tMemberModel.id!, tMemberModel);

          verify(mockClient.put(
              Uri.http("jprapi", "/api/v1/member/${tMemberModel.id!}"),
              headers: {
                'Content-Type': 'application/json',
              },
              body: {
                "member": tMemberModel.toJson(),
              }));
        },
      );

      test(
        "should return a MemberModel when perform a POST request on URL",
        () async {
          setUpPUTMockHttpClientSuccess200Response();
          final result =
              await dataSource.updateMember(tMemberModel.id!, tMemberModel);

          expect(result, equals(tMemberModel));
        },
      );

      test(
        "should throw a ServerException when the response code is a 404 or other",
        () async {
          setUpMockHttpClientPUTFailure500();

          final call = dataSource.updateMember;

          expect(() => call(tMemberModel.id!, tMemberModel),
              throwsA(const TypeMatcher<ServerException>()));
        },
      );
    });
  });

  group("updateMember", () {
    void setUpDELETEMockHttpClientSuccess200Response() {
      when(mockClient.delete(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response("Successfully deleted", 200));
    }

    void setUpMockHttpClientDELETEFailure404() {
      when(mockClient.delete(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response("Something went wrong", 404));
    }

    const tId = 1;
    test(
      "should perform a PUT request on URL",
      () async {
        setUpDELETEMockHttpClientSuccess200Response();
        dataSource.removeMember(tId);

        verify(mockClient.delete(
          Uri.http("jprapi", "/api/v1/member/$tId"),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      "should return a MemberModel when perform a POST request on URL",
      () async {
        setUpDELETEMockHttpClientSuccess200Response();
        final result = await dataSource.removeMember(tId);

        expect(result, equals(true));
      },
    );

    test(
      "should throw a ServerException when the response code is a 404 or other",
      () async {
        setUpMockHttpClientDELETEFailure404();

        final call = dataSource.removeMember;

        expect(() => call(tId), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
