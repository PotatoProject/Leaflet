import 'package:flutter/material.dart';
import 'package:potato_notes/internal/extensions.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/widget/dependent_scaffold.dart';

class SearchPage extends StatefulWidget {
  final CustomSearchDelegate delegate;

  const SearchPage({
    Key? key,
    required this.delegate,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState<T> extends State<SearchPage> {
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.delegate._queryTextController.addListener(_onQueryChanged);
    widget.delegate.focusNode = focusNode;
    widget.delegate._setState = setState;
  }

  @override
  void dispose() {
    widget.delegate._queryTextController.removeListener(_onQueryChanged);
    widget.delegate.focusNode = null;
    focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    if (!mounted) return;

    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onSearchBodyChanged() {
    if (!mounted) return;

    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = widget.delegate.buildResults(context);
    final Widget? leading = widget.delegate.buildLeading(context);

    return DependentScaffold(
      appBar: AppBar(
        leading: leading,
        title: TextField(
          controller: widget.delegate._queryTextController,
          focusNode: focusNode,
          decoration: InputDecoration.collapsed(
            hintText: LocaleStrings.search.textboxHint,
          ),
          autofocus: true,
          onChanged: (value) => _onSearchBodyChanged(),
        ),
        titleSpacing: leading != null &&
                (deviceInfo.uiSizeFactor > 3 || deviceInfo.isLandscape)
            ? 0
            : null,
        actions: widget.delegate.buildActions(context),
      ),
      resizeToAvoidBottomInset: false,
      useAppBarAsSecondary: true,
      body: body,
    );
  }
}

abstract class CustomSearchDelegate<T> {
  CustomSearchDelegate({
    this.searchFieldLabel,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
  });

  Widget buildResults(BuildContext context);

  List<Widget> buildActions(BuildContext context);

  Widget? buildLeading(BuildContext context) => null;

  String get query => _queryTextController.text;
  set query(String value) {
    _queryTextController.text = value;
  }

  void close(BuildContext context) {
    focusNode?.unfocus();
    context.pop();
  }

  final String? searchFieldLabel;

  final TextInputType? keyboardType;

  final TextInputAction textInputAction;

  Animation<double> get transitionAnimation => _proxyAnimation;

  FocusNode? focusNode;

  final TextEditingController _queryTextController = TextEditingController();

  final ProxyAnimation _proxyAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);

  void Function(VoidCallback)? _setState;

  void Function(VoidCallback)? get setState => _setState;
}
