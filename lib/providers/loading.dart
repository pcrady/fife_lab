import 'package:fife_lab/models/loading_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading.g.dart';

@riverpod
class Loading extends _$Loading {
  @override
  LoadingModel build() {
    return LoadingModel();
  }

  void setLoadingTrue() => state = state.copyWith(loading: true);
  void setLoadingFalse() => state = state.copyWith(
        loading: false,
        loadingValue: null,
        loadingTotal: null,
      );

  void setLoadingValue({
    required double loadingValue,
    required double loadingTotal,
  }) {
    state = state.copyWith(
      loading: true,
      loadingValue: loadingValue,
      loadingTotal: loadingTotal,
    );
  }

  void setLoadingTotal({
    required double loadingTotal,
  }) {
    state = state.copyWith(loadingTotal: loadingTotal);
  }

  void incrementLoadingValue() {
    final previous = state.loadingValue ?? 0.0;
    state = state.copyWith(loadingValue: previous + 1);
  }
}
