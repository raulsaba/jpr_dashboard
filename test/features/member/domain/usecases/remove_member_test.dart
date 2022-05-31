import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/remove_member.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'member_repository.mock.dart';

void main() {
  late RemoveMember usecase;
  late MockMemberRepository mockMemberRepository;

  group("Remove Member", () {
    setUp(() {
      mockMemberRepository = MockMemberRepository();
      usecase = RemoveMember(mockMemberRepository);
    });

    const int tId = 1;

    test(
      "should remove (archive/innactive) a Member from the repository",
      () async {
        when(mockMemberRepository.removeMember(tId))
            .thenAnswer((_) async => const Right(true));

        final result = await usecase(const RemoveMemberParams(id: tId));

        expect(result, const Right(true));
        verify(mockMemberRepository.removeMember(tId));
      },
    );
  });
}
