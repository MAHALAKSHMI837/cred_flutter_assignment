class CardItem {
  final String id;
  final String title;
  final String subtitle;
  final String paymentAmount;
  final String image;
  final String? footer;
  final bool hasFlipper;
  final List<String>? flipperTexts;

  CardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.paymentAmount,
    required this.image,
    this.footer,
    this.hasFlipper = false,
    this.flipperTexts,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    final body = json['template_properties']?['body'] ?? {};
    final flipperConfig = body['flipper_config'];
    
    return CardItem(
      id: json['external_id'] ?? '',
      title: body['title'] ?? '',
      subtitle: body['sub_title'] ?? '',
      paymentAmount: body['payment_amount'] ?? '',
      image: body['logo']?['url'] ?? '',
      footer: body['footer_text'],
      hasFlipper: flipperConfig != null,
      flipperTexts: flipperConfig != null 
          ? (flipperConfig['items'] as List?)?.map((item) => item['text'].toString()).toList()
          : null,
    );
  }
}
