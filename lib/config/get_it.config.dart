// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i5;
import 'package:shared_preferences/shared_preferences.dart' as _i8;

import '../core/network/network_info.dart' as _i7;
import '../core/util/input_converter.dart' as _i4;
import '../feature/member/data/datasources/member_local_datasource.dart' as _i9;
import '../feature/member/data/datasources/member_remote_datasource.dart'
    as _i6;
import '../feature/member/data/repositories/member_repository_impl.dart'
    as _i11;
import '../feature/member/domain/repositories/member_repository.dart' as _i10;
import '../feature/member/domain/usecases/create_member.dart' as _i14;
import '../feature/member/domain/usecases/get_member.dart' as _i15;
import '../feature/member/domain/usecases/get_member_list.dart' as _i16;
import '../feature/member/domain/usecases/remove_member.dart' as _i12;
import '../feature/member/domain/usecases/update_member.dart' as _i13;
import '../feature/member/presentation/bloc/member_bloc.dart' as _i17;
import 'register_modules.dart' as _i18; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModules = _$RegisterModules();
  gh.factory<_i3.Client>(() => registerModules.client);
  gh.lazySingleton<_i4.InputConverter>(() => _i4.InputConverter());
  gh.factory<_i5.InternetConnectionChecker>(
      () => registerModules.internetConnectionChecker);
  gh.lazySingleton<_i6.MemberRemoteDataSource>(
      () => _i6.MemberRemoteDataSourceImpl(client: get<_i3.Client>()));
  gh.lazySingleton<_i7.NetworkInfo>(
      () => _i7.NetworkInfoImpl(get<_i5.InternetConnectionChecker>()));
  await gh.factoryAsync<_i8.SharedPreferences>(() => registerModules.prefs,
      preResolve: true);
  gh.lazySingleton<_i9.MemberLocalDataSource>(
      () => _i9.MemberLocalDataSourceImpl(get<_i8.SharedPreferences>()));
  gh.lazySingleton<_i10.MemberRepository>(() => _i11.MembersRepositoryImpl(
      remoteDataSource: get<_i6.MemberRemoteDataSource>(),
      localDataSource: get<_i9.MemberLocalDataSource>(),
      networkInfo: get<_i7.NetworkInfo>()));
  gh.lazySingleton<_i12.RemoveMember>(
      () => _i12.RemoveMember(get<_i10.MemberRepository>()));
  gh.lazySingleton<_i13.UpdateMember>(
      () => _i13.UpdateMember(get<_i10.MemberRepository>()));
  gh.lazySingleton<_i14.CreateMember>(
      () => _i14.CreateMember(get<_i10.MemberRepository>()));
  gh.lazySingleton<_i15.GetMember>(
      () => _i15.GetMember(get<_i10.MemberRepository>()));
  gh.lazySingleton<_i16.GetMemberList>(
      () => _i16.GetMemberList(get<_i10.MemberRepository>()));
  gh.factory<_i17.MemberBloc>(() => _i17.MemberBloc(
      getMember: get<_i15.GetMember>(),
      getMemberList: get<_i16.GetMemberList>(),
      inputConverter: get<_i4.InputConverter>(),
      createMember: get<_i14.CreateMember>(),
      removeMember: get<_i12.RemoveMember>(),
      updateMember: get<_i13.UpdateMember>()));
  return get;
}

class _$RegisterModules extends _i18.RegisterModules {}
