import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade300,
              Colors.indigo.shade400,
              Colors.blue.shade500,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Welcome Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.dashboard,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Feature Cards
                  const Text(
                    'Fitur Aplikasi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Posts Card
                  _buildFeatureCard(
                    context,
                    icon: Icons.article,
                    title: 'Posts Management',
                    subtitle: 'Kelola postingan dengan mudah',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 15),

                  // Products Card
                  _buildFeatureCard(
                    context,
                    icon: Icons.shopping_bag,
                    title: 'Products Catalog',
                    subtitle: 'Jelajahi katalog produk',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 15),

                  // Doa Card
                  _buildFeatureCard(
                    context,
                    icon: Icons.favorite,
                    title: 'Doa Harian',
                    subtitle: 'Koleksi doa sehari-hari',
                    color: Colors.pink,
                  ),
                  const SizedBox(height: 15),

                  // Albums Card
                  _buildFeatureCard(
                    context,
                    icon: Icons.photo_library,
                    title: 'Albums',
                    subtitle: 'Galeri foto dan album',
                    color: Colors.purple,
                  ),

                  const SizedBox(height: 50),

                  // App Info Card
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.6),
            size: 16,
          ),
        ],
      ),
    );
  }
}
