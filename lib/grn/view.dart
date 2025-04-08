// lib/screens/grn_screen.dart
import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mri/custom_alert/custom_alert.dart';
import 'package:mri/data/common/common_repository.dart';
import 'package:mri/data/fa_items/fa_items_repository.dart';
import 'package:mri/data/grn_items/grn_items_details.dart';
import 'package:mri/data/grn_items/grn_items_repository.dart';
import 'package:mri/data/user/user_repository.dart';
import 'package:mri/grn/responsive_fields.dart';

class GRNScreen extends StatefulWidget {
  const GRNScreen({Key? key}) : super(key: key);
  static const String routeName = '/grn';

  @override
  GRNScreenState createState() => GRNScreenState();
}

class GRNScreenState extends State<GRNScreen> {
  TextEditingController poNumberController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController poIdController = TextEditingController();
  TextEditingController supplierIdController = TextEditingController();
  TextEditingController currencyIdController = TextEditingController();
  TextEditingController currencyNameController = TextEditingController();

  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController grnDateController = TextEditingController();
  TextEditingController supinvController = TextEditingController();
  TextEditingController supinvDateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  TextEditingController invTypController = TextEditingController();

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  late double onHandQty = 0;
  late bool isEdit = false;
  late bool isSubmit = false;
  CommonRepository commonRepository = CommonRepository();
  GrnItemsRepository grnItemsRepository = GrnItemsRepository();
  static const String _boxName = 'grnItemBox';
  late Map<int, String> locations = {};
  late Map<int, String> glAccounts = {};
  late Map<int, String> faItems = {};

  List<String> invTypes = ['FA', 'Stock', 'Service'];

  late List<DropdownMenuEntry<String>> faItemsList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isSubmit = true;
    });

    initConnectivity();

    String dateFormat = 'dd/MM/yyyy';
    DateTime dateString = DateTime.now();
    poNumberController.text = '16825';
    grnDateController.text = DateFormat(dateFormat).format(dateString);
    grnItemsRepository.clearBox();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );

    _loadLocations();
    _loadGlAccounts();
    _loadFAItems();

    supplierController.text = 'Supplier Name Supplier Name Supplier Name';

    setState(() {
      isSubmit = false;
    });
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> _loadLocations() async {
    try {
      await commonRepository
          .getLocationList()
          .then((value) {
            setState(() {
              locations = value;
            });
          })
          .catchError((error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomAlert(
                  title: 'Sorry !',
                  message: 'Failed to Load Locations',
                  icon: Icons.fmd_bad_outlined,
                  iconColor: Colors.red,
                );
              },
            );
          });
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
            title: 'Sorry !',
            message: 'Failed to Load Locations',
            icon: Icons.fmd_bad_outlined,
            iconColor: Colors.red,
          );
        },
      );
    }
  }

  Future<void> _loadGlAccounts() async {
    try {
      await commonRepository
          .getGlAccountsList()
          .then((value) {
            setState(() {
              glAccounts = value;
            });
          })
          .catchError((error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomAlert(
                  title: 'Sorry !',
                  message: 'Failed to Load GL Accounts',
                  icon: Icons.fmd_bad_outlined,
                  iconColor: Colors.red,
                );
              },
            );
          });
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
            title: 'Sorry !',
            message: 'Failed to Load GL Accounts',
            icon: Icons.fmd_bad_outlined,
            iconColor: Colors.red,
          );
        },
      );
    }
  }

  Future<void> _loadFAItems() async {
    await FaItemsRepository()
        .getFAItems()
        .then((value) {
          setState(() {
            faItems = value;
          });

          faItemsList =
              value.entries.map((entry) {
                return DropdownMenuEntry<String>(
                  value: entry.key.toString(),
                  label: '${entry.key} - ${entry.value}',
                );
              }).toList();
        })
        .catchError((error) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomAlert(
                title: 'Sorry !',
                message: 'Failed to Load FA Items',
                icon: Icons.fmd_bad_outlined,
                iconColor: Colors.red,
              );
            },
          );
        });
  }

  Future<void> searchPoNumber(String poNumber) async {
    if (poNumber.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
            title: 'Sorry !',
            message: 'Please Enter PO Number',
            icon: Icons.fmd_bad_outlined,
            iconColor: Colors.red,
          );
        },
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );

    try {
      setState(() {
        isSubmit = true;
        supplierController.clear();
        poIdController.clear();
        supplierIdController.clear();
        currencyIdController.clear();
        currencyNameController.clear();
      });

      final value = await grnItemsRepository.searchPoNumber(poNumber);

      setState(() {
        supplierController.text = value['supplierName'];
        supplierIdController.text = value['supplierId'].toString();
        poIdController.text = value['poId'].toString();
        currencyIdController.text = value['currencyId'].toString();
        currencyNameController.text = value['currencyName'].toString();
      });
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
            title: 'Sorry !',
            message: 'Failed to Load PO Details or No Such PO',
            icon: Icons.fmd_bad_outlined,
            iconColor: Colors.red,
          );
        },
      );
    } finally {
      setState(() {
        isSubmit = false;
      });
      Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GRN With PO'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the drawer
              },
            );
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              UserRepository().logout();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/home',
                ); // Replace with your home route
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('MRI'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/material-issue-note',
                ); // Replace with your GRN list route
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isTablet = constraints.maxWidth > 520;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isTablet
                        ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: poNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'PO Number',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed:
                                  isSubmit == true
                                      ? null
                                      : () {
                                        searchPoNumber(poNumberController.text);
                                      },
                              icon: const Icon(Icons.search),
                              label: const Text("Search"),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: poNumberController,
                              decoration: const InputDecoration(
                                labelText: 'PO Number',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                searchPoNumber(poNumberController.text);
                              },
                              icon: const Icon(Icons.search),
                              label: const Text("Search"),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.grey[100],
                      child: ListTile(
                        leading: const Icon(
                          Icons.local_shipping,
                          color: Colors.blue,
                        ),
                        title: const Text(
                          'Supplier',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(supplierController.text),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ResponsiveFormFields(
                      field2: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                        value:
                            locationController.text.isNotEmpty
                                ? locationController.text
                                : null,
                        items:
                            locations.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key.toString(),
                                child: Text(entry.value),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            locationController.text = value ?? '';
                          });
                        },
                      ),
                      field1: GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.blue,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              grnDateController.text = DateFormat(
                                'dd/MM/yyyy',
                              ).format(picked.toLocal());
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: grnDateController,
                            decoration: const InputDecoration(
                              labelText: 'GRN Date',
                              hintText: 'Select Date',
                              suffixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ResponsiveFormFields(
                      field1: TextField(
                        controller: supinvController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier Invoice Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      field2: GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.blue,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              supinvDateController.text = DateFormat(
                                'dd/MM/yyyy',
                              ).format(picked.toLocal());
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: supinvDateController,
                            decoration: const InputDecoration(
                              labelText: 'Supplier Invoice Date',
                              hintText: 'Select Date',
                              suffixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ResponsiveFormFields(
                      field1: TextField(
                        controller: remarksController,
                        decoration: const InputDecoration(
                          labelText: 'Remarks',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ResponsiveFormFields(
                      field1: DropdownMenu(
                        initialSelection:
                            invTypes.contains(invTypController.text)
                                ? invTypes.indexOf(invTypController.text)
                                : null,
                        controller: invTypController,
                        requestFocusOnTap: true,
                        label: const Text('Select Inventory Type'),
                        onSelected: (Object? value) {
                          setState(() {
                            invTypController.text =
                                value != null ? value as String : '';
                          });
                        },
                        enableFilter: true,
                        width: constraints.maxWidth,
                        dropdownMenuEntries:
                            invTypes.map<DropdownMenuEntry<String>>((
                              String inv,
                            ) {
                              return DropdownMenuEntry(value: inv, label: inv);
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ResponsiveFormFields(
                      field1: TextField(
                        controller: currencyNameController,
                        enabled: false, // Disable the text field
                        decoration: const InputDecoration(
                          labelText: 'Currency',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ResponsiveFormFields(
                      field1: ElevatedButton(
                        onPressed:
                            isSubmit == true
                                ? null
                                : () {
                                  grnItemsRepository.clearBox();
                                  setState(() {
                                    poNumberController.clear();
                                    supplierController.clear();
                                    poIdController.clear();
                                    supplierIdController.clear();
                                    currencyIdController.clear();
                                    currencyNameController.clear();
                                    grnDateController.clear();
                                    supinvController.clear();
                                    supinvDateController.clear();
                                    remarksController.clear();
                                    invTypController.clear();
                                  });
                                },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      field2: ElevatedButton(
                        onPressed:
                            isSubmit == true
                                ? null
                                : () {
                                  searchPoNumber(poNumberController.text);
                                },
                        child: const Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<Box<GrnItemsDetails>>(
                      future: Hive.openBox<GrnItemsDetails>(_boxName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'Error loading items: ${snapshot.error}',
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: Text('No items found.')),
                          );
                        }

                        final box = snapshot.data!;
                        final items = box.values.toList();

                        if (items.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: Text('No Items available.')),
                          );
                        }

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final receivedQtyController = TextEditingController(
                              text: item.receivedQty.toStringAsFixed(2),
                            );
                            String? selectedGlAccount =
                                item.glAccountId != 0
                                    ? item.glAccountId.toString()
                                    : null;

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ResponsiveFormFields(
                                      field1: Text(
                                        'Item : ${item.itemId}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      field2: Text(item.itemDesc),
                                    ),
                                    const SizedBox(height: 8),
                                    ResponsiveFormFields(
                                      field1: Text(
                                        'Unit: ${item.unit}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      field2: Text(
                                        'Qty: ${item.qty.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ResponsiveFormFields(
                                      field1: TextField(
                                        controller: receivedQtyController,
                                        decoration: const InputDecoration(
                                          labelText: 'Received',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.]'),
                                          ),
                                        ],
                                        onTap: () {
                                          // Clear field if it's 0 or 0.0 for easier typing
                                          if (receivedQtyController.text ==
                                                  '0' ||
                                              receivedQtyController.text ==
                                                  '0.0' ||
                                              receivedQtyController.text ==
                                                  '0.00') {
                                            receivedQtyController.clear();
                                          }
                                        },
                                        onChanged: (value) {
                                          final parsed = double.tryParse(value);
                                          if (parsed != null) {
                                            item.receivedQty = parsed;
                                            box.putAt(index, item);
                                          }
                                        },
                                      ),

                                      field2:
                                          invTypController.text == 'FA' ||
                                                  invTypController.text ==
                                                      'Service'
                                              ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: DropdownButtonFormField<
                                                          String
                                                        >(
                                                          value:
                                                              selectedGlAccount,
                                                          isExpanded: true,
                                                          decoration:
                                                              const InputDecoration(
                                                                labelText:
                                                                    'GL Account',
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                          items:
                                                              glAccounts.entries
                                                                  .map(
                                                                    (
                                                                      entry,
                                                                    ) => DropdownMenuItem<
                                                                      String
                                                                    >(
                                                                      value:
                                                                          entry
                                                                              .key
                                                                              .toString(),
                                                                      child: Text(
                                                                        '${entry.key} - ${entry.value}',
                                                                      ),
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                          onChanged: (value) {
                                                            if (value != null) {
                                                              item.glAccountId =
                                                                  int.tryParse(
                                                                    value,
                                                                  ) ??
                                                                  0;
                                                              box.putAt(
                                                                index,
                                                                item,
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.clear,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            item.glAccountId =
                                                                0;
                                                            selectedGlAccount =
                                                                null;
                                                            box.putAt(
                                                              index,
                                                              item,
                                                            );
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                              : const Text(
                                                'GL Account: Not Required',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
