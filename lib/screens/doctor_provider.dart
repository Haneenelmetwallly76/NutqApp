// doctor_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChildProgress {
  final String name;
  final int age;
  final int level;
  final double progress; // 0.0 - 1.0
  final int weeklyTime;
  final int weeklyGoal;

  ChildProgress({
    required this.name,
    required this.age,
    required this.level,
    required this.progress,
    required this.weeklyTime,
    required this.weeklyGoal,
  });
}

class DoctorState {
  final String name;
  final String qualifications;
  final String licenseNumber;
  final List<ChildProgress> children;

  DoctorState({
    this.name = '',
    this.qualifications = '',
    this.licenseNumber = '',
    this.children = const [],
  });

  DoctorState copyWith({
    String? name,
    String? qualifications,
    String? licenseNumber,
    List<ChildProgress>? children,
  }) {
    return DoctorState(
      name: name ?? this.name,
      qualifications: qualifications ?? this.qualifications,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      children: children ?? this.children,
    );
  }
}

class DoctorNotifier extends StateNotifier<DoctorState> {
  DoctorNotifier() : super(DoctorState());

  void updateDoctor({
    String? name,
    String? qualifications,
    String? licenseNumber,
  }) {
    state = state.copyWith(
      name: name,
      qualifications: qualifications,
      licenseNumber: licenseNumber,
    );
  }

  void addChild(ChildProgress child) {
    state = state.copyWith(children: [...state.children, child]);
  }

  void updateChild(int index, ChildProgress child) {
    final updatedChildren = [...state.children];
    updatedChildren[index] = child;
    state = state.copyWith(children: updatedChildren);
  }
}

final doctorProvider = StateNotifierProvider<DoctorNotifier, DoctorState>((ref) {
  return DoctorNotifier();
});
