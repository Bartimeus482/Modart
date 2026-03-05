import 'package:flutter/material.dart';
import '../models/cloth.dart';

class ClothDetailPage extends StatelessWidget {
  const ClothDetailPage({
    super.key,
    required this.cloth,
    required this.showShopLink,
    required this.canDelete,
    this.onDelete,
  });

  final Cloth cloth;
  final bool showShopLink;

  final bool canDelete;
  final Future<void> Function(String clothId)? onDelete;

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.35,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(cloth.name),
        actions: [
          if (canDelete)
            IconButton(
              tooltip: 'Supprimer',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Supprimer ce vêtement ?'),
                    content: Text('Retirer ${cloth.name} de la bibliothèque.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Annuler'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Supprimer'),
                      ),
                    ],
                  ),
                );

                if (ok != true) return;

                try {
                  if (onDelete != null) {
                    await onDelete!(cloth.id);
                  }
                  if (!context.mounted) return;

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${cloth.name} supprimé')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur suppression: $e')),
                  );
                }
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  cloth.imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_outlined),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: cloth.hasDetails
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cloth.origin != null) ...[
                          Text('Origin', style: textStyle),
                          const SizedBox(height: 6),
                          Text(cloth.origin!, style: textStyle),
                          const SizedBox(height: 16),
                        ],
                        if (cloth.reference != null) ...[
                          Text('Reference', style: textStyle),
                          const SizedBox(height: 6),
                          Text(cloth.reference!, style: textStyle),
                          const SizedBox(height: 16),
                        ],
                        if (cloth.matiere != null) ...[
                          Text('Matière', style: textStyle),
                          const SizedBox(height: 6),
                          Text(cloth.matiere!, style: textStyle),
                          const SizedBox(height: 16),
                        ],
                        if (cloth.entretien != null &&
                            cloth.entretien!.isNotEmpty) ...[
                          Text('Entretien', style: textStyle),
                          const SizedBox(height: 6),
                          ...cloth.entretien!.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text('• $e', style: textStyle),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (showShopLink && cloth.shop != null) ...[
                          Text('Boutique', style: textStyle),
                          const SizedBox(height: 6),
                          Text(
                            cloth.shop!,
                            style: textStyle.copyWith(
                              color: Colors.black87,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ],
                    )
                  : Text(
                      "Détail pas encore disponible. Reviens plus tard.",
                      style: textStyle,
                      textAlign: TextAlign.left,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
