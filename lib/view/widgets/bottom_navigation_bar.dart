part of 'widgets.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1), // changes position of shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        elevation: 0, // We use Container decoration for shadow instead
        selectedItemColor: Style.blue800, // Matches your Style.blue800
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping), // Truck icon for Domestic
            label: 'Domestic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight), // Plane icon for International
            label: 'International',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), // Grid icon for History/Menu
            label: 'History',
          ),
        ],
      ),
    );
  }
}