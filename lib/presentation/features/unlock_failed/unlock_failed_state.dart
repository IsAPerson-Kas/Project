part of 'unlock_failed_cubit.dart';

abstract class UnlockFailedState {
  const UnlockFailedState();
}

class UnlockFailedInitial extends UnlockFailedState {}

class UnlockFailedLoading extends UnlockFailedState {}

class UnlockFailedError extends UnlockFailedState {
  final String message;
  const UnlockFailedError({required this.message});
}

class UnlockFailedLoaded extends UnlockFailedState {
  final List<GuardFileModel> files;
  final bool isSelectionMode;
  final Set<int> selectedFileIds;

  const UnlockFailedLoaded({
    required this.files,
    this.isSelectionMode = false,
    this.selectedFileIds = const {},
  });

  UnlockFailedLoaded copyWith({
    List<GuardFileModel>? files,
    bool? isSelectionMode,
    Set<int>? selectedFileIds,
  }) {
    return UnlockFailedLoaded(
      files: files ?? this.files,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedFileIds: selectedFileIds ?? this.selectedFileIds,
    );
  }
}
