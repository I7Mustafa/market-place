import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_place/constant/constant.dart';
import 'package:market_place/constant/decoration.dart';
import 'package:market_place/constant/toast.dart';
import 'package:market_place/screens/saller/saller.dart';
import 'package:market_place/services/product_services.dart';
import 'package:market_place/widgets/list_of_assets.dart';
import 'package:market_place/widgets/list_of_images.dart';
import 'package:market_place/widgets/loading.dart';
import 'package:market_place/widgets/width_button.dart';
import 'package:market_place/models/product.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddNewProduct extends StatefulWidget {
  final Product product;

  AddNewProduct({this.product});

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final formKey = GlobalKey<FormState>();
  final ProductServices productServices = ProductServices();

  List<Asset> images = List<Asset>();
  List<String> _imageUrls = List();
  Map<String, String> filePaths;

  String type;
  bool loading;

  //faild controller
  String name;
  String price;
  String quantity;
  String description;
  String specifications;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Product',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              images?.isNotEmpty ?? true && widget.product == null
                  ? assetsImages(height, width)
                  : images.isEmpty && widget.product == null
                      ? WidthButton(
                          width: width,
                          onTap: loadAssets,
                          title: 'Add Product Images',
                        )
                      : networkImages(height, width),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Product Name',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Enter Product Name ..' : null,
                  initialValue: widget?.product?.productName ?? '',
                  onChanged: (value) => name = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Price',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Enter Product price ..' : null,
                  initialValue: widget?.product?.price ?? '',
                  onChanged: (value) => price = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Quantity',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Enter Product Quantity ..' : null,
                  initialValue: widget?.product?.quantity ?? '',
                  onChanged: (value) => quantity = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [shadow],
                ),
                child: DropdownButton(
                  hint: Text('Product Type'),
                  isExpanded: true,
                  focusColor: Colors.white,
                  value: widget?.product?.productType ?? type,
                  underline: SizedBox(),
                  style: TextStyle(color: Colors.black87, fontSize: 18.0),
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (String onChange) => setState(
                    () => type = onChange,
                  ),
                  items: types.map((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Description',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Enter Product Description ..' : null,
                  initialValue: widget?.product?.description ?? '',
                  onChanged: (value) => description = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.text,
                  minLines: 3,
                  maxLines: 5,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Specifications',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'Enter Product Specifications ..' : null,
                  initialValue: widget?.product?.specification ?? '',
                  onChanged: (value) => specifications = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.text,
                  minLines: 3,
                  maxLines: 5,
                ),
              ),
              widget.product == null
                  ? addProduct(width, context)
                  : updateProduct(width, context),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox networkImages(double height, double width) {
    return SizedBox(
      height: height / 2,
      width: width,
      child: ListView.builder(
        itemCount: widget.product.productImages?.length ?? 0,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ListOfImages(
            images: widget.product.productImages,
            onTap: () {},
          );
        },
      ),
    );
  }

  SizedBox assetsImages(double height, double width) {
    return SizedBox(
      height: height / 2,
      child: ListView.builder(
        itemCount: images?.length ?? 0,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ListOfAssets(
            onTap: loadAssets,
            height: height,
            width: width,
            images: images,
            index: index,
          );
        },
      ),
    );
  }

  updateProduct(double width, BuildContext context) async {
    return WidthButton(
      title: 'Update',
      loading: loading,
      width: width,
      onTap: () async {
        if (images.isEmpty) {
          // show the loading screen
          setState(() => loading = true);
          // start with uploading the images
          await uploadImages().then((onComplete) async {
            // whene complete add the product data
            await productServices.updateNewProduct(
              proId: widget.product.productId,
              productName: name ?? widget.product.productName,
              price: price ?? widget.product.price,
              productType: type ?? widget.product.productType,
              description: description ?? widget.product.description,
              quantity: quantity ?? widget.product.quantity,
              specification: specifications ?? widget.product.specification,
              productImages: widget.product.productImages,
            );

            // if an error happened
          }).catchError((onError) {
            setState(() => loading = false);
            showToast(context, 'Something went wrong: $onError');

            // when it finshed clear everything and navigate to home
          }).whenComplete(() {
            setState(() {
              loading = false;
              name = '';
              price = '';
              description = '';
              quantity = '';
              specifications = '';
              images.clear();
              type = null;
            });
            showToast(context, 'Product updated Successfuly');

            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => Saller(),
              ),
            );
          });
        }
      },
    );
  }

  addProduct(double width, BuildContext context) {
    return WidthButton(
      loading: loading,
      width: width,
      title: 'Add Product',
      onTap: () async {
        if (formKey.currentState.validate()) {
          // checking if images is not empty
          if (images.isNotEmpty) {
            // show the loading screen
            setState(() => loading = true);
            // start with uploading the images
            await uploadImages().then((onComplete) async {
              // checking if the urls is empty
              if (_imageUrls.isNotEmpty) {
                // when complete add the product data
                await productServices.addNewProduct(
                  productName: name,
                  price: '\$$price',
                  productType: type,
                  description: description,
                  quantity: quantity,
                  specification: specifications,
                  productImages: _imageUrls,
                );
              } else {
                // show that there is something went wrong
                setState(() => loading = false);
                showToast(context, 'Something went wrong');
              }
              // if an error happened
            }).catchError((onError) {
              setState(() => loading = false);
              showToast(context, ('Somthing went wrong: $onError'));

              // when it finshed clear everything and navigate to home
            }).whenComplete(() {
              setState(() {
                loading = false;
                name = '';
                price = '';
                description = '';
                quantity = '';
                specifications = '';
                images.clear();
                type = null;
              });
              showToast(context, ('Product add Successfully'));
            });
          }
        }
      },
    );
  }

  imageView(var width, var index, var height) {
    return Container(
      margin: EdgeInsets.all(12.0),
      width: width / 2 + 34,
      decoration: BoxDecoration(
        boxShadow: [shadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: AssetThumb(
          asset: images[index],
          width: 300,
          height: 300,
          spinner: Loading(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    setState(() => images = List<Asset>());
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
        enableCamera: true,
      );
    } on Exception catch (e) {
      e.toString();
    }
    if (!mounted) return;

    setState(() => images = resultList);
  }

  Future<List<String>> uploadImages() async {
    await Future.wait(
        images.map(
          (Asset asset) async {
            ByteData byteData = await asset.getByteData();
            List<int> imageData = byteData.buffer.asUint8List();

            StorageReference reference =
                FirebaseStorage.instance.ref().child(asset.name);
            StorageUploadTask uploadTask = reference.putData(imageData);
            StorageTaskSnapshot storageTaskSnapshot;

            StorageTaskSnapshot snapshot = await uploadTask.onComplete;
            if (snapshot.error == null) {
              storageTaskSnapshot = snapshot;
              final String downloadUrl =
                  await storageTaskSnapshot.ref.getDownloadURL();
              _imageUrls.add(downloadUrl.toString());

              print('Upload success');
            } else {
              print('Error from image repo ${snapshot.error.toString()}');
              throw ('This file is not an image');
            }
          },
        ),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });

    return _imageUrls;
  }
}
