import 'package:flutter/material.dart';
import '../services/clothes_service.dart';
import '../models/cloth.dart';

class HomeTabsPage extends StatefulWidget {
  const HomeTabsPage({super.key});

  @override
  State<HomeTabsPage> createState() => _HomeTabsPageState();
}

class _HomeTabsPageState extends State<HomeTabsPage> {
  final _service = ClothesService();

  late final Future<List<Cloth>> _clothesFuture;

  @override
  void initState() {
    super.initState();

    _clothesFuture = _service.loadClothes();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              const _CenteredMinimalTabs(),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Cloth>>(
                  future: _clothesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    }

                    final clothes = snapshot.data ?? [];
                    final library =
                        <Cloth>[]; // bibliothèque vide pour l’instant

                    return TabBarView(
                      children: [
                        ClothesGridPage(
                          clothes: library,
                          emptyText: 'Aucun vêtement scanné pour le moment.',
                        ),
                        ClothesGridPage(
                          clothes: clothes,
                          emptyText: 'Aucun vêtement dans la collection.',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenteredMinimalTabs extends StatelessWidget {
  const _CenteredMinimalTabs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 34,
        child: TabBar(
          isScrollable: false,

          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          enableFeedback: false,

          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.7,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.7,
          ),

          labelColor: Colors.black,
          unselectedLabelColor: Color(0xFFBDBDBD),

          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.black,
          indicatorWeight: 1.0,

          dividerColor: Colors.transparent,

          tabs: const [
            Tab(child: Center(child: Text('BIBLIOTHEQUE'))),
            Tab(child: Center(child: Text('COLLECTION'))),
          ],
        ),
      ),
    );
  }
}

class ClothesGridPage extends StatefulWidget {
  const ClothesGridPage({
    super.key,
    required this.clothes,
    required this.emptyText,
    this.pageSize = 10,
  });

  final List<Cloth> clothes;
  final String emptyText;
  final int pageSize;

  @override
  State<ClothesGridPage> createState() => _ClothesGridPageState();
}

class _ClothesGridPageState extends State<ClothesGridPage> {
  int _page = 0;

  int get _pageCount {
    final total = widget.clothes.length;
    if (total == 0) return 1;
    return (total / widget.pageSize).ceil();
  }

  List<Cloth> get _currentPageItems {
    final start = _page * widget.pageSize;
    final end = (start + widget.pageSize).clamp(0, widget.clothes.length);
    if (start >= widget.clothes.length) return [];
    return widget.clothes.sublist(start, end);
  }

  void _goPrev() =>
      setState(() => _page = (_page - 1).clamp(0, _pageCount - 1));
  void _goNext() =>
      setState(() => _page = (_page + 1).clamp(0, _pageCount - 1));

  @override
  void didUpdateWidget(covariant ClothesGridPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si la liste change (filtre onglets), on s’assure que la page est valide
    if (_page > _pageCount - 1) {
      _page = (_pageCount - 1).clamp(0, _pageCount - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clothes.isEmpty) {
      return Center(child: Text(widget.emptyText, textAlign: TextAlign.center));
    }

    final items = _currentPageItems;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;

              // Ajuste automatique du nombre de colonnes selon la largeur
              int crossAxisCount = 2;
              if (w >= 1200) {
                crossAxisCount = 6;
              } else if (w >= 900)
                crossAxisCount = 5;
              else if (w >= 650)
                crossAxisCount = 4;
              else if (w >= 420)
                crossAxisCount = 3;

              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 28,
                  crossAxisSpacing: 28,
                  childAspectRatio: 1 / 1.15, // image + label en dessous
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final c = items[index];
                  return _ClothTile(cloth: c);
                },
              );
            },
          ),
        ),

        // Pagination uniquement si > pageSize
        if (widget.clothes.length > widget.pageSize)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _page == 0 ? null : _goPrev,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  'Page ${_page + 1} / $_pageCount',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: _page >= _pageCount - 1 ? null : _goNext,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ClothTile extends StatelessWidget {
  const _ClothTile({required this.cloth});

  final Cloth cloth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              cloth.imageAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) {
                // placeholder si l’image n’existe pas encore
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEAEAEA)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          cloth.name,
          style: const TextStyle(
            fontSize: 13,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
