import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../dashboard/dashboard_screen.dart';
import '../entity/entity_detail_screen.dart';
import '../entity/entity_edit_screen.dart';
import '../entity/entity_list_screen.dart';
import '../entity/relationship_graph_screen.dart';
import '../search/search_screen.dart';

/// The app-wide router. Override in tests to control the start location.
final goRouterProvider = Provider<GoRouter>((ref) => buildAppRouter());

/// Builds the [GoRouter] route table.
///
/// Routes:
///  * `/`                     — dashboard
///  * `/search`               — cross-entity search
///  * `/library/:type`        — entity list for one type
///  * `/library/:type/new`    — create entity
///  * `/library/:type/:id`    — read-only entity detail
///  * `/library/:type/:id/edit` — edit entity
GoRouter buildAppRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    redirect: (context, state) {
      final typeName = state.pathParameters['type'];
      if (typeName != null &&
          !EntityType.values.asNameMap().containsKey(typeName)) {
        return '/';
      }
      return null;
    },
    routes: [      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/graph',
        name: 'graph',
        builder: (context, state) => const RelationshipGraphScreen(),
      ),
      GoRoute(
        path: '/library/:type',
        name: 'library',
        builder: (context, state) => EntityListScreen(
          type: EntityType.values.byName(state.pathParameters['type']!),
        ),
        routes: [
          GoRoute(
            path: 'new',
            name: 'entityCreate',
            builder: (context, state) => EntityEditScreen(
              type: EntityType.values.byName(state.pathParameters['type']!),
              initialValues: _createInitialValues(state),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'entityDetail',
            builder: (context, state) => EntityDetailScreen(
              type: EntityType.values.byName(state.pathParameters['type']!),
              id: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'entityEdit',
                builder: (context, state) => EntityEditScreen(
                  type: EntityType.values.byName(state.pathParameters['type']!),
                  id: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Extracts prefill values for the create form from query parameters, e.g.
/// `/library/characterVersion/new?characterId=...`.
Map<String, dynamic> _createInitialValues(GoRouterState state) => {
      for (final entry in state.uri.queryParameters.entries)
        entry.key: entry.value,
    };
