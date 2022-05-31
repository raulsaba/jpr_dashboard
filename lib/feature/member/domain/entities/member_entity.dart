import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int? id;
  final String name;
  final String phoneNumber;

  const Member({this.id, required this.name, required this.phoneNumber});

  @override
  List<Object?> get props => [id, name];
}
