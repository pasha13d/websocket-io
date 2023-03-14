import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        channel: IOWebSocketChannel.connect(
          Uri.parse('wss://echo.websocket.events'),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({required this.channel});

  final WebSocketChannel channel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController sendMessageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    /// dispose text controller
    sendMessageController.dispose();
    /// dispose socket channel
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WebSocket.io',
          style: TextStyle(
            fontSize: 16.0,
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Send message",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  )
                ),
                controller: sendMessageController,
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMyMessage,
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMyMessage() {
    if(sendMessageController.text.isNotEmpty) {
      widget.channel.sink.add(
        sendMessageController.text
      );
    }
  }
}

