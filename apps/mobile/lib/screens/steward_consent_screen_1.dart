import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/steward_cubit.dart';

class StewardConsentScreen1 extends StatefulWidget {
  const StewardConsentScreen1({
    required this.userId,
    required this.ipAddress,
    required this.userAgent,
    super.key,
  });

  final String userId;
  final String ipAddress;
  final String userAgent;

  @override
  State<StewardConsentScreen1> createState() => _StewardConsentScreen1State();
}

class _StewardConsentScreen1State extends State<StewardConsentScreen1> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steward Consent')),
      body: BlocConsumer<StewardCubit, StewardState>(
        listener: (context, state) {
          if (state is StewardAccepted || state is StewardDeclined) {
            Navigator.of(context).pop(state is StewardAccepted);
          }
          if (state is StewardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final submitting = state is StewardSubmitting;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please review and accept KinnectAI Steward terms before proceeding.',
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _accepted,
                  onChanged: submitting
                      ? null
                      : (value) => setState(() => _accepted = value ?? false),
                  title: const Text('I consent to stewardship and data handling terms.'),
                  contentPadding: EdgeInsets.zero,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: submitting
                        ? null
                        : () => context.read<StewardCubit>().submit(
                              userId: widget.userId,
                              accepted: _accepted,
                              ipAddress: widget.ipAddress,
                              userAgent: widget.userAgent,
                            ),
                    child: submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Submit Consent'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
