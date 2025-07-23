import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/queue/domain/use_case/get_queue_status_usecase.dart';
import 'queue_event.dart';
import 'queue_state.dart';

class QueueViewModel extends Bloc<QueueEvent, QueueState> {
  final GetQueueStatusUseCase getQueueStatusUseCase;

  QueueViewModel({
    required this.getQueueStatusUseCase,
  }) : super(QueueState.initial()) {
    on<FetchQueueStatus>(_onFetchQueueStatus);
  }

  Future<void> _onFetchQueueStatus(
    FetchQueueStatus event,
    Emitter<QueueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getQueueStatusUseCase.call(event.patientId);

    result.fold(
      (failure) => emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: failure.message,
          )),
      (queueStatus) => emit(state.copyWith(
            isLoading: false,
            isSuccess: true,
            queueStatus: queueStatus,
            errorMessage: null,
          )),
    );
  }
}
