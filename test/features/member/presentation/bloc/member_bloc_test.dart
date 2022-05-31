import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/core/error/failure.dart';
import 'package:flutter_jpr_dashboard/core/util/input_converter.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/entities/member_entity.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/create_member.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/get_member.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/get_member_list.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/remove_member.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/update_member.dart';
import 'package:flutter_jpr_dashboard/feature/member/presentation/bloc/member_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'member_bloc_test.mocks.dart';

@GenerateMocks([
  GetMemberList,
  GetMember,
  CreateMember,
  UpdateMember,
  RemoveMember,
  InputConverter
])
void main() {
  late MemberBloc memberBloc;
  late MockGetMember mockGetMember;
  late MockGetMemberList mockGetMemberList;
  late MockCreateMember mockCreateMember;
  late MockUpdateMember mockUpdateMember;
  late MockRemoveMember mockRemoveMember;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockCreateMember = MockCreateMember();
    mockGetMemberList = MockGetMemberList();
    mockGetMember = MockGetMember();
    mockRemoveMember = MockRemoveMember();
    mockUpdateMember = MockUpdateMember();
    mockInputConverter = MockInputConverter();

    memberBloc = MemberBloc(
      getMember: mockGetMember,
      getMemberList: mockGetMemberList,
      inputConverter: mockInputConverter,
      createMember: mockCreateMember,
      removeMember: mockRemoveMember,
      updateMember: mockUpdateMember,
    );
  });

  group('Member Bloc', () {
    group("GetMemberEvent", () {
      const tNumberString = '1';
      const tNumberParsed = 1;
      const tMembber =
          Member(id: 1, name: "Test Name", phoneNumber: "(00) 00000-0000");

      test(
        "shoudl call the InputConverter to validate and convert the string to an unsigned integer",
        () async {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(const Right(tNumberParsed));

          memberBloc.add(const GetMemberEvent(tNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );

      test(
        "emits [MemberError] when getMemberEvent is added.",
        () async {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
          memberBloc.add(const GetMemberEvent(tNumberString));

          final expected = [
            MemberInitial(),
            const MemberError(message: INPUT_FAILURE_MESSAGE)
          ];
          expectLater(memberBloc.state, emitsInOrder(expected));
        },
      );

      blocTest<MemberBloc, MemberState>(
        'emits [MemberError] when getMemberEvent is added.',
        build: () => memberBloc,
        act: (bloc) {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
          bloc.add(const GetMemberEvent(tNumberString));
        },
        expect: () =>
            const <MemberState>[MemberError(message: INPUT_FAILURE_MESSAGE)],
      );
    });
  });
}
