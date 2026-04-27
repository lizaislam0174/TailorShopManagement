import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/measurement.dart';
import '../services/measurement_service.dart';
import '../core/network/dio_client.dart';
import '../providers/auth_provider.dart';

final measurementServiceProvider = Provider<MeasurementService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MeasurementService(dioClient.dio);
});

class MeasurementFormScreen extends ConsumerStatefulWidget {
  final int customerId;

  const MeasurementFormScreen({super.key, required this.customerId});

  @override
  ConsumerState<MeasurementFormScreen> createState() => _MeasurementFormScreenState();
}

class _MeasurementFormScreenState extends ConsumerState<MeasurementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _chestController;
  late TextEditingController _waistController;
  late TextEditingController _hipsController;
  late TextEditingController _lengthController;
  late TextEditingController _notesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chestController = TextEditingController();
    _waistController = TextEditingController();
    _hipsController = TextEditingController();
    _lengthController = TextEditingController();
    _notesController = TextEditingController();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final measurement = Measurement(
          customerId: widget.customerId,
          chest: double.tryParse(_chestController.text) ?? 0.0,
          waist: double.tryParse(_waistController.text) ?? 0.0,
          hips: double.tryParse(_hipsController.text) ?? 0.0,
          length: double.tryParse(_lengthController.text) ?? 0.0,
          notes: _notesController.text.trim(),
        );

        await ref.read(measurementServiceProvider).createOrUpdateMeasurement(measurement);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Measurement saved successfully!')));
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Measurement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _chestController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Chest (inches/cm)'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _waistController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Waist (inches/cm)'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hipsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Hips (inches/cm)'),
                  ),
                   const SizedBox(height: 16),
                  TextFormField(
                    controller: _lengthController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Length (inches/cm)'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Additional Notes'),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Measurement'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
