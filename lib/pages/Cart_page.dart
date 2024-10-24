import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('cart_added');

  late Stream<QuerySnapshot> _streamCoffeeItem;
  double _totalPrice = 0.0; // Variable to store the total price

  @override
  void initState() {
    super.initState();
    _streamCoffeeItem = _collectionReference.snapshots();
  }

  // Function to calculate total price from the snapshot
  double _calculateTotalPrice(List<QueryDocumentSnapshot> documents) {
    double total = 0.0;
    for (var doc in documents) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      total += double.tryParse(data['price'] ?? '0') ?? 0.0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C1C1C), // Dark gray
              Color(0xFF0A0A0A), // Almost black
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamCoffeeItem,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Error handling
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Checking if the data is received
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // If data is available, process it
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              // Update the total price
              _totalPrice = _calculateTotalPrice(documents);

              // Checking if the cart is empty
              if (documents.isEmpty) {
                return const Center(child: Text('Your cart is empty.'));
              }

              return Column(
                children: [
                  // List of cart items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> coffeeItem = documents[index].data() as Map<String, dynamic>;

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Coffee Icon or Image
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                      image: AssetImage('assets/images/Coffee.png'), // Placeholder image
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),

                                // Coffee Name and Price
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        coffeeItem['name'] ?? 'Unknown Coffee',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Rs. ${coffeeItem['price'] ?? '0'}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orangeAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Delete button with an icon
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    // Deleting the item from Firestore
                                    documents[index].reference.delete();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Total price and Checkout button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: Rs. $_totalPrice',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle checkout logic here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Proceeding to checkout...")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: const Text('Checkout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            // If no data is received yet, show loading
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
