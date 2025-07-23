import 'package:equatable/equatable.dart';

abstract class DoctorListEvent extends Equatable {
  const DoctorListEvent();

  @override
  List<Object?> get props => [];
}

class FetchDoctors extends DoctorListEvent {
  const FetchDoctors();
}
