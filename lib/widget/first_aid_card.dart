import 'package:flutter/material.dart';
import '../models/first_aid_case.dart';

class FirstAidCard extends StatelessWidget {
  final FirstAidCase item;
  final VoidCallback onTap, onDelete, onEdit;

  const FirstAidCard({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: _placeholder(),
        title: Text(item.title),
        subtitle: Text(
          item.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Icon(Icons.medical_services, color: Colors.red),
  );
}
