import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_all_usecase.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_event.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_state.dart';

class DoctorListViewModel extends Bloc<DoctorListEvent, DoctorListState> {
  final DoctorGetAllUsecase _doctorGetAllUsecase;

  DoctorListViewModel(this._doctorGetAllUsecase) : super(const DoctorListState.initial()) {
    on<FetchDoctors>(_onFetchDoctors);
  }

  Future<void> _onFetchDoctors(
    FetchDoctors event,
    Emitter<DoctorListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _doctorGetAllUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: failure.message,
        ));
      },
      (doctors) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          doctors: doctors,
          errorMessage: null,
        ));
      },
    );
  }
}
