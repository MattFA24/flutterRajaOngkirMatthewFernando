part of 'pages.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DomesticPage(), 
    const InternationalPage(), 
    const HomePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        // <--- The Nav Bar
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
