import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import '../providers/auth_provider.dart';

final employeeServiceProvider = Provider<EmployeeService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return EmployeeService(dioClient.dio);
});

final employeesProvider = FutureProvider<List<Employee>>((ref) async {
  final service = ref.watch(employeeServiceProvider);
  return await service.getAllEmployees();
});

class EmployeeNotifier {
  final Ref ref;
  EmployeeNotifier(this.ref);

  Future<bool> deleteEmployee(int id) async {
    try {
      await ref.read(employeeServiceProvider).deleteEmployee(id);
      ref.invalidate(employeesProvider);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final employeeNotifierProvider = Provider<EmployeeNotifier>((ref) {
  return EmployeeNotifier(ref);
});
