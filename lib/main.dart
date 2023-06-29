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

  String? _jsonResponse;

  bool _hasError = false;

  JsonMappingObject? _jsonTx;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getTransaction(String transactionId) async {
    final response = await http.get(
      Uri.parse('https://arweave.net/tx/$transactionId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _jsonResponse = response.body;
        final json = jsonDecode(_jsonResponse!);

        _jsonTx = JsonMappingObject.fromJson(json);

        _hasError = false;
      });
    } else {
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
              if (_jsonResponse != null) ...[
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
                  subtitle: Text(_jsonTx!.format.toString()),
                ),
                ListTile(
                  title: Text(
                    'id',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.id),
                ),
                ListTile(
                  title: Text(
                    'last_tx',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.lastTx),
                ),
                ListTile(
                  title: Text(
                    'owner',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.owner),
                ),
                ArDriveAccordion(
                  backgroundColor: Colors.transparent,
                  children: [
                    ArDriveAccordionItem(
                      Text(
                        'tags',
                        style: ArDriveTypography.body.bodyRegular(),
                      ),
                      _jsonTx!.tags
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
                  subtitle: Text(_jsonTx!.target),
                ),
                ListTile(
                  title: Text(
                    'quantity',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.quantity.toString()),
                ),
                ListTile(
                  title: Text(
                    'data',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.data.toString()),
                ),
                ListTile(
                  title: Text(
                    'data_size',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.dataSize.toString()),
                ),
                ListTile(
                  title: Text(
                    'data_root',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.dataRoot.toString()),
                ),
                ListTile(
                  title: Text(
                    'reward',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.reward.toString()),
                ),
                ListTile(
                  title: Text(
                    'signature',
                    style: ArDriveTypography.body.bodyRegular(),
                  ),
                  subtitle: Text(_jsonTx!.signature.toString()),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class JsonMappingObject {
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

  JsonMappingObject({
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

  factory JsonMappingObject.fromJson(Map<String, dynamic> json) {
    return JsonMappingObject(
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

  Map<String, dynamic> toJson() => {
        "format": format,
        "id": id,
        "last_tx": lastTx,
        "owner": owner,
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "target": target,
        "quantity": quantity,
        // "data": data,
        // "data_size": dataSize,
        // "data_root": dataRoot,
        // "reward": reward,
        // "signature": signature,
      };
}

class Tag {
  String name;
  dynamic value;

  Tag({
    required this.name,
    required this.value,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        name: decodeBase64ToString(json["name"]),
        value: decodeBase64ToString(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
