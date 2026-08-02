import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/entity_type.dart';
import '../../core/models/relationship.dart';
import '../../core/models/stored_entity.dart';
import '../app_shell/app_drawer.dart';
import 'entity_display.dart';
import 'entity_library_providers.dart';
import 'entity_type_config.dart';

/// Visualization of all characters and their directional relationships.
///
/// Nodes are characters; an edge runs from the character that *owns* a
/// relationship to its target. Each stored edge also renders its derived
/// inverse (see `RelationshipType.inverse`) so the graph is complete even
/// though relationships are stored once.
class RelationshipGraphScreen extends ConsumerWidget {
  const RelationshipGraphScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(entityListProvider(EntityType.character));
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? BackButton(onPressed: () => context.pop())
            : null,
        title: const Text('Relationship graph'),
      ),
      drawer: const AppDrawer(),
      body: characters.when(
        data: (list) => list.isEmpty
            ? const Center(child: Text('No characters yet'))
            : _GraphView(characters: list),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load: $error')),
      ),
    );
  }
}

class _GraphEdge {
  const _GraphEdge({
    required this.from,
    required this.to,
    required this.label,
    required this.inverse,
  });

  final String from;
  final String to;
  final String label;
  final bool inverse;
}

class _GraphView extends ConsumerWidget {
  const _GraphView({required this.characters});

  final List<StoredEntity> characters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edges = _buildEdges();
    if (edges.isEmpty) {
      return const Center(child: Text('No relationships yet'));
    }
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final center = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );
        final radius =
            (math.min(constraints.maxWidth, constraints.maxHeight) / 2) - 90;
        final positions = <String, Offset>{};
        for (var i = 0; i < characters.length; i++) {
          final angle = (2 * math.pi * i / characters.length) - math.pi / 2;
          positions[characters[i].id] = center +
              Offset(math.cos(angle), math.sin(angle)) * radius;
        }
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GraphPainter(
                  edges: edges,
                  positions: positions,
                  outline: theme.colorScheme.outline,
                  onSurface: theme.colorScheme.onSurface,
                ),
              ),
            ),
            for (final node in characters)
              _PositionedNode(
                node: node,
                position: positions[node.id]!,
                onTap: () => context.push('/library/character/${node.id}'),
              ),
          ],
        );
      },
    );
  }

  List<_GraphEdge> _buildEdges() {
    final byId = {for (final c in characters) c.id: c};
    final edges = <_GraphEdge>[];
    final storedTargets = <String, Set<String>>{};
    for (final character in characters) {
      final relationships = character.toJson()['relationships'];
      if (relationships is! List) continue;
      for (final rel in relationships) {
        if (rel is! Relationship) continue;
        if (!byId.containsKey(rel.otherCharacterId)) continue;
        storedTargets.putIfAbsent(character.id, () => {}).add(rel.otherCharacterId);
        edges.add(_GraphEdge(
          from: character.id,
          to: rel.otherCharacterId,
          label: rel.type.name,
          inverse: false,
        ));
      }
    }
    for (final edge in List.of(edges)) {
      final back = storedTargets[edge.to]?.contains(edge.from) ?? false;
      if (back) continue;
      final inverseName =
          RelationshipType.values.byName(edge.label).inverse.name;
      edges.add(_GraphEdge(
        from: edge.to,
        to: edge.from,
        label: inverseName,
        inverse: true,
      ));
    }
    return edges;
  }
}

class _PositionedNode extends StatelessWidget {
  const _PositionedNode({
    required this.node,
    required this.position,
    required this.onTap,
  });

  final StoredEntity node;
  final Offset position;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = configOf(node.entityType);
    return Positioned(
      left: position.dx - 70,
      top: position.dy - 46,
      width: 140,
      height: 92,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                config.icon,
                size: 22,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              displayNameOf(node),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  const _GraphPainter({
    required this.edges,
    required this.positions,
    required this.outline,
    required this.onSurface,
  });

  final List<_GraphEdge> edges;
  final Map<String, Offset> positions;
  final Color outline;
  final Color onSurface;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final edge in edges) {
      final start = positions[edge.from];
      final end = positions[edge.to];
      if (start == null || end == null) continue;
      base.color = outline.withValues(alpha: edge.inverse ? 0.35 : 0.7);
      final control = _controlPoint(start, end);
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(
          control.dx,
          control.dy,
          end.dx,
          end.dy,
        );
      canvas.drawPath(path, base);
      _drawArrowhead(canvas, control, end, base.color);

      final label = TextPainter(
        text: TextSpan(
          text: prettyLabel(edge.label),
          style: TextStyle(fontSize: 11, color: onSurface),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(
        canvas,
        control - Offset(label.width / 2, label.height / 2),
      );
    }
  }

  Offset _controlPoint(Offset start, Offset end) {
    final mid = (start + end) / 2;
    final delta = end - start;
    final length = delta.distance;
    if (length == 0) return mid;
    final normal = Offset(-delta.dy / length, delta.dx / length);
    return mid + normal * 24;
  }

  void _drawArrowhead(Canvas canvas, Offset control, Offset end, Color color) {
    final tangent = (end - control);
    final angle = math.atan2(tangent.dy, tangent.dx);
    final head = Paint()..color = color;
    final size = 7.0;
    final path = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - size * math.cos(angle - math.pi / 6),
        end.dy - size * math.sin(angle - math.pi / 6),
      )
      ..lineTo(
        end.dx - size * math.cos(angle + math.pi / 6),
        end.dy - size * math.sin(angle + math.pi / 6),
      )
      ..close();
    canvas.drawPath(path, head);
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) =>
      oldDelegate.edges != edges ||
      oldDelegate.positions != positions ||
      oldDelegate.outline != outline ||
      oldDelegate.onSurface != onSurface;
}
