import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/entities/member_entity.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/create_member.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'member_repository.mock.dart';

void main() {
  late CreateMember usecase;
  late MockMemberRepository mockMemberRepository;

  group("Create Member", () {
    setUp(() {
      mockMemberRepository = MockMemberRepository();
      usecase = CreateMember(mockMemberRepository);
    });

    const Member tNewMember =
        Member(name: "Test Name", phoneNumber: "(00) 00000-0000");

    const Member tMember =
        Member(id: 1, name: "Test Name", phoneNumber: "(00) 00000-0000");

    test(
      "should create a Member from the repository",
      () async {
        when(mockMemberRepository.createMember(tNewMember))
            .thenAnswer((_) async => const Right(tMember));

        final result = await usecase(const CreateMemberParams(tNewMember));

        expect(result, const Right(tMember));
        verify(mockMemberRepository.createMember(tNewMember));
      },
    );
  });
}
