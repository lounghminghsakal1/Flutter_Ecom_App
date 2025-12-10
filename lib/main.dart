import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_api.dart';
import '../widgets/product_card.dart';

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

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  
  final List<Widget> _pages = const [
    Homebody(),
    ProductsScreen(),
    Center(child: Text("Cart Screen"),),
    Center(child: Text("Wish List Screen"),)
  ];

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
        SizedBox(height: 10,),
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

//Products Screen
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Products Screen"),),
    );
  }
}
