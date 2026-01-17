import 'package:equatable/equatable.dart';
import '../../../product/models/birthday_model.dart';

abstract class BirthdayEvent extends Equatable {
  const BirthdayEvent();

  @override
  List<Object?> get props => [];
}

class BirthdayLoadRequested extends BirthdayEvent {
  final String userId;

  const BirthdayLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class BirthdayAddRequested extends BirthdayEvent {
  final BirthdayModel birthday;

  const BirthdayAddRequested(this.birthday);

  @override
  List<Object?> get props => [birthday];
}

class BirthdayUpdateRequested extends BirthdayEvent {
  final BirthdayModel birthday;

  const BirthdayUpdateRequested(this.birthday);

  @override
  List<Object?> get props => [birthday];
}

class BirthdayDeleteRequested extends BirthdayEvent {
  final String birthdayId;

  const BirthdayDeleteRequested(this.birthdayId);

  @override
  List<Object?> get props => [birthdayId];
}

class BirthdaySearchQueryChanged extends BirthdayEvent {
  final String query;

  const BirthdaySearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
