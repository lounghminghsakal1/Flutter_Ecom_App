import 'package:flutter/material.dart';
import 'package:flutter2/widgets/product_card2.dart';
import '../models/product_model.dart';
import '../services/product_api.dart';
import '../widgets/product_card.dart';
import '../widgets/product_card2.dart';

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
    Center(child: Text("Cart Screen")),
    Center(child: Text("Wish List Screen")),
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
            icon: Icon(Icons.search),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              print("Cart icon clicked");
            },
            icon: Icon(Icons.shopping_cart),
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
            ListTile(title: Text("Home")),
            ListTile(title: Text("Products")),
            ListTile(title: Text("Cart")),
            ListTile(title: Text("WishList")),
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
  const FeaturedCategories({super.key});
  @override
  State<FeaturedCategories> createState() => _FeaturedCategoriesState();
}

class _FeaturedCategoriesState extends State<FeaturedCategories> {
  List data = [
    {"id": 1, "category": "Electronics", "img": "assets/images/f1.png"},
    {"id": 2, "category": "Fashion", "img": "assets/images/f2.png"},
    {"id": 3, "category": "Mobiles", "img": "assets/images/f3.png"},
    {"id": 4, "category": "Home", "img": "assets/images/f4.png"},
    {"id": 5, "category": "Grocery", "img": "assets/images/f5.png"},
    {"id": 6, "category": "Appliances", "img": "assets/images/f6.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Featured Categories",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.asset(data[index]['img'], fit: BoxFit.cover),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        data[index]['category'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: data.length,
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 8,
                ),
                child: ProductCard(product: product),
              ),
            );
          }),
      ],
    );
  }
}

// Home Screen Ends

//Products Screen Starts
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Products",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          // Here put ProductsDisplayAndFilterSection(Filters + product grid view) and remove ProductsGrid() below
          ProductsDisplayAndFilterSection(),
          // ProductsGrid(),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// Assuming you have a Product model like this
// class Product {
//   final String name;
//   final String brand;
//   final double price;
//   final double rating;

//   Product({required this.name, required this.brand, required this.price, required this.rating});
// }

// import 'package:flutter/material.dart';

// Main FiltersScreen that fetches and manages products
// import 'package:flutter/material.dart';

// Main FiltersScreen that fetches and manages products
// import 'package:flutter/material.dart';

// Main FiltersScreen that fetches and manages products
// import 'package:flutter/material.dart';

// Main FiltersScreen that fetches and manages products
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<Product> allProducts = [];
  Map<String, bool> brands = {};
  String sortBy = 'Newest';
  RangeValues priceRange = const RangeValues(0, 2000);
  int minRating = -1; // -1 means "All Ratings"
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
      final res = await ProductApi.fetchProducts();
      setState(() {
        allProducts = res;
        isLoading = false;
        
        // Extract unique brands from products
        Set<String> uniqueBrands = res.map((p) => p.brand).toSet();
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
      bool brandMatch = brands.values.every((v) => !v) || 
                        (brands[product.brand] ?? false);
      
      // Price filter
      bool priceMatch = product.price >= priceRange.start && 
                        product.price <= priceRange.end;
      
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
    final filteredProducts = getFilteredProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filters Section (Scrollable)
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
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                                    icon: Icon(showFilters ? Icons.expand_less : Icons.expand_more),
                                    onPressed: () => setState(() => showFilters = !showFilters),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          if (showFilters) ...[
                            const SizedBox(height: 16),
                            
                            // Sort By
                            const Text('Sort By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: sortBy,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              items: ['Newest', 'Price: Low to High', 'Price: High to Low', 'Rating']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (val) => setState(() => sortBy = val!),
                            ),
                            const SizedBox(height: 16),
                            
                            // Brands
                            const Text('Brands', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            if (brands.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('No brands available', style: TextStyle(color: Colors.grey)),
                              )
                            else
                              Container(
                                constraints: const BoxConstraints(maxHeight: 200),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: brands.keys.map((brand) {
                                    return CheckboxListTile(
                                      title: Text(brand, style: const TextStyle(fontSize: 15)),
                                      value: brands[brand],
                                      controlAffinity: ListTileControlAffinity.leading,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: -8),
                                      dense: true,
                                      onChanged: (val) => setState(() => brands[brand] = val!),
                                    );
                                  }).toList(),
                                ),
                              ),
                            const SizedBox(height: 8),
                            
                            // Price Range
                            const Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(priceRange.start.round().toString()),
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
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(priceRange.end.round().toString()),
                                  ),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: priceRange,
                              min: 0,
                              max: 2000,
                              onChanged: (vals) => setState(() => priceRange = vals),
                            ),
                            const SizedBox(height: 8),
                            
                            // Minimum Rating
                            const Text('Minimum Rating', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            RadioListTile<int>(
                              title: const Text('All Ratings', style: TextStyle(fontSize: 14)),
                              value: -1,
                              groupValue: minRating,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                              dense: true,
                              onChanged: (val) => setState(() => minRating = val!),
                            ),
                            ...List.generate(4, (i) {
                              int stars = 4 - i;
                              return RadioListTile<int>(
                                title: Row(
                                  children: [
                                    ...List.generate(stars, (_) => const Icon(Icons.star, size: 18)),
                                    ...List.generate(4 - stars, (_) => const Icon(Icons.star_border, size: 18)),
                                    const SizedBox(width: 8),
                                    const Text('& Up', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                value: stars,
                                groupValue: minRating,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                dense: true,
                                onChanged: (val) => setState(() => minRating = val!),
                              );
                            }),
                          ],
                          
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          
                          // Product Count
                          Text(
                            '${filteredProducts.length} Products',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          
                          // Products Grid
                          if (filteredProducts.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Text(
                                  'No products found matching your filters',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

//end

class ProductsDisplayAndFilterSection extends StatefulWidget {
  const ProductsDisplayAndFilterSection({super.key});
  @override
  State<ProductsDisplayAndFilterSection> createState() =>
      _ProductsDisplayAndFilterSectionState();
}

class _ProductsDisplayAndFilterSectionState
    extends State<ProductsDisplayAndFilterSection> {
  String sortBy = 'Newest';
  Map<String, bool> brands = {
    'Amazon': false,
    'Annibale Colombo': false,
    'Apple': false,
    'Asus': false,
    'Attitude': false,
    'Bath Trends': false,
  };
  RangeValues priceRange = const RangeValues(0, 2000);
  int minRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Sort By
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: sortBy,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items:
                    [
                          'Newest',
                          'Price: Low to High',
                          'Price: High to Low',
                          'Rating',
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) {
                  setState(() => sortBy = val!);
                  print('Sort by: $val');
                },
              ),
              const SizedBox(height: 24),

              // Brands
              const Text(
                'Brands',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: brands.keys.map((brand) {
                    return CheckboxListTile(
                      title: Text(brand),
                      value: brands[brand],
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setState(() => brands[brand] = val!);
                        print('Brand $brand: $val');
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Price Range
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(priceRange.start.round().toString()),
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
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(priceRange.end.round().toString()),
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: priceRange,
                min: 0,
                max: 2000,
                onChanged: (vals) {
                  setState(() => priceRange = vals);
                  print(
                    'Price range: ${vals.start.round()} - ${vals.end.round()}',
                  );
                },
              ),
              const SizedBox(height: 24),

              // Minimum Rating
              const Text(
                'Minimum Rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...List.generate(4, (i) {
                int stars = 4 - i;
                return RadioListTile<int>(
                  title: Row(
                    children: [
                      ...List.generate(
                        stars,
                        (_) => const Icon(Icons.star, size: 20),
                      ),
                      ...List.generate(
                        4 - stars,
                        (_) => const Icon(Icons.star_border, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Text('& Up'),
                    ],
                  ),
                  value: stars,
                  groupValue: minRating,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    setState(() => minRating = val!);
                    print('Minimum rating: $val stars');
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({super.key});
  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  List<Product> products = [];

  Future<void> fetchData() async {
    try {
      final res = await ProductApi.fetchProducts();
      setState(() {
        products = res;
      });
    } catch (err) {
      print("Something Wrong $err");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard2(product: product);
        },
      ),
    );
  }
}
