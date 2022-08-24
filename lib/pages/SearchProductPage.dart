import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/ButtonSecond.dart';
import '../components/TextFieldMain.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import '../utils/routes.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({Key? key}) : super(key: key);

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  TextEditingController nombreController = TextEditingController();
  String? _nombreError;

  String? businessId;
  Product? _product;
  late String product;
  Business? business;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getArguments();
      nombreController.text = "";
    });
    super.initState();
  }

  bool isLoading = true;

  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_search_product,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? waitingConnection()
          : ListView(
              children: [
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: textfield_hint_name_product,
                    labelText: textfield_label_name,
                    textEditingController: nombreController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _nombreError,
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonSecond(
                    onPressed: _saveData,
                    //_nextScreenArgs(see_product_info_route, product),
                    text: button_search,
                  ),
                ),
              ],
            ),
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }
    business = args[business_args];
    setState(() {
      isLoading = false;
    });
  }

  _saveData() async {
    _businessDataSource
        .getProductForName(business!.id, nombreController.text)
        .then((product) => {
              if (product != null)
                {
                  setState(() {
                    _product = product;
                    isLoading = false;
                    _nextScreenArgs(see_product_info_route, _product!);
                  }),
                }
              else
                {
                  _showToast("The product was not found"),
                }
            });
  }

  void _nextScreenArgs(String route, Product product) {
    final args = {product_args: product};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Center waitingConnection() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
        width: 75,
        height: 75,
      ),
    );
  }

  void _showToast(String content) {
    final snackBar = SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
