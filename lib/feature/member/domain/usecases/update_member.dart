import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/member_entity.dart';
import '../repositories/member_repository.dart';

@lazySingleton
class UpdateMember implements UseCase<Member, UpdateMemberParams> {
  final MemberRepository repository;

  UpdateMember(this.repository);

  @override
  Future<Either<Failure, Member>> call(UpdateMemberParams params) async {
    return await repository.updateMember(params.id, params.member);
  }
}

class UpdateMemberParams extends Equatable {
  final int id;
  final Member member;

  const UpdateMemberParams({required this.id, required this.member});

  @override
  List<Object?> get props => [id, member];
}
