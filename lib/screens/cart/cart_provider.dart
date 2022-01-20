import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/helpers/toasts/toast.dart';

class CartProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  double _price = 0.0;
  double _singlePrice = 0.0;
  // get
  double get totalPrice => _price;
  double get singlePrice => _singlePrice;
  //
  List<CartModel> cartModels = <CartModel>[];
  //
  void setStreamProducts(String value) {
    //Stream<QuerySnapshot>
    // searchCartModels =
    //     db.collection("productsCollection").snapshots().map((event) {
    //   return event.docs.map((e) {
    //     return CartModel.fromJson(e.data());
    //   }).toList();
    // });
  }

  void search(String value) {
    // searchCartModels = value.isNotEmpty
    //     ? cartModels.where((element) {
    //         if (element.name.contains(value)) {
    //           notifyListeners();
    //           return true;
    //         }
    //         notifyListeners();
    //         return false;
    //       }).toList()
    //     : cartModels;
  }

  //
  void addQty(CartModel product) {
    product.qty++;
    // _singlePrice = double.parse(cartModels[product].price) * 1.0;
    _singlePrice = product.qty * double.parse(product.price);
    _price += _singlePrice;
    // _price = _price + int.parse(product['product_price']);
    debugPrint('_price = $_price');
    // return;
    notifyListeners();
  }

  void removeQty(CartModel product) {
    if (product.qty > 0) {
      product.qty--;
      _price = product.qty * double.parse(product.price);
      notifyListeners();
    }
  }

  //  add product to your cart
  void addProtductToCart(QueryDocumentSnapshot<Object?> product) {
    // define obj from cart model
    final CartModel _cartModel = CartModel(
      product.get('product_id'),
      product.get('vendor_id'),
      1,
      product.get('product_price'),
      product.get('product_name'),
      product.get('product_description'),
      product.get('img_path'),
    );

    if (cartModels.contains(_cartModel)) {
      Toast.error(error: 'this product is alerady exist on your cart !!');
      return;
    }
    _price = _cartModel.qty * double.parse(product['product_price']);

    cartModels.add(_cartModel);
    notifyListeners();
    Toast.success(msg: 'add to cart succussfly !!');
    notifyListeners();
  }

  //  remove product from cart
  void removeProtductFromCart(CartModel product) {
    cartModels.remove(product);
    //
    if (cartModels.isEmpty) {
      _price = 0.0;
      notifyListeners();
    } else {
      // _price = _price - int.parse(product.get('product_price'));
      notifyListeners();
    }
  }
  //
}

class CartModel {
  CartModel(this.id, this.vendorID, this.qty, this.price, this.name,
      this.description, this.imgPath);
  //
  String id;
  String vendorID;
  int qty = 1;
  String price;
  String name;
  String description;
  String imgPath;
  //
  //
  factory CartModel.fromJson(Map map) {
    return CartModel(
      map['vendor_id'],
      map['product_id'],
      map['qty'],
      map['product_price'],
      map['product_name'],
      map['product_description'],
      map['img_path'],
    );
  }
}
