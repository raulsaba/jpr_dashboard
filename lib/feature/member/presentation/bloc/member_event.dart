part of 'member_bloc.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object> get props => [];
}

class GetMemberListEvent extends MemberEvent {}

class GetMemberEvent extends MemberEvent {
  final String id;

  const GetMemberEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateMemberEvent extends MemberEvent {}

class UpdateMemberEvent extends MemberEvent {
  final String id;

  const UpdateMemberEvent(this.id);

  @override
  List<Object> get props => [id];
}

class RemoveMemberEvent extends MemberEvent {
  final String id;

  const RemoveMemberEvent(this.id);

  @override
  List<Object> get props => [id];
}
