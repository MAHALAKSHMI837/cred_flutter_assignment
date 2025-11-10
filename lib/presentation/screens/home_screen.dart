import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/vertical_carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _useSmallDataset = false; // false = 9 items (vertical carousel)

  @override
  Widget build(BuildContext context) {
    final asyncCards = ref.watch(cardsProvider(_useSmallDataset));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'CRED Carousel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _useSmallDataset = !_useSmallDataset;
              });
            },
            icon: Icon(
              _useSmallDataset ? Icons.view_list : Icons.view_carousel,
              color: Colors.white,
            ),
            tooltip: _useSmallDataset ? 'Show 9 items' : 'Show 2 items',
          ),
        ],
      ),
      body: asyncCards.when(
        data: (cards) {
          if (cards.isEmpty) {
            return const Center(
              child: Text(
                'No cards available',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[900],
                child: Text(
                  'Loaded ${cards.length} cards - Using ${cards.length <= 2 ? "ListView" : "PageView Carousel"}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              Expanded(child: VerticalCarousel(items: cards)),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading cards',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(cardsProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black,
        child: Text(
          _useSmallDataset ? '2 Items (List View)' : '9 Items (Carousel View)',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
