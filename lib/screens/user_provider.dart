import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String role;
  final String username;
  final String password;
  final String? name;
  final String? age;
  final String? childName;
  final int? childAge;
  final String? childLevel;
  final String? avatarUrl;
  final String? lastActivity;
  final int? weeklyTime;
  final int? weeklyGoal;
  final double? goalProgress;
  final int? totalMinutes;
  final int? totalLessons;
  final String? averageScore;
  final String? phone;
  final String? qualifications;
  final String? licenseNumber;

  UserState({
    this.role = '',
    this.username = '',
    this.password = '',
    this.name,
    this.age,
    this.childName,
    this.childAge,
    this.childLevel,
    this.avatarUrl,
    this.lastActivity,
    this.weeklyTime,
    this.weeklyGoal,
    this.goalProgress,
    this.totalMinutes,
    this.totalLessons,
    this.averageScore,
    this.phone,
    this.qualifications,
    this.licenseNumber,
  });

  UserState copyWith({
    String? role,
    String? username,
    String? password,
    String? name,
    String? age,
    String? childName,
    int? childAge,
    String? childLevel,
    String? avatarUrl,
    String? lastActivity,
    int? weeklyTime,
    int? weeklyGoal,
    double? goalProgress,
    int? totalMinutes,
    int? totalLessons,
    String? averageScore,
    String? phone,
    String? qualifications,
    String? licenseNumber,
  }) {
    return UserState(
      role: role ?? this.role,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      age: age ?? this.age,
      childName: childName ?? this.childName,
      childAge: childAge ?? this.childAge,
      childLevel: childLevel ?? this.childLevel,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastActivity: lastActivity ?? this.lastActivity,
      weeklyTime: weeklyTime ?? this.weeklyTime,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      goalProgress: goalProgress ?? this.goalProgress,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      totalLessons: totalLessons ?? this.totalLessons,
      averageScore: averageScore ?? this.averageScore,
      phone: phone ?? this.phone,
      qualifications: qualifications ?? this.qualifications,
      licenseNumber: licenseNumber ?? this.licenseNumber,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());

  void updateUser({
    String? role,
    String? username,
    String? password,
    String? name,
    String? age,
    String? childName,
    int? childAge,
    String? childLevel,
    String? avatarUrl,
    String? lastActivity,
    int? weeklyTime,
    int? weeklyGoal,
    double? goalProgress,
    int? totalMinutes,
    int? totalLessons,
    String? averageScore,
    String? phone,
    String? qualifications,
    String? licenseNumber,
  }) {
    state = state.copyWith(
      role: role,
      username: username,
      password: password,
      name: name,
      age: age,
      childName: childName,
      childAge: childAge,
      childLevel: childLevel,
      avatarUrl: avatarUrl,
      lastActivity: lastActivity,
      weeklyTime: weeklyTime,
      weeklyGoal: weeklyGoal,
      goalProgress: goalProgress,
      totalMinutes: totalMinutes,
      totalLessons: totalLessons,
      averageScore: averageScore,
      phone: phone,
      qualifications: qualifications,
      licenseNumber: licenseNumber,
    );
  }

  void clearUser() {
    state = UserState();
  }
}

// ✅ الـ Provider الأساسي
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
