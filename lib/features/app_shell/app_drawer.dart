import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../entity/entity_type_config.dart';

/// Navigation drawer shown on every routed screen.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const List<({String location, String label, IconData icon})>
      _topDestinations = [
    (location: '/', label: 'Dashboard', icon: Icons.home_outlined),
    (location: '/search', label: 'Search', icon: Icons.search),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return NavigationDrawer(
      selectedIndex: _selectedIndex(location),
      onDestinationSelected: (index) {
        context.go(_destinationFor(index).location);
      },
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 20, 16, 8),
          child: Text(
            'VerseKeeper',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const Divider(),
        for (final destination in _topDestinations)
          NavigationDrawerDestination(
            icon: Icon(destination.icon),
            label: Text(destination.label),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 4),
          child: Text(
            'Library',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        for (final type in primaryEntityTypes)
          NavigationDrawerDestination(
            icon: Icon(configOf(type).icon),
            label: Text(configOf(type).label),
          ),
      ],
    );
  }

  int _selectedIndex(String location) {
    if (location == '/') return 0;
    if (location.startsWith('/search')) return 1;
    for (var i = 0; i < primaryEntityTypes.length; i++) {
      if (location == '/library/${primaryEntityTypes[i].name}' ||
          location.startsWith('/library/${primaryEntityTypes[i].name}/')) {
        return i + _topDestinations.length;
      }
    }
    return 0;
  }

  ({String location, String label, IconData icon}) _destinationFor(int index) {
    if (index < _topDestinations.length) return _topDestinations[index];
    final type = primaryEntityTypes[index - _topDestinations.length];
    return (
      location: '/library/${type.name}',
      label: configOf(type).label,
      icon: configOf(type).icon,
    );
  }
}
