import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:chess_players/entities/player.dart';
import 'package:intl/intl.dart';

class PlayerDetailScreen extends StatefulWidget {
  final Player player;
  const PlayerDetailScreen({super.key, required this.player});

  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  // Variables de estado para la edición de Rating y Notes
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
    // 1. Guardar cambios en la entidad Player (in-memory)

    // Campos personalizados
    widget.player.rating = _currentRating;
    widget.player.notes = _notesController.text;

    // Campos de la API editables
    widget.player.name = _nameController.text;
    widget.player.username = _usernameController.text;
    widget.player.status = _statusController.text;

    // 2. Notificación y navegación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios guardados localmente!')),
    );

    Navigator.pop(context);
  }

  // Helper para formatear timestamps
  String _formatLastOnline(int timestamp) {
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
        // Usamos el color primario/secundario del tema (chessGreen)
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.save, color: Colors.black),
        label: const Text('Guardar', style: TextStyle(color: Colors.black)),
      ),

      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                // Muestra el nombre de usuario que esté en el controlador (o el inicial)
                _usernameController.text,
                style: const TextStyle(
                  shadows: [Shadow(blurRadius: 5.0, color: Colors.black)],
                ),
              ),
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'player-avatar-${widget.player.username}',
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.player.avatar),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ⭐ Rating Personalizado Editable
                    _buildEditableRating(context),

                    const Divider(height: 30),

                    // ⭐ Campo Editable: Nombre Completo
                    _buildEditableField(
                      title: 'Full Name',
                      controller: _nameController,
                      isEditing: _isEditingName,
                      onToggleEdit: () {
                        setState(() {
                          _isEditingName = !_isEditingName;
                        });
                      },
                    ),

                    // ⭐ Campo Editable: Nombre de Usuario
                    _buildEditableField(
                      title: 'Username',
                      controller: _usernameController,
                      isEditing: _isEditingUsername,
                      onToggleEdit: () {
                        setState(() {
                          _isEditingUsername = !_isEditingUsername;
                        });
                      },
                    ),

                    // ⭐ Campo Editable: Status
                    _buildEditableField(
                      title: 'Status',
                      controller: _statusController,
                      isEditing: _isEditingStatus,
                      onToggleEdit: () {
                        setState(() {
                          _isEditingStatus = !_isEditingStatus;
                        });
                      },
                    ),

                    const Divider(height: 30),

                    // 🚫 Campos No Editables (Información de la API)
                    _buildDetailRow(
                      context,
                      Icons.person_pin,
                      'Player ID',
                      widget.player.playerId.toString(),
                    ),
                    _buildDetailRow(
                      context,
                      Icons.people,
                      'Followers',
                      widget.player.followers.toString(),
                    ),
                    _buildDetailRow(
                      context,
                      Icons.access_time,
                      'Last Connection',
                      _formatLastOnline(widget.player.lastOnline),
                    ),
                    _buildDetailRow(
                      context,
                      Icons.public,
                      'Country',
                      widget.player.country.substring(
                        widget.player.country.lastIndexOf('/') + 1,
                      ), // Muestra solo el código del país
                    ),
                    _buildDetailRow(
                      context,
                      Icons.verified,
                      'Verified',
                      widget.player.verified ? 'Sí' : 'No',
                    ),

                    const Divider(height: 30),

                    // ⭐ Campo de Notas Editable
                    _buildEditableNotesField(context),

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

  // --- WIDGETS AUXILIARES ---

  Widget _buildEditableField({
    required String title,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onToggleEdit,
  }) {
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

  Widget _buildEditableRating(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rating', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              // Rating Bar para modificar el valor
              RatingBar.builder(
                initialRating: _currentRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating; // Actualiza el estado local
                  });
                },
              ),
              const SizedBox(width: 16),
              // Muestra el valor numérico actual
              Text(
                _currentRating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableNotesField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes and Observations',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _notesController, // Enlazado al controlador de texto
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

  // Modificación del _buildDetailRow original (ahora solo para campos estáticos/no editables)
  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
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
