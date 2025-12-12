// Archivo: chess_players/widgets/player_details_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:chess_players/entities/player.dart';

// Se define como una función separada (que puede estar en el mismo archivo)
SliverAppBar buildDetailHeader(
  BuildContext context,
  Player player,
  String username,
) {
  return SliverAppBar(
    expandedHeight: 250.0,
    pinned: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        username,
        style: const TextStyle(
          shadows: [Shadow(blurRadius: 5.0, color: Colors.black)],
        ),
      ),
      background: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'player-avatar-${player.username}',
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(player.avatar),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

// --- WIDGETS EDITABLES ---

class EditableRating extends StatelessWidget {
  final double currentRating;
  final ValueChanged<double> onRatingUpdate;

  const EditableRating({
    super.key,
    required this.currentRating,
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Rating', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: currentRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: onRatingUpdate,
              ),
              const SizedBox(width: 16),
              Text(
                currentRating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditableRow extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onToggleEdit;

  const EditableRow({
    super.key,
    required this.title,
    required this.controller,
    required this.isEditing,
    required this.onToggleEdit,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$title: ',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontSize: 14),
          ),
          Expanded(
            child: isEditing
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: textStyle.copyWith(fontWeight: FontWeight.normal),
                    ),
                  )
                : Text(
                    controller.text.isNotEmpty ? controller.text : 'N/A',
                    style: textStyle.copyWith(fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            color: isEditing ? Theme.of(context).primaryColor : Colors.grey,
            onPressed: onToggleEdit,
          ),
        ],
      ),
    );
  }
}

class EditableNotesField extends StatelessWidget {
  final TextEditingController controller;

  const EditableNotesField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes and Observations',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Añade notas sobre el jugador...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class StaticDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StaticDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  value.isNotEmpty && value != 'N/A' ? value : 'N/A',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
