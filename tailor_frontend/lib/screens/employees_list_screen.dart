import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../providers/employee_provider.dart';

class EmployeesListScreen extends ConsumerWidget {
  const EmployeesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/employees/new'),
              icon: const Icon(Icons.add),
              label: const Text('Add Employee'),
            ),
          )
        ],
      ),
      body: employeesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (employees) {
          if (employees.isEmpty) {
            return const Center(child: Text('No employees found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                    child: const Icon(Icons.badge, color: AppTheme.secondaryColor),
                  ),
                  title: Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${employee.formatId} • ${employee.role}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppTheme.secondaryColor),
                        onPressed: () {
                          context.go('/employees/edit/${employee.id}', extra: employee);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Delete Employee?'),
                              content: const Text('Are you sure you want to delete this employee? This cannot be undone.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () => Navigator.pop(c, true),
                                  child: const Text('Delete', style: TextStyle(color: AppTheme.errorColor)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            if (employee.id != null) {
                              final success = await ref.read(employeeNotifierProvider).deleteEmployee(employee.id!);
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Employee deleted')),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
