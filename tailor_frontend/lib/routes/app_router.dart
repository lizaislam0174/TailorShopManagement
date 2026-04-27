import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/main_layout.dart';
import '../screens/dashboard_screen.dart';
import '../screens/customers_list_screen.dart';
import '../screens/customer_form_screen.dart';
import '../models/customer.dart';
import '../screens/employees_list_screen.dart';
import '../screens/employee_form_screen.dart';
import '../models/employee.dart';
import '../screens/orders_list_screen.dart';
import '../screens/order_form_screen.dart';
import '../screens/payments_list_screen.dart';
import '../screens/payment_form_screen.dart';
import '../screens/measurement_form_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/customers',
            builder: (context, state) => const CustomersListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const CustomerFormScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final customer = state.extra as Customer?;
                  return CustomerFormScreen(customer: customer);
                },
              ),
              GoRoute(
                path: 'measurements/:id',
                builder: (context, state) {
                  final customerId = int.tryParse(state.pathParameters['id']!) ?? 0;
                  return MeasurementFormScreen(customerId: customerId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/employees',
            builder: (context, state) => const EmployeesListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const EmployeeFormScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final employee = state.extra as Employee?;
                  return EmployeeFormScreen(employee: employee);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const OrderFormScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/payments',
            builder: (context, state) => const PaymentsListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const PaymentFormScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
