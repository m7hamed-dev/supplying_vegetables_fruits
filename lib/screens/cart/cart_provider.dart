import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/helpers/toasts/toast.dart';

class CartProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot<Object?>> cartItems = [];
  double _price = 0.0;
  int qty = 0;
  double get totalPrice => _price;
  //
  void addQty(QueryDocumentSnapshot<Object?> product) {
    Map map = {
      'qty': product.get('qty'),
    };
    int cartModel = CartModel.fromJson(map).qty++;
    _price = _price * cartModel;
    // cartModel = cartModel + 1;
    debugPrint('cartModel = ${cartModel++}');
    notifyListeners();
    // debugPrint(' _qty = $_qty');
    // product.
    // int r = product.get('qty');
    // if (r != 0) {
    //   r += 1;
    //   debugPrint('r = $r');
    // }
  }

  //
  void addProtductToCart(QueryDocumentSnapshot<Object?> product) {
    if (cartItems.contains(product)) {
      Toast.error(error: 'this product is alerady exist on your cart !!');
      return;
    }
    _price = _price + int.parse(product.get('product_price'));
    cartItems.add(product);

    // _price = _price + int.parse(product['product_price']);
    Toast.success(msg: 'add to cart succussfly !!');
    notifyListeners();
  }

  void removeProtductFromCart(QueryDocumentSnapshot<Object?> product) {
    cartItems.remove(product);
    if (cartItems.isEmpty) {
      _price = 0.0;
    } else
      _price = _price - int.parse(product.get('product_price'));
    notifyListeners();
  }
  //
}

class CartModel {
  int qty;
  CartModel(this.qty);
  //
  factory CartModel.fromJson(Map map) {
    return CartModel(map['qty']);
  }
}
