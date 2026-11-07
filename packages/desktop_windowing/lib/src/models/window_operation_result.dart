enum WindowOperationStatus {
  completed,
  unchanged,
  unsupportedPlatform,
  windowUnavailable,
  profileNotFound,
  userWindowStatePreserved,
  interruptedByNewRequest,
  interruptedByUser,
  notInitialized,
}

class WindowOperationResult {
  const WindowOperationResult({
    required this.status,
    this.profileId,
    this.message,
  });

  final WindowOperationStatus status;
  final String? profileId;
  final String? message;

  bool get isSuccess =>
      status == WindowOperationStatus.completed ||
      status == WindowOperationStatus.unchanged;
}
