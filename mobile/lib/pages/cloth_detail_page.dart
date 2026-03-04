import 'package:flutter/material.dart';
import '../models/cloth.dart';

class ClothDetailPage extends StatelessWidget {
  const ClothDetailPage({
    super.key,
    required this.cloth,
    required this.showShopLink,
  });

  final Cloth cloth;
  final bool showShopLink;

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.35,
    );
    debugPrint(
      'DETAIL ${cloth.name} origin=${cloth.origin} ref=${cloth.reference} '
      'mat=${cloth.matiere} ent=${cloth.entretien} shop=${cloth.shop}',
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(cloth.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Image centrée
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

            // Infos
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
