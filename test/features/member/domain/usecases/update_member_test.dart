import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/entities/member_entity.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/update_member.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'member_repository.mock.dart';

void main() {
  late UpdateMember usecase;
  late MockMemberRepository mockMemberRepository;

  group("Update Member", () {
    setUp(() {
      mockMemberRepository = MockMemberRepository();
      usecase = UpdateMember(mockMemberRepository);
    });

    const int tId = 1;

    const Member tMember =
        Member(id: 1, name: "Test Name", phoneNumber: "(00) 00000-0000");

    test(
      "should create a Member from the repository",
      () async {
        when(mockMemberRepository.updateMember(tId, tMember))
            .thenAnswer((_) async => const Right(tMember));

        final result =
            await usecase(const UpdateMemberParams(id: tId, member: tMember));

        expect(result, const Right(tMember));
        verify(mockMemberRepository.updateMember(tId, tMember));
      },
    );
  });
}
