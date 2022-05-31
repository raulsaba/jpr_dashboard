import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/core/error/exceptions.dart';
import 'package:flutter_jpr_dashboard/core/error/failure.dart';
import 'package:flutter_jpr_dashboard/core/network/network_info.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/datasources/member_local_datasource.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/datasources/member_remote_datasource.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/models/member_model.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/repositories/member_repository_impl.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/entities/member_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'member_repository_impl_test.mocks.dart';

@GenerateMocks([MemberRemoteDataSource, MemberLocalDataSource, NetworkInfo])
void main() {
  late MembersRepositoryImpl repository;
  late MockMemberRemoteDataSource mockRemoteDataSource;
  late MockMemberLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockMemberRemoteDataSource();
    mockLocalDataSource = MockMemberLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MembersRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('Member Repository', () {
    void setUpDeviceIsOnline() {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
    }

    void testDeviceIsOfline(Function call) {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => false);

      expect(call(), throwsA(const TypeMatcher<NetworkException>()));
    }

    group("getMemberList", () {
      const List<MemberModel> tMemberModels = [
        MemberModel(id: 1, name: "Test Name 1", phoneNumber: "(11) 11111-1111"),
        MemberModel(id: 2, name: "Test Name 2", phoneNumber: "(22) 22222-2222"),
        MemberModel(id: 3, name: "Test Name 3", phoneNumber: "(33) 33333-3333"),
        MemberModel(id: 4, name: "Test Name 4", phoneNumber: "(44) 44444-4444"),
      ];
      const List<Member> tMembers = tMemberModels;

      test(
        "should check if the device is online",
        () async {
          when(mockNetworkInfo.isConnected)
              .thenAnswer((realInvocation) async => true);

          when(mockRemoteDataSource.getMemberList())
              .thenAnswer((realInvocation) async => tMemberModels);

          repository.getMemberList();

          verify(mockNetworkInfo.isConnected);
        },
      );

      group("Device is Online", () {
        setUpDeviceIsOnline();
        test(
          "should return remote data when the call to remote data source is successful",
          () async {
            when(mockRemoteDataSource.getMemberList())
                .thenAnswer((realInvocation) async => tMemberModels);

            final result = await repository.getMemberList();

            verify(mockRemoteDataSource.getMemberList());
            expect(result, equals(const Right(tMembers)));
          },
        );

        // test(
        //   "should cache the data locally when the call to remote data source is successful",
        //   () async {
        //     when(mockRemoteDataSource.getMemberList())
        //         .thenAnswer((realInvocation) async => tMemberModels);

        //     await repository.getMemberList();

        //     verify(mockRemoteDataSource.getMemberList());
        //     verify(mockLocalDataSource.cacheMemberList(tMemberModels));
        //   },
        // );

        test(
          "should return failure when the call to remote data source is unsuccessful",
          () async {
            when(mockRemoteDataSource.getMemberList())
                .thenThrow(ServerException());

            final result = await repository.getMemberList();

            verify(mockRemoteDataSource.getMemberList());
            verifyZeroInteractions(mockLocalDataSource);

            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      group("Device is Offline", () {
        test(
          "should throw NetworkException when called with the device offline",
          () async {
            testDeviceIsOfline(() => repository.getMemberList());
          },
        );
      });
    });

    group('getMember', () {
      const tId = 1;
      const tMemberModel =
          MemberModel(id: 1, name: "Test Name", phoneNumber: "(00) 00000-0000");
      const Member tMember = tMemberModel;

      test(
        "should check if the device is online",
        () async {
          when(mockNetworkInfo.isConnected)
              .thenAnswer((realInvocation) async => true);

          when(mockRemoteDataSource.getMember(any))
              .thenAnswer((realInvocation) async => tMemberModel);

          repository.getMember(tId);

          verify(mockNetworkInfo.isConnected);
        },
      );

      group("Device is Online", () {
        setUpDeviceIsOnline();
        test(
          "should return remote data when the call to remote data source is successful",
          () async {
            when(mockRemoteDataSource.getMember(any))
                .thenAnswer((realInvocation) async => tMemberModel);

            final result = await repository.getMember(tId);

            verify(mockRemoteDataSource.getMember(tId));
            expect(result, equals(const Right(tMember)));
          },
        );

        test(
          "should return failure when the call to remote data source is unsuccessful",
          () async {
            when(mockRemoteDataSource.getMember(any))
                .thenThrow(ServerException());

            final result = await repository.getMember(tId);

            verify(mockRemoteDataSource.getMember(tId));

            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      group("Device is Offline", () {
        test(
          "should throw NetworkException when called with the device offline",
          () async {
            testDeviceIsOfline(() => repository.getMember(tId));
          },
        );
      });
    });

    group("createMember", () {
      const tMember = Member(
        name: "Test Name",
        phoneNumber: "(00) 00000-0000",
      );
      final tMemberModel = MemberModel.fromMember(tMember);

      test(
        "should check if the device is online",
        () async {
          when(mockNetworkInfo.isConnected)
              .thenAnswer((realInvocation) async => true);

          when(mockRemoteDataSource.createMember(any))
              .thenAnswer((realInvocation) async => tMemberModel);

          repository.createMember(tMemberModel);

          verify(mockNetworkInfo.isConnected);
        },
      );
      group("Device is Online", () {
        setUpDeviceIsOnline();

        test(
          "should return remote data when the call to remote data source is successful",
          () async {
            when(mockRemoteDataSource.createMember(any))
                .thenAnswer((realInvocation) async => tMemberModel);

            final result = await repository.createMember(tMember);

            verify(mockRemoteDataSource.createMember(tMemberModel));
            expect(result, equals(Right(tMemberModel)));
          },
        );

        test(
          "should return failure when the call to remote data source is unsuccessful",
          () async {
            when(mockRemoteDataSource.createMember(any))
                .thenThrow(ServerException());

            final result = await repository.createMember(tMemberModel);

            verify(mockRemoteDataSource.createMember(tMemberModel));

            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      group("Device is Offline", () {
        test(
          "should throw NetworkException when called with the device offline",
          () async {
            testDeviceIsOfline(() => repository.createMember(tMember));
          },
        );
      });
    });

    group("updateMember", () {
      const tMember = Member(
        id: 1,
        name: "Test Name",
        phoneNumber: "(00) 00000-0000",
      );
      final tMemberModel = MemberModel.fromMember(tMember);

      test(
        "should check if the device is online",
        () async {
          when(mockNetworkInfo.isConnected)
              .thenAnswer((realInvocation) async => true);

          when(mockRemoteDataSource.updateMember(any, any))
              .thenAnswer((realInvocation) async => tMemberModel);

          repository.updateMember(tMember.id!, tMemberModel);

          verify(mockNetworkInfo.isConnected);
        },
      );

      group("Device is Online", () {
        setUpDeviceIsOnline();

        test(
          "should return remote data when the call to remote data source is successful",
          () async {
            when(mockRemoteDataSource.updateMember(any, any))
                .thenAnswer((realInvocation) async => tMemberModel);

            final result = await repository.updateMember(tMember.id!, tMember);

            verify(
                mockRemoteDataSource.updateMember(tMember.id!, tMemberModel));
            expect(result, equals(Right(tMemberModel)));
          },
        );

        test(
          "should return failure when the call to remote data source is unsuccessful",
          () async {
            when(mockRemoteDataSource.updateMember(any, any))
                .thenThrow(ServerException());

            final result =
                await repository.updateMember(tMember.id!, tMemberModel);

            verify(
                mockRemoteDataSource.updateMember(tMember.id!, tMemberModel));

            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      group("Device is Offline", () {
        test(
          "should throw NetworkException when called with the device offline",
          () async {
            testDeviceIsOfline(
                () => repository.updateMember(tMember.id!, tMember));
          },
        );
      });
    });

    group("removeMember", () {
      const tId = 1;

      test(
        "should check if the device is online",
        () async {
          when(mockNetworkInfo.isConnected)
              .thenAnswer((realInvocation) async => true);

          when(mockRemoteDataSource.removeMember(any))
              .thenAnswer((realInvocation) async => true);

          repository.removeMember(tId);

          verify(mockNetworkInfo.isConnected);
        },
      );

      group("Device is Online", () {
        setUpDeviceIsOnline();

        test(
          "should return remote data when the call to remote data source is successful",
          () async {
            when(mockRemoteDataSource.removeMember(any))
                .thenAnswer((realInvocation) async => true);

            final result = await repository.removeMember(tId);

            verify(mockRemoteDataSource.removeMember(tId));
            expect(result, equals(const Right(true)));
          },
        );

        test(
          "should return failure when the call to remote data source is unsuccessful",
          () async {
            when(mockRemoteDataSource.removeMember(any))
                .thenThrow(ServerException());

            final result = await repository.removeMember(tId);

            verify(mockRemoteDataSource.removeMember(tId));

            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      group("Device is Offline", () {
        test(
          "should throw NetworkException when called with the device offline",
          () async {
            testDeviceIsOfline(() => repository.removeMember(tId));
          },
        );
      });
    });
  });
}
