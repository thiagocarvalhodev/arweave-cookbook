import 'dart:convert';

import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:arweave/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// http
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

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
  final TextEditingController _textController = TextEditingController();
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
      body: Stack(
        children: [
          Center(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text('Check the code on the permaweb:',
                            style: ArDriveTypography.body.bodyRegular()),
                        GestureDetector(
                          onTap: () {
                            launchUrl(Uri.parse(
                                'https://app.ardrive.io/#/drives/16b6edd0-10f2-478e-a4a8-03ac97f1b50b?name=permaweb'));
                          },
                          child: Text(
                            'https://app.ardrive.io/#/drives/16b6edd0-10f2-478e-a4a8-03ac97f1b50b?name=permaweb',
                            style: ArDriveTypography.body
                                .bodyBold()
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                    'Check how to deploy on arweave using ardrive by playing the video here or on the permaweb:',
                                    style:
                                        ArDriveTypography.body.bodyRegular()),
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        'https://arweave.net/H3Ndx8BrsI87R_pdrg7zmySMW-FnqfiOE73IsGXz68E'));
                                  },
                                  child: Text(
                                    'arweave.net/H3Ndx8BrsI87R_pdrg7zmySMW-FnqfiOE73IsGXz68E',
                                    style: ArDriveTypography.body
                                        .bodyBold()
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                                showAnimatedDialog(
                                  context,
                                  content: ArDriveStandardModal(
                                    hasCloseButton: true,
                                    width: 800,
                                    content: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: ArDriveIcons.x(),
                                            ),
                                          ),
                                        ),
                                        const VideoApp()
                                      ],
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    _controller.pause();
                                  });
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ArDriveTheme.of(context)
                                      .themeData
                                      .colors
                                      .themeBgCanvas,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
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
                          controller: _textController,
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
                            _getTransaction(_textController.text);
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
                                        style: ArDriveTypography.body
                                            .smallRegular(),
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
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                launchUrl(
                  Uri.parse(
                      'https://github.com/thiagocarvalhodev/arweave-cookbook'),
                );
              },
              child: SvgPicture.asset(
                'assets/github.svg',
                color: Colors.white,
                height: 52,
                width: 52,
              ),
            ),
          ),
        ],
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

final _controller = VideoPlayerController.networkUrl(
  Uri.parse('https://arweave.net/H3Ndx8BrsI87R_pdrg7zmySMW-FnqfiOE73IsGXz68E'),
);

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  @override
  void initState() {
    super.initState();
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
