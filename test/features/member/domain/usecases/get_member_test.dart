import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/entities/member_entity.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/repositories/member_repository.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/get_member.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'member_repository.mock.dart';

@GenerateMocks([MemberRepository])
void main() {
  late GetMember usecase;
  late MockMemberRepository mockMemberRepository;

  group("Get Member", () {
    setUp(() {
      mockMemberRepository = MockMemberRepository();
      usecase = GetMember(mockMemberRepository);
    });

    const int tId = 1;
    const Member tMember =
        Member(id: 1, name: "Test Name", phoneNumber: "(00) 00000-0000");

    test(
      "should get Member from the repository",
      () async {
        when(mockMemberRepository.getMember(tId))
            .thenAnswer((realInvocation) async => const Right(tMember));

        final result = await usecase(const GetMemberParams(id: tId));

        expect(result, const Right(tMember));
        verify(mockMemberRepository.getMember(tId));
      },
    );
  });
}
