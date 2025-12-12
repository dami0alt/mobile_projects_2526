import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:chess_players/entities/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final Function(Player player) onCardTap;
  final Function(Player player) onFavoriteToggle;
  final Color cardColor;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onCardTap,
    required this.onFavoriteToggle,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onCardTap(player),
      child: Card(
        elevation: 4,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'player-avatar-${player.username}',
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(player.avatar),
                ),
              ),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: player.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                ignoreGestures: true,
                itemCount: 5,
                itemSize: 18,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {},
              ),
              const SizedBox(height: 10),
              // Username
              Text(
                player.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),
              Text(
                "⭐ Status: ${player.status}",
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                "🏆 League: ${player.league}",
                style: const TextStyle(fontSize: 12),
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    player.followers.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              IconButton(
                icon: Icon(
                  player.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: player.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () => onFavoriteToggle(player),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
