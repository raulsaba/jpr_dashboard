import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/member_entity.dart';
import '../repositories/member_repository.dart';

@lazySingleton
class GetMember implements UseCase<Member, GetMemberParams> {
  final MemberRepository repository;

  GetMember(this.repository);

  @override
  Future<Either<Failure, Member>> call(GetMemberParams params) async {
    return await repository.getMember(params.id);
  }
}

class GetMemberParams extends Equatable {
  final int id;

  const GetMemberParams({required this.id});

  @override
  List<Object?> get props => [id];
}
