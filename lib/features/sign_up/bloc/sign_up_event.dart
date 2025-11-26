part of 'sign_up_bloc.dart';

abstract class SignUpEvent{}

class SignUpUserEvent extends SignUpEvent{
  BuildContext context;
  String email;
  String name;
  SignUpUserEvent({required this.email ,required this.name,required this.context, });
}


