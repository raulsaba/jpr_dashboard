part of 'member_bloc.dart';

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberLoaded extends MemberState {
  final List<Member> memberList;

  const MemberLoaded(this.memberList);

  @override
  List<Object> get props => [memberList];
}

class MemberError extends MemberState {
  final String message;

  const MemberError({required this.message});

  @override
  List<Object> get props => [message];
}
