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
}
