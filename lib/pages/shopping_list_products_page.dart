import 'package:flutter/material.dart';
import '../models/shopping_list.dart';
import '../models/product.dart';
import '../widgets/add_product_bottom_sheet.dart';

class ShoppingListProductsPage extends StatefulWidget {
  final ShoppingList shoppingList;

  const ShoppingListProductsPage({
    super.key,
    required this.shoppingList,
  });

  @override
  State<ShoppingListProductsPage> createState() =>
      _ShoppingListProductsPageState();
}

class _ShoppingListProductsPageState
    extends State<ShoppingListProductsPage> {
  late ShoppingList _currentList;

  @override
  void initState() {
    super.initState();
    _currentList = ShoppingList(
      id: widget.shoppingList.id,
      name: widget.shoppingList.name,
      products: widget.shoppingList.products
          .map((product) => product.copyWith())
          .toList(),
    );
  }

  void _addProduct(Product product) {
    _currentList.products.add(product);
    setState(() {});
  }

  void _toggleProduct(int index) {
    _currentList.products[index].isPurchased = !_currentList.products[index].isPurchased;
    setState(() {});
  }

  void _updateList() {
    Navigator.pop(context, _currentList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.grey[500],
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1.0),
        toolbarHeight: 95,
        automaticallyImplyLeading: false,
        leading: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
              tooltip: 'Voltar',
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 26),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
              child: TextButton(
                key: const Key('updateListBtn'),
                onPressed: _updateList,
                child: Text('Atualizar', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 20.0, right: 16.0, bottom: 8.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _currentList.name,
                  key: const Key('shoppingListTitle'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Divider(height: 1, color: Colors.grey[400]),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _currentList.products.length,
                itemBuilder: (context, index) {
                  final product = _currentList.products[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    leading: Transform.scale(
                      scale: 2,
                      child: Checkbox(
                        key: Key('productCheckbox'),
                        side: const BorderSide(
                          color:  Color.fromARGB(255, 33, 150, 243),
                          width: 1.0,
                        ),
                        activeColor: const Color.fromRGBO(76, 175, 80, 1.0),
                        checkColor: Colors.white,
                        value: product.isPurchased,
                        onChanged: (value) => _toggleProduct(index),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(76, 175, 80, 1.0),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: product.isPurchased
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    trailing: Text(
                      'R\$ ${product.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () => _toggleProduct(index),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Não marcados', style: TextStyle(fontWeight: FontWeight.normal)),
                      Text(
                        'R\$ ${_currentList.totalNotPurchased.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color:  Color.fromARGB(255, 33, 150, 243),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Marcados', style: TextStyle(fontWeight: FontWeight.normal)),
                      Text(
                        'R\$ ${_currentList.totalPurchased.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(76, 175, 80, 1.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Adicionar', style: TextStyle(color: Colors.white, fontSize: 16)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        key: const Key('addNewItemBtn'),
        onPressed: () async {
          final newProduct = await showModalBottomSheet<Product>(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddProductBottomSheet(),
          );
          if (newProduct != null) {
            _addProduct(newProduct);
          }
        },
      ),
    );
  }
}
