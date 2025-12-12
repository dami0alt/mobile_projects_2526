import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:chess_players/entities/player.dart';
import 'package:chess_players/widgets/player_details_widgets.dart';

class PlayerDetailScreen extends StatefulWidget {
  final Player player;
  const PlayerDetailScreen({super.key, required this.player});

  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  late double _currentRating;
  late TextEditingController _notesController;

  // Controladores para la edición de Name, Username y Status
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _statusController;

  // Estados de edición para cada campo (toggle con el lápiz)
  bool _isEditingName = false;
  bool _isEditingUsername = false;
  bool _isEditingStatus = false;

  @override
  void initState() {
    super.initState();
    // Inicializar campos editables personalizados
    _currentRating = widget.player.rating;
    _notesController = TextEditingController(text: widget.player.notes ?? '');

    // Inicializar campos editables de la API
    _nameController = TextEditingController(text: widget.player.name);
    _usernameController = TextEditingController(text: widget.player.username);
    _statusController = TextEditingController(text: widget.player.status);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    const SnackBar(
      content: const Text('Changes saved in local!!'),
      duration: const Duration(milliseconds: 50),
    );

    widget.player.rating = _currentRating;
    widget.player.notes = _notesController.text;

    widget.player.name = _nameController.text;
    widget.player.username = _usernameController.text;
    widget.player.status = _statusController.text;

    // 2. Notificación y navegación
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Changes saved in local!!')));
    Navigator.pop(context);
  }

  String formatLastOnline(int timestamp) {
    if (timestamp == 0) return 'Never';
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveChanges,
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.save, color: Colors.black),
        label: const Text('Save', style: TextStyle(color: Colors.black)),
      ),

      body: CustomScrollView(
        slivers: <Widget>[
          buildDetailHeader(context, widget.player, _usernameController.text),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    EditableRating(
                      currentRating: _currentRating,
                      onRatingUpdate: (rating) {
                        setState(() {
                          _currentRating = rating;
                        });
                      },
                    ),

                    const Divider(height: 30),

                    EditableRow(
                      title: 'Full Name',
                      controller: _nameController,
                      isEditing: _isEditingName,
                      onToggleEdit: () => setState(() {
                        _isEditingName = !_isEditingName;
                      }),
                    ),
                    EditableRow(
                      title: 'Username',
                      controller: _usernameController,
                      isEditing: _isEditingUsername,
                      onToggleEdit: () => setState(() {
                        _isEditingUsername = !_isEditingUsername;
                      }),
                    ),
                    EditableRow(
                      title: 'Status',
                      controller: _statusController,
                      isEditing: _isEditingStatus,
                      onToggleEdit: () => setState(() {
                        _isEditingStatus = !_isEditingStatus;
                      }),
                    ),

                    const Divider(height: 30),

                    StaticDetailRow(
                      icon: Icons.person_pin,
                      label: 'Player ID',
                      value: widget.player.playerId.toString(),
                    ),
                    StaticDetailRow(
                      icon: Icons.people,
                      label: 'Followers',
                      value: widget.player.followers.toString(),
                    ),
                    StaticDetailRow(
                      icon: Icons.access_time,
                      label: 'Last Connection',
                      value: formatLastOnline(widget.player.lastOnline),
                    ),
                    StaticDetailRow(
                      icon: Icons.public,
                      label: 'Country',
                      value: widget.player.country.substring(
                        widget.player.country.lastIndexOf('/') + 1,
                      ),
                    ),
                    StaticDetailRow(
                      icon: Icons.verified,
                      label: 'Verified',
                      value: widget.player.verified ? 'Sí' : 'No',
                    ),

                    const Divider(height: 30),

                    EditableNotesField(controller: _notesController),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
