import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/models/grocery_item.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<GroceryItemModel> _shoppingList = [
    GroceryItemModel(listId: 1, name: 'Lait', isChecked: false, quantity: 500, price: 1.5),
    GroceryItemModel(listId: 2, name: 'Riz', isChecked: false, quantity: 2, price: 3.0),
  ];

  final List<String> _units = ['ml', 'kg', 'g', 'l', 'mg', 'cl', 'pcs'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de courses'),
      ),
      body: ListView.builder(
        itemCount: _shoppingList.length,
        itemBuilder: (context, index) {
          final item = _shoppingList[index];
          return ListTile(
            title: Text('${item.quantity} ${item.unit} de ${item.name}'),
            trailing: DropdownButton<String>(
              value: item.unit.isEmpty ? null : item.unit,
              hint: Text('Unité'),
              items: _units.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  item.unit = newValue ?? '';
                });
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ShoppingListScreen(),
   ));
}