import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_place/constant/constant.dart';
import 'package:market_place/models/product.dart';

class ProductServices {
  addNewProduct({
    String productName,
    String productType,
    String price,
    String quantity,
    String description,
    String specification,
    List productImages,
  }) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return await productCollection.document().setData({
      'sallerId': currentUser.uid,
      'productName': productName,
      'productType': productType,
      'price': price,
      'quantity': quantity,
      'description': description,
      'specification': specification,
      'productImages': productImages ?? 'null',
      'CompanyName': currentUser.displayName ?? 'null',
    });
  }

  updateNewProduct({
    String proId,
    String productName,
    String productType,
    String price,
    String quantity,
    String description,
    String specification,
    List productImages,
  }) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return await productCollection.document(proId).updateData({
      'sallerId': currentUser.uid,
      'productName': productName,
      'productType': productType,
      'price': price,
      'quantity': quantity,
      'description': description,
      'specification': specification,
      'productImages': productImages ?? 'null',
      'CompanyName': currentUser.displayName ?? 'null',
    });
  }

  List<Product> productList(QuerySnapshot snapshot) {
    return snapshot.documents.map((pro) {
      return Product(
        productId: pro.documentID,
        productName: pro.data['productName'],
        productType: pro.data['productType'],
        price: pro.data['price'],
        quantity: pro.data['quantity'],
        description: pro.data['description'],
        specification: pro.data['specification'],
        productImages: pro.data['productImages'],
        companyName: pro.data['CompanyName'],
      );
    }).toList();
  }

  Stream<List<Product>> get productListstrm {
    return productCollection.snapshots().map(productList);
  }
}
