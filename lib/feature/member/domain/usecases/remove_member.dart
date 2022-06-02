import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/member_repository.dart';

@lazySingleton
class RemoveMember implements UseCase<bool, RemoveMemberParams> {
  final MemberRepository repository;

  RemoveMember(this.repository);

  @override
  Future<Either<Failure, bool>> call(RemoveMemberParams params) async {
    return await repository.removeMember(params.id);
  }
}

class RemoveMemberParams extends Equatable {
  final int id;

  const RemoveMemberParams({required this.id});

  @override
  List<Object?> get props => [id];
}
