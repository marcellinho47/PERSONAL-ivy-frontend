// ignore_for_file: prefer_final_fields

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/config/storage_config.dart';
import 'package:sys_ivy_frontend/entity/product_entity.dart';
import 'package:sys_ivy_frontend/repos/category_repo.dart';
import 'package:sys_ivy_frontend/repos/product_repo.dart';

import '../entity/category_entity.dart';
import '../utils/toasts.dart';

class ProductAddEditScreen extends StatefulWidget {
  final Object? args;

  const ProductAddEditScreen(this.args, {Key? key}) : super(key: key);

  @override
  State<ProductAddEditScreen> createState() => _ProductAddEditScreenState();
}

class _ProductAddEditScreenState extends State<ProductAddEditScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _id = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();

  List<Uint8List> _images = [];
  List<CategoryEntity> _listCategory = [];
  CategoryEntity? _categoryDropdownValue;

  FirebaseStorage _storage = FirebaseStorage.instance;
  Object? _args;
  CategoryRepo _categoryRepo = CategoryRepo();
  ProductRepo _productRepo = ProductRepo();

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _args = widget.args;

    _cleanForm();
    _fillCategories();
    _recoverProduct();
  }

  void _fillCategories() async {
    _categoryRepo.findAllEnabled().then((list) {
      setState(() {
        _listCategory.addAll(list);
      });
    });
  }

  void _cleanForm() {
    _id.clear();
    _name.clear();
    _description.clear();
    _categoryDropdownValue = null;
    _images = [];
  }

  void _recoverProduct() async {
    if (_args != null && _args.toString().isNotEmpty) {
      ProductEntity? product = await _productRepo.findById(_args as int);

      if (product != null) {
        setState(() {
          _id.text = product.idProduct!.toString();
          _description.text =
              product.description == null ? '' : product.description!;
          _name.text = product.name!;
          _onChangeDropdown(product.category!);
          _getImages(product.images);
        });
      }
    }
  }

  void _getImages(List<String> images) {
    if (images.isEmpty) {
      _images = [];
    }

    for (String imageUrl in images) {
      _storage.refFromURL(imageUrl).getData().then((data) {
        setState(() {
          if (data != null) {
            _images.add(data);
          }
        });
      });
    }
  }

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 650;
    }

    return loginBoxWidth;
  }

  void _validForm() async {
    if (_listCategory.isEmpty) {
      showToast(context, WARNING_TYPE_TOAST,
          'Não existe nenhuma categoria cadastrada', null, null);
      return;
    }

    if (_name.text.isEmpty) {
      showToast(context, WARNING_TYPE_TOAST, "Nome é um campo obrigatório!",
          null, null);
      return;
    }

    if (_categoryDropdownValue == null) {
      showToast(context, WARNING_TYPE_TOAST,
          "Categoria é um campo obrigatório!", null, null);
      return;
    }

    if (_description.text.isEmpty) {
      showToast(context, WARNING_TYPE_TOAST,
          "Descrição é um campo obrigatório!", null, null);
      return;
    }

    // Valid if exists another product with the same name
    List<ProductEntity?> listProduct =
        await _productRepo.findByName(_name.text);

    if (listProduct.isNotEmpty &&
        (_id.text.isEmpty ||
            listProduct.first!.idProduct != int.parse(_id.text))) {
      showToast(
          context,
          WARNING_TYPE_TOAST,
          "Já existe um produto com este nome - ID: ${listProduct.first!.idProduct}!",
          null,
          null);
      return;
    }

    _saveOrUpdate();
  }

  void _saveOrUpdate() async {
    List<String> savedImage = await _saveImages();
    ProductEntity pe = _formToObject(savedImage);

    _productRepo.save(pe);

    _cleanForm();
    showToast(
        context, SUCESS_TYPE_TOAST, "Produto salvo com sucesso!", null, null);
    Navigator.pushReplacementNamed(context, Routes.PRODUCTS_ROUTE);
  }

  ProductEntity _formToObject(List<String> savedImage) {
    return ProductEntity(
      idProduct: _id.text.isEmpty ? null : int.parse(_id.text),
      name: _name.text,
      description: _description.text,
      category: _categoryDropdownValue,
      images: savedImage,
    );
  }

  Future<List<String>> _saveImages() async {
    List<String> images = [];

    for (var image in _images) {
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

      Reference ref =
          _storage.ref().child(StorageConfig.PRODUCTS_IMAGE_PATH + fileName);

      await ref.putData(image);

      images.add(fileName);
    }

    return images;
  }

  void _selectImage() async {
    // image
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      dialogTitle: "Selecione as imagens",
    );

    if (result == null) {
      return;
    }

    for (PlatformFile file in result.files) {
      if (file.size > 10485760) {
        showToast(context, WARNING_TYPE_TOAST,
            "Tamanho máximo de arquivo é 10MB", null, null);
        return;
      }

      setState(() {
        _images.add(file.bytes!);
      });
    }
  }

  void _onChangeDropdown(CategoryEntity value) {
    setState(() {
      _categoryDropdownValue = _listCategory
          .where((element) => element.idCategory == value.idCategory)
          .first;
    });
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: _boxWidth(_screenWidth),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _id,
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "ID Produto",
                        suffixIcon: Icon(Icons.star_border_rounded),
                      ),
                    ),
                    TextField(
                      controller: _name,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "Nome / Título",
                        suffixIcon: Icon(Icons.text_fields_rounded),
                      ),
                    ),
                    TextField(
                      controller: _description,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "Descrição",
                        suffixIcon: Icon(Icons.text_fields_rounded),
                      ),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      hint: const Text("Categoria"),
                      borderRadius: BorderRadius.circular(10),
                      value: _categoryDropdownValue,
                      items: List<DropdownMenuItem<CategoryEntity>>.generate(
                        _listCategory.length,
                        (index) => DropdownMenuItem<CategoryEntity>(
                          value: _listCategory[index],
                          child: Text(_listCategory[index].description!),
                        ),
                      ),
                      onChanged: (CategoryEntity? category) {
                        setState(() {
                          _onChangeDropdown(category!);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: _images.isNotEmpty,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                shrinkWrap: true,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.memory(
                            _images[index],
                            height: 120,
                            filterQuality: FilterQuality.high,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_rounded),
                            onPressed: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                            tooltip: "Remover imagem",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _selectImage,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Adicionar imagem",
                        softWrap: true,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.add_a_photo_rounded,
                        size: 15,
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cleanForm();
                    });
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Limpar"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.cleaning_services_rounded,
                        size: 15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _validForm();
                    });
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Salvar"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.save_alt_rounded,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
