import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/core/usecases/usecase.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/entities/member_entity.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/get_member_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'member_repository.mock.dart';

void main() {
  late GetMemberList usecase;
  late MockMemberRepository mockMemberRepository;

  group("Get Member List", () {
    setUp(() {
      mockMemberRepository = MockMemberRepository();
      usecase = GetMemberList(mockMemberRepository);
    });

    const List<Member> tMembers = [
      Member(id: 1, name: "Test Name 1", phoneNumber: "(11) 11111-1111"),
      Member(id: 2, name: "Test Name 2", phoneNumber: "(22) 22222-2222"),
      Member(id: 3, name: "Test Name 3", phoneNumber: "(33) 33333-3333"),
      Member(id: 4, name: "Test Name 4", phoneNumber: "(44) 44444-4444"),
    ];

    test(
      "should get a list of Members from the repository",
      () async {
        when(mockMemberRepository.getMemberList())
            .thenAnswer((_) async => const Right(tMembers));

        final result = await usecase(NoParams());

        expect(result, const Right(tMembers));
        verify(mockMemberRepository.getMemberList());
      },
    );
  });
}
