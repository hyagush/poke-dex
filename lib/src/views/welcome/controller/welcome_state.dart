part of 'welcome_controller.dart';

enum WelcomeStatus { initial, failure, success, loading }

class WelcomeState extends Equatable {
  final WelcomeStatus status;
  final String? warningMessage;

  const WelcomeState._({required this.status, this.warningMessage});

  const WelcomeState.initial() : this._(status: WelcomeStatus.initial);

  @override
  List<Object?> get props => [status, warningMessage];

  WelcomeState copyWith({
    WelcomeStatus? status,
    String? warningMessage,
  }) {
    return WelcomeState._(
      status: status ?? this.status,
      warningMessage: warningMessage ?? this.warningMessage,
    );
  }
}
