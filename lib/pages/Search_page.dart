import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final CollectionReference cartCollection =
  FirebaseFirestore.instance.collection('cart_added');

  // Dummy data simulating search results
  List<Map<String, String>> coffeeList = [
    {'name': 'Americano', 'price': '120'},
    {'name': 'Mocha', 'price': '119'},
    {'name': 'Cappuccino', 'price': '150'},
    {'name': 'Espresso', 'price': '108'},
    {'name': 'Decaf', 'price': '199'},
  ];

  List<Map<String, String>> filteredCoffeeList = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all items initially
    filteredCoffeeList = coffeeList;

    // Add a listener to the search controller to filter results as the user types
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  void filterSearchResults(String query) {
    List<Map<String, String>> results = [];
    if (query.isEmpty) {
      results = coffeeList;
    } else {
      results = coffeeList
          .where((item) =>
          item['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredCoffeeList = results;
    });
  }

  void addToCart(String name, String price) {
    Map<String, String> dataToSave = {
      'name': name,
      'price': price,
      'timestamp': DateTime.now().toString(),
    };
    cartCollection.add(dataToSave);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search Coffee...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.search,
                      color: Colors.brown,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Displaying the filtered coffee items
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCoffeeList.length,
                  itemBuilder: (context, index) {
                    final item = filteredCoffeeList[index];
                    return Card(
                      color: Colors.grey.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(
                          item['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Price: Rs. ${item['price']}'),
                        trailing: GestureDetector(
                          onTap: () => addToCart(item['name']!, item['price']!),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
