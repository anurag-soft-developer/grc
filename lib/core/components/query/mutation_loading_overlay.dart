import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:grc/components/shared/loading_overlay.dart';

/// Wraps [child] with a loading overlay driven by [useMutation] state.
class MutationLoadingOverlay extends HookWidget {
  final List<Object?> mutationKey;
  final Widget child;

  const MutationLoadingOverlay({
    super.key,
    required this.mutationKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final client = useQueryClient();
    final pending = client.isMutating(
      mutationKey: mutationKey,
      exact: true,
    ) > 0;

    return LoadingOverlay(isLoading: pending, child: child);
  }
}
