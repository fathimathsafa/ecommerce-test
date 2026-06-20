class Product {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> tags;
  final String category;
  final String description;
  final bool isWishlisted;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.tags,
    required this.category,
    required this.description,
    this.isWishlisted = false,
  });

  // Calculate discount percentage if original price is available
  int get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  // Create a copy of the product with modified fields (crucial for state modification)
  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    List<String>? tags,
    String? category,
    String? description,
    bool? isWishlisted,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      description: description ?? this.description,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  // Generate mock data for high-quality e-commerce items
  static List<Product> getDummyProducts() {
    return [
      Product(
        id: 'p1',
        name: 'AeroGlide Wireless Over-Ear Headphones',
        price: 129.99,
        originalPrice: 199.99,
        rating: 4.8,
        reviewCount: 320,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        tags: ['Free Delivery', 'Best Seller', 'ANC Active'],
        category: 'Electronics',
        description: 'Experience pure audio bliss with AeroGlide Wireless Headphones. Featuring Active Noise Cancelling, ultra-soft memory foam earcups, and up to 40 hours of rich, high-fidelity playback time.',
        isWishlisted: false,
      ),
      Product(
        id: 'p2',
        name: 'NeoSport Breathable Running Shoes',
        price: 89.95,
        originalPrice: 120.00,
        rating: 4.6,
        reviewCount: 185,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        tags: ['Trending', 'FlexSole', '20% OFF'],
        category: 'Fashion',
        description: 'Engineered for high performance, these running shoes feature a breathable knit upper and adaptive responsive cushioning for maximum energy return and joint comfort.',
        isWishlisted: true,
      ),
      Product(
        id: 'p3',
        name: 'Minimalist Chrono Leather Watch',
        price: 175.00,
        originalPrice: 175.00,
        rating: 4.9,
        reviewCount: 94,
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        tags: ['Premium', 'Water Resistant'],
        category: 'Accessories',
        description: 'A timeless accessory featuring a genuine Italian leather strap, surgical-grade stainless steel case, and precise Japanese quartz movement.',
        isWishlisted: false,
      ),
      Product(
        id: 'p4',
        name: 'ChromaGlow Mechanical Gaming Keyboard',
        price: 99.99,
        originalPrice: 149.99,
        rating: 4.7,
        reviewCount: 452,
        imageUrl: 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        tags: ['Hot Deal', 'RGB Backlit', 'Cherry MX Blue'],
        category: 'Electronics',
        description: 'Dominate your gameplay with the ChromaGlow mechanical keyboard. Features custom RGB per-key backlighting, tactile blue switches, and a durable aircraft-grade aluminum frame.',
        isWishlisted: false,
      ),
      Product(
        id: 'p5',
        name: 'Urban Explorer Waterproof Backpack',
        price: 59.90,
        originalPrice: 79.90,
        rating: 4.5,
        reviewCount: 210,
        imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        tags: ['Rain Guard', 'USB Port'],
        category: 'Accessories',
        description: 'Your perfect travel companion. Crafted from waterproof ballistic nylon, featuring a dedicated 16-inch laptop pocket, anti-theft compartments, and built-in USB charging port.',
        isWishlisted: false,
      ),
      Product(
        id: 'p6',
        name: 'PureCotton SlimFit Casual Blazer',
        price: 110.00,
        originalPrice: 150.00,
        rating: 4.4,
        reviewCount: 88,
        imageUrl: 'https://images.unsplash.com/photo-1598808503742-dd34ab0ccf4b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        tags: ['Classic Fit', 'Breathable'],
        category: 'Fashion',
        description: 'Sharpen your look with our modern slim-fit blazer. Tailored from a premium breathable cotton-linen blend that keeps you feeling cool and looking smart all day long.',
        isWishlisted: false,
      ),
      Product(
        id: 'p7',
        name: 'HydroPulse Double-Wall Insulated Bottle',
        price: 24.99,
        originalPrice: 24.99,
        rating: 4.7,
        reviewCount: 512,
        imageUrl: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        tags: ['Eco Friendly', '24h Cold'],
        category: 'Home & Kitchen',
        description: 'Stay hydrated in style. This double-walled, vacuum-insulated stainless steel bottle keeps your drinks ice-cold for 24 hours or piping hot for 12 hours.',
        isWishlisted: false,
      ),
      Product(
        id: 'p8',
        name: 'ErgoComfort Memory Foam Pillow',
        price: 45.00,
        originalPrice: 59.99,
        rating: 4.3,
        reviewCount: 143,
        imageUrl: 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        tags: ['Orthopedic', 'Cooling Gel'],
        category: 'Home & Kitchen',
        description: 'Enjoy a deep, restful night’s sleep. Our contour memory foam pillow cradles your head and neck, infused with specialized cooling gel to disperse body heat.',
        isWishlisted: false,
      ),
    ];
  }
}
