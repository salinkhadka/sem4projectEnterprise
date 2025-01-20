import 'package:drift/drift.dart' hide Column;
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/customDropDown.dart';
import 'package:byaparlekha/components/drawer.dart';
import 'package:byaparlekha/components/reorderable_list.dart' as Component;
import 'package:byaparlekha/config/utility/enum.dart';
import 'package:byaparlekha/config/globals.dart' as globals;
import 'package:byaparlekha/config/utility/validator.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/icons/vector_icons.dart';
import 'package:byaparlekha/models/categoryModel.dart';

import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/models/valueModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:byaparlekha/widget/formWidget.dart';
import 'package:provider/provider.dart';

import '../components/extra_componenets.dart';

import '../config/configuration.dart';
import '../config/globals.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Lang? language;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Configuration().appColor,
      appBar: AppBar(
        title: AdaptiveText(
          TextModel('Categories'),
          style: TextStyle(fontSize: 17),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if ((await showDialog(
                context: context,
                builder: (context) => Consumer<PreferenceProvider>(
                  builder: (context, value, child) => CategoryDialog(
                    isCashIn: _tabController.index == 0,
                  ),
                ),
              )) ??
              false) {
            setState(() {});
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 27,
        ),
        backgroundColor: Configuration().secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 23.0),
        child: Container(
          decoration: pageBorderDecoration,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              TabBar(
                isScrollable: true,
                dividerHeight: 0,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Configuration().secondaryColor,
                ),
                controller: _tabController,
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: AdaptiveText(
                        TextModel('Cash In'),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: AdaptiveText(
                        TextModel('Cash Out'),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [CategoryType.INCOME, CategoryType.EXPENSE]
                      .map((categoryType) => StreamBuilder<List<CategoryModel>>(
                                stream: AppDatabase()
                                    .myDatabase
                                    .categoryDao
                                    .watchCategoryByIncomeExpense(
                                        categoryType == CategoryType.INCOME),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.isEmpty) {
                                      return centerHintText(
                                          text: 'Categories Not Found');
                                    }

                                    final groupedBudgetData = snapshot.data!
                                        .groupBy((p0) => p0.categoryHeadingId);
                                    final keys =
                                        groupedBudgetData.keys.toList();
                                    return ListView.builder(
                                      itemCount: keys.length,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      itemBuilder: (context, index) {
                                        final currentData =
                                            groupedBudgetData[keys[index]]!;
                                        return _categoryHeaders(
                                          TextModel(currentData
                                              .first.categoryHeadingName),
                                          currentData,
                                        );
                                      },
                                    );
                                  } else
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                },
                              )
                          //  _reorderableListView(
                          //   categoryType == CategoryType.EXPENSE ? globals.expenseCategories! : globals.incomeCategories!,
                          //   categoryType,
                          // ),
                          )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryHeaders(
      TextModel textModel, List<CategoryModel> categoryData) {
    categoryData.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AdaptiveText(
                textModel,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return dataList(categoryData[index]);
            },
            separatorBuilder: (context, _) => SizedBox(height: 10.0),
            itemCount: categoryData.length),
      ],
    );
  }

  Widget dataList(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.withOpacity(0.7))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: ListTile(
              title: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: category.iconName == null
                          ? Icon(
                              VectorIcons.fromName(
                                'hornbill',
                                provider: IconProvider.FontAwesome5,
                              ),
                              color: Configuration().appColor,
                              size: 20.0,
                            )
                          : SvgPicture.asset(
                              'assets/images/${category.iconName}')),
                  Flexible(
                    child: AdaptiveText(
                      TextModel(category.name, nepaliName: category.nepaliName),
                      // category: categories[i],
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xff272b37),
                        height: 1.4285714285714286,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 1) {
                    _showEditDialog(category.id, category.name);
                  } else {
                    _showDeleteDialog(category.id);
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                      value: 1, child: AdaptiveText(TextModel("Edit"))),
                  PopupMenuItem(
                      value: 2, child: AdaptiveText(TextModel("Delete")))
                ],
              )),
        ),
      ),
    );
  }

  Future _showDeleteDialog(int categoryId) async {
    await showDeleteDialog(context,
        title: 'Delete Category',
        description:
            '''Are you sure you want to delete this category? Deleting the category will also clear all the records related to it.''',
        onDeletePress: () async {
      try {
        await AppDatabase().myDatabase.categoryDao.deleteCategory(categoryId);
        Navigator.of(context, rootNavigator: true).pop(true);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
      // await CategoryService().deleteCategory(selectedSubSector!, categoryId, _tabController!.index == 0 ? CategoryType.INCOME : CategoryType.EXPENSE, false);
    }, onCancelPress: () {
      Navigator.of(context, rootNavigator: true).pop(false);
    }).then((value) {
      if (value ?? false) {
        setState(() {});
      }
    });
  }

  Future _showEditDialog(int categoryId, String categoryName) async {
    final TextEditingController categoryTextEditing =
        TextEditingController(text: categoryName);
    await showFormDialog(context,
        title: "Edit Category",
        bodyWidget: Form(
          key: _formKey,
          child: FormWidget(
            title: "Category Name",
            child: TextFormField(
              validator: Validators.emptyFieldValidator,
              controller: categoryTextEditing,
            ),
          ),
        ),
        buttonText: "Submit", onButtonPressed: () async {
      FocusScope.of(context).requestFocus(FocusNode());
      if (_formKey.currentState!.validate()) {
        if (categoryTextEditing.text == categoryName) {
          Navigator.pop(context);
          return;
        }
        try {
          await AppDatabase()
              .myDatabase
              .categoryDao
              .updateCategoryName(categoryId, categoryTextEditing.text);
          Navigator.pop(context);
        } catch (e) {}
      }
    });
  }

  // void _reorderCategoryList(int preIndex, int postIndex) {
  //   if (_tabController!.index == 0) {
  //     Category temp = globals.expenseCategories![preIndex];
  //     globals.expenseCategories!.removeAt(preIndex);
  //     globals.expenseCategories!.insert(postIndex > preIndex ? postIndex - 1 : postIndex, temp);
  //     CategoryService().refreshCategories(selectedSubSector!, globals.expenseCategories!, type: CategoryType.INCOME);
  //   } else {
  //     Category temp = globals.incomeCategories![preIndex];
  //     globals.incomeCategories!.removeAt(preIndex);
  //     globals.incomeCategories!.insert(postIndex > preIndex ? postIndex - 1 : postIndex, temp);
  //     CategoryService().refreshCategories(selectedSubSector!, globals.incomeCategories!, type: CategoryType.EXPENSE);
  //   }
  //   setState(() {});
  // }
}

class CategoryDialog extends StatefulWidget {
  final bool isCashIn;

  const CategoryDialog({Key? key, required this.isCashIn}) : super(key: key);
  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  int? categoryHeadingId;
  final TextEditingController categoryName = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  Lang? language;
  List<CategoryHeadingData>? categoryHeading;
  @override
  void initState() {
    AppDatabase()
        .myDatabase
        .categoryHeadingDao
        .getByIncomeExpense(widget.isCashIn)
        .then((value) {
      setState(() {
        categoryHeading = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    language = Provider.of<PreferenceProvider>(context).language;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 23),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SvgPicture.string(
                              userLogo,
                              allowDrawingOutsideViewBox: true,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AdaptiveText(
                              TextModel('Category Heading'),
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xff43425d),
                                height: 1.5625,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomDropDown(
                            selectedValue: categoryHeadingId,
                            onValueSelected: (value) {
                              setState(() {
                                categoryHeadingId = value;
                              });
                            },
                            validator: Validators.dropDownFieldValidator,
                            values: (categoryHeading ?? [])
                                .map(
                                  (e) => ValueModel(
                                    id: e.id,
                                    name: e.name,
                                    nepaliName: e.nepaliName,
                                    iconData: e.iconName == null
                                        ? Icon(VectorIcons.fromName(
                                            e.iconName ?? 'hornbill',
                                            provider: IconProvider.FontAwesome5,
                                          ))
                                        : SvgPicture.asset(
                                            'assets/images/${e.iconName}',
                                          ),
                                  ),
                                )
                                .toList()),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            SvgPicture.string(
                              userLogo,
                              allowDrawingOutsideViewBox: true,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AdaptiveText(
                              TextModel('Category Name'),
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xff43425d),
                                height: 1.5625,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          validator: Validators.emptyFieldValidator,
                          controller: categoryName,
                          style: TextStyle(
                              color: Colors.grey[800], fontSize: 20.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              TextButton.icon(
                onPressed: _addCategory,
                icon: Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
                label: AdaptiveText(
                  TextModel(
                      'Add' + ' ' + (widget.isCashIn ? 'Cash In' : 'Cash Out')),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Future _addCategory() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState!.validate()) {
      try {
        await AppDatabase().myDatabase.categoryDao.insertData(CategoryCompanion(
            name: Value<String>(categoryName.text),
            nepaliName: Value<String>(categoryName.text),
            categoryHeadingId: Value<int>(categoryHeadingId!),
            iconName: Value<String>('hornbill')));
        Navigator.of(context, rootNavigator: true).pop(true);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }
}
