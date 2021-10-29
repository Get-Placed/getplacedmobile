import 'package:flutter/material.dart';
import 'package:placement_cell/admin/compAdmin/compHome.dart';
import 'package:placement_cell/admin/compAdmin/compTrackInfo.dart';
import 'package:placement_cell/services/values.dart';

class CompNavTab extends StatefulWidget {
  final String logoUrl, owner, compName;
  const CompNavTab({
    Key? key,
    required this.owner,
    required this.compName,
    required this.logoUrl,
  });

  @override
  _CompNavTabState createState() => _CompNavTabState();
}

class _CompNavTabState extends State<CompNavTab> {
  int _selectedIndex = 0;

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgets = [
      CompanyHome(
          owner: widget.owner,
          logoUrl: widget.logoUrl,
          compName: widget.compName),
      CompInfoTrack(
        compName: widget.compName,
      ),
    ];
    return Scaffold(
      body: _widgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTapped,
        selectedItemColor: k_btnColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart_outlined),
            label: "",
          ),
        ],
      ),
    );
  }
}
