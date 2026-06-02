import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:grc/components/shared/loading_overlay.dart';

/// Wraps [child] with a loading overlay driven by [useMutation] state.
class MutationLoadingOverlay extends HookWidget {
  final List<Object?>? mutationKey;
  final List<List<Object?>>? mutationKeys;
  final Widget child;

  const MutationLoadingOverlay({
    super.key,
    this.mutationKey,
    this.mutationKeys,
    required this.child,
  }) : assert(
         mutationKey != null || mutationKeys != null,
         'Provide mutationKey or mutationKeys',
       );

  @override
  Widget build(BuildContext context) {
    final client = useQueryClient();
    final keys = mutationKeys ?? [mutationKey!];
    final pending = keys.any(
      (key) => client.isMutating(mutationKey: key, exact: true) > 0,
    );

    return LoadingOverlay(isLoading: pending, child: child);
  }
}
