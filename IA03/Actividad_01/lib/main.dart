import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retrive a value from a text field',
      home: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});
  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Retrive the value from a text field'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: myController,
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return SimpleDialog(
                      title: const Text("Simple Dialog"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsGeometry.symmetric(horizontal: 24.0),
                          child: Text(myController.text),
                        ),
                      ]);
                },
              );
            },
            tooltip: 'Show Simple Dialog',
            child: const Icon(Icons.text_fields),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Alert Dialog"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: Text(myController.text),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        )
                      ],
                    );
                  });
            },
            tooltip: 'Show Alert Dialog',
            child: const Icon(Icons.text_fields),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(myController.text),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Show Snack Bar',
            child: const Icon(Icons.text_fields),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),)
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(myController.text),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Tancar BottomSheet'),
                          ),
                        ]
                        ),
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(myController.text),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              )
                            ],
                          ),
                        ));
                  });
            },
            tooltip: 'Show the value!',
            child: const Icon(Icons.text_fields),
          ),
        ],
      ),
    );
  }
}
