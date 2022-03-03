import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/entity/category_entity.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController _id = TextEditingController();
  TextEditingController _description = TextEditingController();

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 700;
    }

    return loginBoxWidth;
  }

  void _search() {}

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: _boxWidth(_screenWidth),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _id,
                        keyboardType: TextInputType.text,
                        enabled: true,
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: "Código",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: _description,
                        keyboardType: TextInputType.text,
                        enabled: true,
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: "Descrição",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _search();
                          });
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text("Pesquisar"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.search_rounded,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDataTableSource extends DataTableSource {
  List<CategoryEntity> _listCategories;
  void Function() refreshComponent;

  CategoryDataTableSource(this._listCategories, this.refreshComponent);

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(
      onSelectChanged: (value) {
        selectIndex(index, value);
      },
      selected: isSelect(index),
      index: index,
      cells: <DataCell>[
        DataCell(
          Text(_listCategories[index].idCategory.toString()),
        ),
        DataCell(
          Text(_listCategories[index].description ?? ""),
        ),
        DataCell(_listCategories[index].enabled!
            ? const Icon(Icons.check_circle_outline_rounded)
            : const Text("")),
      ],
    );
  }

  void selectIndex(int index, bool? isSelect) {
    _listCategories.elementAt(index).isSelect = isSelect ?? false;
    refreshComponent();
  }

  bool isSelect(int index) {
    return _listCategories.elementAt(index).isSelect;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _listCategories.length;

  @override
  int get selectedRowCount =>
      _listCategories.where((element) => element.isSelect).toList().length;
}
