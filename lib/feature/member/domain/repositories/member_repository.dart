import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/models/member_model.dart';

import '../../../../core/error/failure.dart';
import '../entities/member_entity.dart';

abstract class MemberRepository {
  Future<Either<Failure, List<Member>>> getMemberList();
  Future<Either<Failure, Member>> getMember(int id);
  Future<Either<Failure, Member>> createMember(Member newMember);
  Future<Either<Failure, Member>> updateMember(int id, Member member);
  Future<Either<Failure, bool>> removeMember(int id);
}
