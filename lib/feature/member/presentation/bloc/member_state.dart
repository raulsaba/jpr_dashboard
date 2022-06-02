part of 'member_bloc.dart';

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class ListMemberLoaded extends MemberState {
  final List<Member> memberList;

  const ListMemberLoaded(this.memberList);

  @override
  List<Object> get props => [memberList];
}

class MemberLoaded extends MemberState {
  final Member member;

  const MemberLoaded(this.member);

  @override
  List<Object> get props => [member];
}

class MemberError extends MemberState {
  final String message;

  const MemberError({required this.message});

  @override
  List<Object> get props => [message];
}
