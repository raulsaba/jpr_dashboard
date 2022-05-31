import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/member_entity.dart';
import '../repositories/member_repository.dart';

class GetMemberList implements UseCase<List<Member>, NoParams> {
  final MemberRepository repository;

  GetMemberList(this.repository);

  @override
  Future<Either<Failure, List<Member>>> call(NoParams noParams) async {
    return await repository.getMemberList();
  }
}
