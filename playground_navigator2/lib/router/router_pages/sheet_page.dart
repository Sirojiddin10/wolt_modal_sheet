import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/router_cubit.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPage extends Page<void> {
  const SheetPage({
    required this.pageIndexNotifier,
    required this.pageListBuilderNotifier,
  }) : super(key: const ValueKey('SheetPage'));

  final ValueNotifier<int> pageIndexNotifier;
  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;

  static const String routeName = 'Modal Sheet';

  @override
  Route<void> createRoute(BuildContext context) {
    return WoltModalSheetRoute<void>(
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilder: pageListBuilderNotifier,
      onModalDismissedWithDrag: () {
        context.read<RouterCubit>().closeSheet();
      },
      onModalDismissedWithBarrierTap: () {
        context.read<RouterCubit>().closeSheet();
      },
      routeSettings: this,
    );
  }

  @override
  String get name => routeName;
}
