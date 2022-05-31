import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_jpr_dashboard/core/util/input_converter.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/create_member.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/get_member.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/get_member_list.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/remove_member.dart';
import 'package:flutter_jpr_dashboard/feature/member/domain/usecases/update_member.dart';

import '../../domain/entities/member_entity.dart';

part 'member_event.dart';
part 'member_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String NETWORK_FAILURE_MESSAGE = 'Network Failure';
const String INPUT_FAILURE_MESSAGE =
    'Input Failure - the number must be a positive and an integer';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc({
    required this.getMember,
    required this.getMemberList,
    required this.inputConverter,
    required this.createMember,
    required this.removeMember,
    required this.updateMember,
  }) : super(MemberInitial()) {
    on<MemberEvent>((event, emit) {
      if (event is GetMemberEvent) {
        final inputEither = inputConverter.stringToUnsignedInteger(event.id);
        // inputEither.fold(
        //     (failure) =>
        //         emit.call(const MemberError(message: INPUT_FAILURE_MESSAGE)),
        //     (integer) {
        //   throw UnimplementedError();
        // });

        emit.call(const MemberError(message: INPUT_FAILURE_MESSAGE));
      }
    });
  }

  final GetMember getMember;
  final GetMemberList getMemberList;
  final InputConverter inputConverter;
  final CreateMember createMember;
  final RemoveMember removeMember;
  final UpdateMember updateMember;
}
