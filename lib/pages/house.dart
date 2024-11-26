import 'package:flutter/material.dart';
import 'package:casaproy/pages/house_pages/bath.dart';
import 'package:casaproy/pages/house_pages/sala.dart';
import 'package:casaproy/pages/house_pages/cocina.dart';
import 'package:casaproy/pages/house_pages/escaleras.dart';
import 'package:casaproy/pages/house_pages/cuarto.dart';

class House extends StatefulWidget {
  const House({super.key});

  @override
  _HouseState createState() => _HouseState();
}

class _HouseState extends State<House> {
  int _pagActual = 0;
  final List<Widget> _paginas = [Sala(), Cocina(), Escaleras(), Cuarto(), Bath()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[_pagActual],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _pagActual = index;
          });
        },
        currentIndex: _pagActual,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Sala',
            backgroundColor: Colors.brown,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'Cocina',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stairs),
            label: 'Escaleras',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bed),
            label: 'Cuarto',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bathtub),
            label: 'Baño',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
