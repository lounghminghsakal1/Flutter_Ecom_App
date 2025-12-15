import 'package:flutter/material.dart';
import 'package:flutter2/screens/cart_screen.dart';
import 'package:flutter2/screens/wishlist_screen.dart';
import 'package:flutter2/widgets/product_card2.dart';
import '../models/product_model.dart';
import '../services/product_api.dart';
import '../widgets/product_card.dart';
import '../widgets/product_card2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//Has AppBar, BottomNavigation bar, Decides which page to show

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  List<Widget> get _pages => [
    Homebody(),
    FiltersScreen(), // Now works!
    CartScreen(),
    WishlistScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sakal Shop",
          style: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        // leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        actions: [
          IconButton(
            onPressed: () {
              print("Search icon clicked");
            },
            icon: Icon(Icons.search,color: Colors.white,),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              print("Cart icon clicked");
            },
            icon: Icon(Icons.shopping_cart,color: Colors.white,),
          ),
          SizedBox(width: 10),
        ],
        backgroundColor: Colors.grey[500],
      ),
      drawer: Drawer(
        
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                "Sakal Shop",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(title: Text("Home"), onTap: () {
              Navigator.pop(context);
            }),
            ListTile(
              title: Text("Products"),
              onTap: () {
                setState(() {
                  currentIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text("Cart"),
              onTap: () {
                setState(() {
                  currentIndex = 2;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text("WishList"),
              onTap: () {
                setState(() {
                  currentIndex = 3;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      body: _pages[currentIndex], //decides which page to show
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "WishList",
          ),
        ],
      ),
    );
  }
}

// Home Screen (body) starts

class Homebody extends StatelessWidget {
  const Homebody({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(6),
      children: const [
        HomeScreenBanner(),
        FeaturedCategories(),
        TrendingProducts(),
      ],
    );
  }
}

class HomeScreenBanner extends StatelessWidget {
  const HomeScreenBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Image.asset("assets/images/hero4.png", fit: BoxFit.cover),
    );
  }
}

class FeaturedCategories extends StatefulWidget {
  const FeaturedCategories({Key? key}) : super(key: key);

  @override
  State<FeaturedCategories> createState() => _FeaturedCategoriesState();
}

class _FeaturedCategoriesState extends State<FeaturedCategories> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products/categories'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        // Take first 6 categories and format them
        setState(() {
          categories = data.take(6).map((cat) {
            return {
              'slug': cat['slug'],
              'name': cat['name'],
              'url': cat['url'],
            };
          }).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Generate color for each category
  Color getCategoryColor(int index) {
    List<Color> colors = [
      Colors.blue.shade100,
      Colors.pink.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
    ];
    return colors[index % colors.length];
  }

  // Generate icon for each category
  IconData getCategoryIcon(String category) {
    String lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('beauty') ||
        lowerCategory.contains('fragrance')) {
      return Icons.face;
    } else if (lowerCategory.contains('furniture') ||
        lowerCategory.contains('home')) {
      return Icons.chair;
    } else if (lowerCategory.contains('grocery') ||
        lowerCategory.contains('food')) {
      return Icons.shopping_basket;
    } else if (lowerCategory.contains('phone') ||
        lowerCategory.contains('mobile')) {
      return Icons.smartphone;
    } else if (lowerCategory.contains('laptop') ||
        lowerCategory.contains('computer')) {
      return Icons.laptop;
    } else if (lowerCategory.contains('vehicle') ||
        lowerCategory.contains('automotive')) {
      return Icons.directions_car;
    } else if (lowerCategory.contains('watch') ||
        lowerCategory.contains('accessories')) {
      return Icons.watch;
    } else if (lowerCategory.contains('tablet')) {
      return Icons.tablet;
    } else if (lowerCategory.contains('sport')) {
      return Icons.sports_soccer;
    } else if (lowerCategory.contains('kitchen')) {
      return Icons.kitchen;
    } else if (lowerCategory.contains('shirt') ||
        lowerCategory.contains('top') ||
        lowerCategory.contains('dress') ||
        lowerCategory.contains('clothing')) {
      return Icons.checkroom;
    } else if (lowerCategory.contains('shoe')) {
      return Icons.shop;
    } else if (lowerCategory.contains('bag') ||
        lowerCategory.contains('luggage')) {
      return Icons.shopping_bag;
    } else if (lowerCategory.contains('jewel') ||
        lowerCategory.contains('jewelry')) {
      return Icons.diamond;
    } else if (lowerCategory.contains('sunglasses')) {
      return Icons.wb_sunny;
    } else {
      return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Featured Categories",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : categories.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No categories available'),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.85,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to FiltersScreen with selected category
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FiltersScreen(
                            categorySlug: category['slug'],
                            categoryName: category['name'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: getCategoryColor(index),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            getCategoryIcon(category['name']),
                            size: 50,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              category['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}

class TrendingProducts extends StatefulWidget {
  const TrendingProducts({super.key});
  @override
  State<TrendingProducts> createState() => _TrendingProductsState();
}

class _TrendingProductsState extends State<TrendingProducts> {
  List<Product> products = [];
  List<Product> trendingProducts = [];
  Future<void> fetchData() async {
    print("Fetchhing data");
    try {
      final res = await ProductApi.fetchProducts();
      setState(() {
        products = res;
      });
    } catch (err) {
      print("Error in data fetching $err");
    }
    final trendingProductsIds = [136, 11, 123, 133];
    trendingProducts = products
        .where((p) => trendingProductsIds.contains(p.id))
        .toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          "Trending Products",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (products.isEmpty)
          const Center(child: CircularProgressIndicator())
        else
          ...trendingProducts.map((product) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: trendingProducts.length,
              itemBuilder: (context, index) {
                final product = trendingProducts[index];
                return ProductCard2(product: product);
              },
            );
          }),
      ],
    );
  }
}

// Home Screen Ends

//Products Screen Starts

class FiltersScreen extends StatefulWidget {
  final String? categorySlug;
  final String? categoryName;

  const FiltersScreen({Key? key, this.categorySlug, this.categoryName})
    : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<Product> allProducts = [];
  Map<String, bool> brands = {};
  String sortBy = 'Newest';
  RangeValues priceRange = const RangeValues(0, 2000);
  int minRating = -1;
  bool showFilters = true;
  bool isLoading = true;

  bool get hasActiveFilters {
    bool hasBrandFilter = brands.values.any((v) => v);
    bool hasPriceFilter = priceRange.start != 0 || priceRange.end != 2000;
    bool hasRatingFilter = minRating != -1;
    bool hasSortFilter = sortBy != 'Newest';

    return hasBrandFilter || hasPriceFilter || hasRatingFilter || hasSortFilter;
  }

  void clearFilters() {
    setState(() {
      sortBy = 'Newest';
      brands = {for (var brand in brands.keys) brand: false};
      priceRange = const RangeValues(0, 2000);
      minRating = -1;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Product> res;

      // If category is provided, fetch products from that category
      if (widget.categorySlug != null) {
        final response = await http.get(
          Uri.parse(
            'https://dummyjson.com/products/category/${widget.categorySlug}',
          ),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          res = (data['products'] as List)
              .map((p) => Product.fromJson(p))
              .toList();
        } else {
          res = [];
        }
      } else {
        // Fetch all products
        final response = await http.get(
          Uri.parse('https://dummyjson.com/products?limit=100'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          res = (data['products'] as List)
              .map((p) => Product.fromJson(p))
              .toList();
        } else {
          res = [];
        }
      }

      setState(() {
        allProducts = res;
        isLoading = false;

        // Extract unique brands from products
        Set<String> uniqueBrands = res
            .map((p) => p.brand)
            .where((b) => b.isNotEmpty)
            .toSet();
        brands = {for (var brand in uniqueBrands) brand: false};
      });
    } catch (err) {
      print("Something Wrong $err");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Product> getFilteredProducts() {
    List<Product> filtered = allProducts.where((product) {
      // Brand filter
      bool brandMatch =
          brands.values.every((v) => !v) || (brands[product.brand] ?? false);

      // Price filter
      bool priceMatch =
          product.price >= priceRange.start && product.price <= priceRange.end;

      // Rating filter
      bool ratingMatch = minRating == -1 || product.rating >= minRating;

      return brandMatch && priceMatch && ratingMatch;
    }).toList();

    // Sort
    switch (sortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> filteredProducts = getFilteredProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          ),
        ),
        title: Text(
          widget.categoryName ?? 'All Products',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Filters',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  if (hasActiveFilters)
                                    TextButton(
                                      onPressed: clearFilters,
                                      child: const Text(
                                        'Clear Filters',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  IconButton(
                                    icon: Icon(
                                      showFilters
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                    onPressed: () => setState(
                                      () => showFilters = !showFilters,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          if (showFilters) ...[
                            const SizedBox(height: 16),

                            // Sort By
                            const Text(
                              'Sort By',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: sortBy,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              items:
                                  [
                                        'Newest',
                                        'Price: Low to High',
                                        'Price: High to Low',
                                        'Rating',
                                      ]
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) => setState(() => sortBy = val!),
                            ),
                            const SizedBox(height: 16),

                            // Brands
                            const Text(
                              'Brands',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (brands.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'No brands available',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            else
                              Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: brands.keys.map((brand) {
                                    return CheckboxListTile(
                                      title: Text(
                                        brand,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      value: brands[brand],
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: -8,
                                          ),
                                      dense: true,
                                      onChanged: (val) =>
                                          setState(() => brands[brand] = val!),
                                    );
                                  }).toList(),
                                ),
                              ),
                            const SizedBox(height: 8),

                            // Price Range
                            const Text(
                              'Price Range',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '\$${priceRange.start.round()}',
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('to'),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('\$${priceRange.end.round()}'),
                                  ),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: priceRange,
                              min: 0,
                              max: 2000,
                              onChanged: (vals) =>
                                  setState(() => priceRange = vals),
                            ),
                            const SizedBox(height: 8),

                            // Minimum Rating
                            const Text(
                              'Minimum Rating',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RadioListTile<int>(
                              title: const Text(
                                'All Ratings',
                                style: TextStyle(fontSize: 14),
                              ),
                              value: -1,
                              groupValue: minRating,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              dense: true,
                              onChanged: (val) =>
                                  setState(() => minRating = val!),
                            ),
                            ...List.generate(4, (i) {
                              int stars = 4 - i;
                              return RadioListTile<int>(
                                title: Row(
                                  children: [
                                    ...List.generate(
                                      stars,
                                      (_) => const Icon(Icons.star, size: 18),
                                    ),
                                    ...List.generate(
                                      4 - stars,
                                      (_) => const Icon(
                                        Icons.star_border,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '& Up',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                value: stars,
                                groupValue: minRating,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                dense: true,
                                onChanged: (val) =>
                                    setState(() => minRating = val!),
                              );
                            }),
                          ],

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),

                          // Product Count
                          Text(
                            '${filteredProducts.length} Products',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Products Grid
                          if (filteredProducts.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Text(
                                  'No products found matching your filters',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.6,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return ProductCard2(product: product);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
//End of products screen

// Product details page
