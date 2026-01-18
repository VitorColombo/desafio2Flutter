import 'package:flutter/material.dart';
import '../models/shopping_list.dart';
import 'add_shopping_list_page.dart';
import 'shopping_list_products_page.dart';

class ShoppingListsPage extends StatefulWidget {
  const ShoppingListsPage({super.key});

  @override
  State<ShoppingListsPage> createState() => _ShoppingListsPageState();
}

class _ShoppingListsPageState extends State<ShoppingListsPage> {
  List<ShoppingList> _shoppingLists = [];

  void _addShoppingList(ShoppingList list) {
    setState(() {
      _shoppingLists.add(list);
    });
  }

  void _updateShoppingList(String id, ShoppingList updatedList) {
    setState(() {
      final index = _shoppingLists.indexWhere((list) => list.id == id);
      if (index != -1) {
        _shoppingLists[index] = updatedList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.grey[500],
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1.0),
        toolbarHeight: 95,
        titleSpacing: 0,
        centerTitle: true,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Padding( 
            padding: const EdgeInsets.only(bottom: 16.0),
            child: const Text(
              'Minhas listas',
              key: Key('appBarTitle'),
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.normal),
            ),
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: const Icon(Icons.diamond, color: Color(0xFFFFC107), size: 30),
            ),
          ),
        ],
      ),
      body: _shoppingLists.isEmpty
          ? Center( 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: 
                    Image.asset(
                      'assets/images/lista-de-compras.png',
                      key: const Key('emptyListImage'),
                    )
                  ),
                  SizedBox(height: 30),
                  const Text('Crie sua primeira lista', style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal)),
                  const Text('Toque no botão azul', style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _shoppingLists.length,
              itemBuilder: (context, index) {
                final list = _shoppingLists[index];
                return Card(
                  color: const Color.fromRGBO(245, 245, 245, 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: ListTile(
                    key: const Key('shoppingListCard'),
                    contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(list.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                        Text(
                          '${list.products.where((product) => product.isPurchased).length}/${list.products.length}', 
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.normal,
                            color: Color.fromRGBO(76, 175, 80, 1.0),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: list.products.isEmpty 
                                ? 0.0 
                                : list.products.where((product) => product.isPurchased).length / list.products.length,
                            backgroundColor: const Color.fromARGB(255, 179, 179, 179),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(76, 175, 80, 1.0)),
                            minHeight: 4,
                          ),
                        ],
                      ),
                    ),
                    tileColor: const Color.fromRGBO(255, 255, 255, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onTap: () async {
                      final updatedList = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingListProductsPage(
                            shoppingList: list,
                          ),
                        ),
                      );
                      if (updatedList != null) {
                        _updateShoppingList(list.id, updatedList);
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        key: const Key('addListBtn'),
        onPressed: () async {
          final newList = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddShoppingListPage(),
            ),
          );
          if (newList != null) {
            _addShoppingList(newList);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
