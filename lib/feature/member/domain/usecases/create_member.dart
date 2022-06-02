import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/member_entity.dart';
import '../repositories/member_repository.dart';

@lazySingleton
class CreateMember implements UseCase<Member, CreateMemberParams> {
  final MemberRepository repository;

  CreateMember(this.repository);

  @override
  Future<Either<Failure, Member>> call(CreateMemberParams params) async {
    return await repository.createMember(params.newMember);
  }
}

class CreateMemberParams extends Equatable {
  final Member newMember;

  const CreateMemberParams(this.newMember);

  @override
  List<Object?> get props => [newMember];
}
