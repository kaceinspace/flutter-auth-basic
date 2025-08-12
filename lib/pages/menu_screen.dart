import 'package:flutter/material.dart';
import 'package:xii_rpl_3/pages/home_screen.dart';
import 'package:xii_rpl_3/pages/posts/list_post_screen.dart';
import 'package:xii_rpl_3/pages/product/product_list_screen.dart';
import 'package:xii_rpl_3/pages/profile_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ListPostScreen(),
    const ProductListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      _animationController.forward().then((_) {
        setState(() => _currentIndex = index);
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey(_currentIndex),
                child: _pages[_currentIndex],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              spreadRadius: -2,
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.deepPurple.withOpacity(0.3),
              highlightColor: Colors.deepPurple.withOpacity(0.1),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              backgroundColor: Colors.black.withOpacity(0.7),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.6),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Colors.white.withOpacity(0.7),
              ),
              items: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  activeIcon: Icons.home,
                  label: 'Home',
                  isSelected: _currentIndex == 0,
                ),
                _buildNavItem(
                  icon: Icons.article_outlined,
                  activeIcon: Icons.article,
                  label: 'Posts',
                  isSelected: _currentIndex == 1,
                ),
                _buildNavItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag,
                  label: 'Produk',
                  isSelected: _currentIndex == 2,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  isSelected: _currentIndex == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isSelected ? 8 : 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.deepPurple.withOpacity(0.6),
                    Colors.indigo.withOpacity(0.4),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSelected ? activeIcon : icon,
            key: ValueKey(isSelected),
            size: isSelected ? 26 : 24,
          ),
        ),
      ),
      label: label,
    );
  }
}
