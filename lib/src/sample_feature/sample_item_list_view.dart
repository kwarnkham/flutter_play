import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatefulWidget {
  const SampleItemListView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  List<SampleItem> items = [
    const SampleItem(1),
    const SampleItem(2),
    const SampleItem(3)
  ];

  late final GlobalKey<AnimatedListState> _listKey;

  @override
  void initState() {
    _listKey = GlobalKey<AnimatedListState>();
    super.initState();
  }

  @override
  void dispose() {
    _listKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    int index = 0;
                    items.insert(
                      index,
                      SampleItem(DateTime.now().millisecondsSinceEpoch),
                    );
                    _listKey.currentState?.insertItem(index);
                  },
                  child: const Text('add')),
            ],
          ),
          Expanded(
            child: RepaintBoundary(
              child: AnimatedList(
                key: _listKey,
                itemBuilder: (context, index, animation) {
                  final item = items[index];

                  return ListTile(
                      key: ValueKey(item.id),
                      title: Text('SampleItem ${item.id}'),
                      leading: const CircleAvatar(
                        // Display the Flutter Logo image asset.
                        foregroundImage:
                            AssetImage('assets/images/flutter_logo.png'),
                      ),
                      onTap: () {
                        // Navigate to the details page. If the user leaves and returns to
                        // the app after it has been killed while running in the
                        // background, the navigation stack is restored.
                        // Navigator.restorablePushNamed(
                        //   context,
                        //   SampleItemDetailsView.routeName,
                        // );
                        setState(() {
                          items.removeAt(index);
                        });
                      });
                },
                reverse: true,
                // Providing a restorationId allows the ListView to restore the
                // scroll position when a user leaves and returns to the app after it
                // has been killed while running in the background.
                initialItemCount: items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
