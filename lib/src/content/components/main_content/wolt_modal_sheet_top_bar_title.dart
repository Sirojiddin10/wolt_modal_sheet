import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget to display the top bar title in a modal sheet.
///
/// It tries to display the title in the following order of preference:
/// - The `topBarTitle` widget if it's not null.
/// - The text data in `pageTitle` if it's a `Text` widget.
/// - The first text descendant of the `pageTitle` if it's not a `Text` widget and has a
///   [Text] descendant.
/// - If none of the above are applicable, it defaults to a `SizedBox.shrink`.
class WoltModalSheetTopBarTitle extends StatefulWidget {
  const WoltModalSheetTopBarTitle({
    Key? key,
    required this.pageTitleKey,
    required this.topBarTitle,
    required this.pageTitle,
  }) : super(key: key);

  final GlobalKey pageTitleKey;
  final Widget? topBarTitle;
  final Widget? pageTitle;

  @override
  State<WoltModalSheetTopBarTitle> createState() =>
      _WoltModalSheetTopBarTitleState();
}

class _WoltModalSheetTopBarTitleState extends State<WoltModalSheetTopBarTitle> {
  String? pageTitleText;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _extractPageTitleText();
    });
  }

  void _extractPageTitleText() {
    final isPageTitleTextWidget = widget.pageTitle is Text;
    final pageTitleElement = widget.pageTitleKey.currentContext;

    if (widget.topBarTitle != null || isPageTitleTextWidget) {
    } else if (pageTitleElement != null) {
      _visitAllDescendants(pageTitleElement);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topBarTitle = widget.topBarTitle;
    final pageTitleText = (widget.pageTitle is Text)
        ? (widget.pageTitle as Text).data
        : this.pageTitleText;

    if (topBarTitle != null) {
      return topBarTitle;
    } else if (pageTitleText != null) {
      return Text(
        pageTitleText,
        style: Theme.of(context).textTheme.titleSmall,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }
    return const SizedBox.shrink();
  }

  // This function visits all descendants of an Element until it finds a Text widget.
  // It could potentially have a performance impact if the descendant Text widget is deeply nested.
  // However, since it stops visiting as soon as it finds a Text widget,
  // the impact should be minimal unless the widget tree is exceptionally large or dense.
  void _visitAllDescendants(BuildContext element) {
    element.visitChildElements((childElement) {
      if (childElement.widget is Text) {
        setState(() {
          pageTitleText = (childElement.widget as Text).data;
        });
        return; // stop visiting other children
      }
      // If it's not a Text widget, continue visiting its descendants
      _visitAllDescendants(childElement);
    });
  }
}
