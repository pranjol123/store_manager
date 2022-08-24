import 'package:flutter/material.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/TextFieldMain.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductState();
}

class _EditProductState extends State<EditProductPage> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioMayoreoController = TextEditingController();
  TextEditingController precioUnitarioController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController ventaMesController = TextEditingController();
  TextEditingController ventaSemanaController = TextEditingController();

  late String idNegocio, negocio;
  String? product;
  Product? _product;
  Business? _business;
  String? _nombreError;
  String? _precioMayoreoError;
  String? _precioUnitarioError;
  String? _stockError;
  String? _ventaSemanaError;
  String? _ventaMesError;

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getArguments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: "Edit Product",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? waitingConnection()
          : ListView(
              children: [
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Product name",
                    labelText: "Product name",
                    textEditingController: nombreController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _nombreError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Unit price",
                    labelText: "Unit price",
                    textEditingController: precioUnitarioController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    isNumber: true,
                    errorText: _precioUnitarioError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Wholesale price",
                    labelText: "Wholesale price",
                    textEditingController: precioMayoreoController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    isNumber: true,
                    errorText: _precioMayoreoError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Stock",
                    labelText: "Stock",
                    textEditingController: stockController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    isNumber: true,
                    errorText: _stockError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Sales per week",
                    labelText: "Sales per week",
                    textEditingController: ventaSemanaController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    isNumber: true,
                    errorText: _ventaSemanaError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Sales per month",
                    labelText: "Sales per month",
                    textEditingController: ventaMesController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    isNumber: true,
                    errorText: _ventaMesError,
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonSecond(
                    onPressed: _saveData,
                    text: button_save,
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

    _product = args[product_args];

    nombreController.text = _product!.nombre;
    precioMayoreoController.text = _product!.precioMayoreo.toString();
    precioUnitarioController.text = _product!.precioUnitario.toString();
    stockController.text = _product!.stock.toString();
    ventaMesController.text = _product!.ventaMes.toString();
    ventaSemanaController.text = _product!.ventaSemana.toString();

    idNegocio = _product!.idNegocio.toString();

    _businessDataSource.getBusiness(idNegocio).then((business) => {
          if (business != null)
            {
              setState(() {
                _business = business;
                negocio = _business!.nombreNegocio.toString();
                _isLoading = false;
              }),
            }
          else
            {print(business?.id)}
        });
  }

  void _saveData() async {
    _nombreError = null;
    _precioMayoreoError = null;
    _precioUnitarioError = null;
    _stockError = null;
    _ventaSemanaError = null;
    _ventaMesError = null;

    if (nombreController.text.isEmpty) {
      setState(() {
        _nombreError = "The product name cannot be left empty";
      });

      return;
    }

    if (precioMayoreoController.text.isEmpty) {
      setState(() {
        _precioMayoreoError = "The wholesale price cannot be left empty";
      });

      return;
    }

    if (precioUnitarioController.text.isEmpty) {
      setState(() {
        _precioUnitarioError = "The unit price cannot be empty";
      });

      return;
    }

    if (stockController.text.isEmpty) {
      setState(() {
        _stockError = "The stock cannot be empty";
      });

      return;
    }

    if (ventaMesController.text.isEmpty) {
      setState(() {
        _ventaMesError = "Sales per month cannot be empty";
      });

      return;
    }

    if (ventaSemanaController.text.isEmpty) {
      setState(() {
        _ventaSemanaError = "Sales per week can not be empty";
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    _product?.nombre = nombreController.text;
    _product?.precioMayoreo = double.parse(precioMayoreoController.text);
    _product?.precioUnitario = double.parse(precioUnitarioController.text);
    _product?.stock = double.parse(stockController.text);
    _product?.ventaSemana = int.parse(ventaSemanaController.text);
    _product?.ventaMes = int.parse(ventaMesController.text);

    if (_product != null &&
        await _businessDataSource.updateProduct(_product!)) {
      _showToast("Updated data");
      Navigator.pop(context);
    } else {
      _showToast("Error updating data");
    }
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
}
