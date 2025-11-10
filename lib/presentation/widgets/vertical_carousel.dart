import 'package:flutter/material.dart';
import '../../core/models/card_model.dart';
import '../widgetsq/flip_tag.dart';

class VerticalCarousel extends StatefulWidget {
  final List<CardItem> items;
  const VerticalCarousel({super.key, required this.items});

  @override
  State<VerticalCarousel> createState() => _VerticalCarouselState();
}

class _VerticalCarouselState extends State<VerticalCarousel>
    with TickerProviderStateMixin {
  late final PageController _controller;
  late final AnimationController _fadeController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.85);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0;
      });
    });
    
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Show as ListView for ≤2 items
    if (widget.items.length <= 2) {
      return FadeTransition(
        opacity: _fadeController,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.items.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCard(widget.items[index], 0, false),
          ),
        ),
      );
    }

    // Show as PageView for >2 items
    return FadeTransition(
      opacity: _fadeController,
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: widget.items.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final scale = _getScale(index);
          final opacity = _getOpacity(index);
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: _buildCard(widget.items[index], index, true),
              ),
            ),
          );
        },
      ),
    );
  }

  double _getScale(int index) {
    final diff = (_currentPage - index).abs();
    if (diff <= 1) {
      return 1.0 - (diff * 0.1);
    }
    return 0.9;
  }

  double _getOpacity(int index) {
    final diff = (_currentPage - index).abs();
    if (diff <= 1) {
      return 1.0 - (diff * 0.3);
    }
    return 0.7;
  }

  Widget _buildCard(CardItem card, int index, bool isCarousel) {
    return Hero(
      tag: 'card_${card.id}',
      child: Container(
        height: isCarousel ? null : 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getCardColors(card.title),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Logo overlay
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _getBankLogo(card.title),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        card.paymentAmount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (card.hasFlipper && card.flipperTexts != null)
                        FlipTag(texts: card.flipperTexts!)
                      else if (card.footer != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            card.footer!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getCardColors(String bankName) {
    switch (bankName.toUpperCase()) {
      case 'HDFC BANK':
      case 'HDFC':
        return [const Color(0xFF004C8F), const Color(0xFF0066CC)];
      case 'SBI':
        return [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)];
      case 'VIL':
      case 'VODAFONE':
        return [const Color(0xFFDC2626), const Color(0xFFEF4444)];
      case 'BESCOM':
        return [const Color(0xFF059669), const Color(0xFF10B981)];
      case 'AIRTEL POSTPAID':
      case 'AIRTEL':
        return [const Color(0xFFDC2626), const Color(0xFFEF4444)];
      default:
        return [const Color(0xFF6B7280), const Color(0xFF9CA3AF)];
    }
  }

  Widget _getBankLogo(String bankName) {
    switch (bankName.toUpperCase()) {
      case 'HDFC BANK':
      case 'HDFC':
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Colors.blue[600]!],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'HDFC',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      case 'SBI':
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo[800]!, Colors.indigo[600]!],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'SBI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      case 'VIL':
      case 'VODAFONE':
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[700]!, Colors.red[500]!],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'VIL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      case 'BESCOM':
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[500]!],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'BESCOM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
      case 'AIRTEL POSTPAID':
      case 'AIRTEL':
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[800]!, Colors.red[600]!],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'AIRTEL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
      default:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[700]!, Colors.grey[500]!],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              bankName.length >= 4 ? bankName.substring(0, 4) : bankName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
