import 'dart:convert';

import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:arweave/utils.dart';
import 'package:flutter/material.dart';
// http
import 'package:http/http.dart' as http;

void main() async {
  runApp(const ArweavePermawebCookbookApp());
}

class ArweavePermawebCookbookApp extends StatelessWidget {
  const ArweavePermawebCookbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ArDriveApp(
      builder: (BuildContext context) {
        return MaterialApp(
          theme: ArDriveTheme.of(context).themeData.materialThemeData,
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _hasError = false;

  TransactionJson? _tx;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getTransaction(String transactionId) async {
    try {
      _tx = await TransactionFetcher().getTransaction(transactionId);

      setState(() {
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Text(
                  'Arweave Permaweb Cookbook',
                  style: ArDriveTypography.headline.headline2Regular(),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SizedBox(
                    width: 450,
                    child: ArDriveTextField(
                      hintText: 'Insert a transaction ID',
                      validator: (s) {
                        final regExp = RegExp(
                          r'^[a-zA-Z0-9-_s+]{43}$',
                          caseSensitive: false,
                          multiLine: false,
                        );

                        if (s == null || !regExp.hasMatch(s)) {
                          return 'Invalid transaction ID';
                        }

                        return null;
                      },
                      controller: _controller,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: ArDriveButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _getTransaction(_controller.text);
                      }
                    },
                    text: 'Confirm',
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              if (_hasError)
                Text(
                  'Error',
                  style: ArDriveTypography.headline.headline5Regular(),
                ),
              if (_tx != null) ...[
                Text(
                  'Transaction',
                  style: ArDriveTypography.headline.headline3Regular(),
                ),
                const SizedBox(
                  height: 24,
                ),
                ListTile(
                  title: Text(
                    'format',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.format.toString()),
                ),
                ListTile(
                  title: Text(
                    'id',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.id),
                ),
                ListTile(
                  title: Text(
                    'last_tx',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.lastTx),
                ),
                ListTile(
                  title: Text(
                    'owner',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.owner),
                ),
                ArDriveAccordion(
                  backgroundColor: Colors.transparent,
                  children: [
                    ArDriveAccordionItem(
                      Text(
                        'tags',
                        style: ArDriveTypography.body.bodyRegular(),
                      ),
                      _tx!.tags
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                  title: Text(
                                    e.name,
                                    style:
                                        ArDriveTypography.body.smallRegular(),
                                  ),
                                  subtitle: Text(e.value!),
                                ),
                              ))
                          .toList(),
                      isExpanded: true,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                ListTile(
                  title: Text(
                    'target',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.target),
                ),
                ListTile(
                  title: Text(
                    'quantity',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.quantity.toString()),
                ),
                ListTile(
                  title: Text(
                    'data',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.data.toString()),
                ),
                ListTile(
                  title: Text(
                    'data_size',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.dataSize.toString()),
                ),
                ListTile(
                  title: Text(
                    'data_root',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.dataRoot.toString()),
                ),
                ListTile(
                  title: Text(
                    'reward',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.reward.toString()),
                ),
                ListTile(
                  title: Text(
                    'signature',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_tx!.signature.toString()),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionJson {
  int format;
  String id;
  String lastTx;
  String owner;
  List<Tag> tags;
  String target;
  dynamic quantity;
  dynamic data;
  dynamic dataSize;
  dynamic dataRoot;
  dynamic reward;
  dynamic signature;

  TransactionJson({
    required this.format,
    required this.id,
    required this.lastTx,
    required this.owner,
    required this.tags,
    required this.target,
    required this.quantity,
    required this.data,
    required this.dataSize,
    required this.dataRoot,
    required this.reward,
    required this.signature,
  });

  factory TransactionJson.fromJson(Map<String, dynamic> json) {
    return TransactionJson(
      format: json["format"],
      id: json["id"],
      lastTx: json["last_tx"],
      owner: json["owner"],
      tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
      target: json["target"],
      quantity: json["quantity"],
      data: json["data"],
      dataSize: json["data_size"],
      dataRoot: (json["data_root"]),
      reward: json["reward"],
      signature: (json["signature"]),
    );
  }
}

class Tag {
  String name;
  dynamic value;

  Tag({
    required this.name,
    required this.value,
  });

  factory Tag.fromJson(Map<String, dynamic> json) =>
      TagDecoder().decodeTag(json);

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}

/// Fetches the transaction from the Arweave network and parses
/// the JSON response into a Dart object
class TransactionFetcher {
  Future<TransactionJson> getTransaction(String transactionId) async {
    final response = await http.get(
      Uri.parse('https://arweave.net/tx/$transactionId'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return TransactionJson.fromJson(json);
    }

    throw Exception('Failed to load transaction');
  }
}

/// Uses the method `decodeBase64ToString` from the `arweave` package to decode
///
class TagDecoder {
  Tag decodeTag(Map<String, dynamic> tag) {
    return Tag(
      name: decodeBase64ToString(tag["name"]),
      value: decodeBase64ToString(tag["value"]),
    );
  }
}
