import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/core/error/exceptions.dart';
import 'package:flutter_jpr_dashboard/feature/member/data/models/member_model.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/exceptions.dart';

import '../../../../core/network/network_info.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_local_datasource.dart';
import '../datasources/member_remote_datasource.dart';

class MembersRepositoryImpl implements MemberRepository {
  final MemberRemoteDataSource remoteDataSource;
  final MemberLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MembersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Member>> createMember(Member newMember) async {
    if (await networkInfo.isConnected) {
      try {
        final MemberModel newMemberModel = MemberModel.fromMember(newMember);
        final remoteMember =
            await remoteDataSource.createMember(newMemberModel);
        return Right(remoteMember);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<Either<Failure, List<Member>>> getMemberList() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMemberList = await remoteDataSource.getMemberList();
        return Right(remoteMemberList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<Either<Failure, Member>> getMember(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMember = await remoteDataSource.getMember(id);
        return Right(remoteMember);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<Either<Failure, bool>> removeMember(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.removeMember(id);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<Either<Failure, Member>> updateMember(int id, Member member) async {
    if (await networkInfo.isConnected) {
      try {
        final MemberModel newMemberModel = MemberModel.fromMember(member);
        final remoteMember =
            await remoteDataSource.updateMember(id, newMemberModel);
        return Right(remoteMember);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      throw NetworkException();
    }
  }
}
