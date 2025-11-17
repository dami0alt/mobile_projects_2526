import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M0489 - Apps - Form (A)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final String title = 'Salesians Sarrià 25/26';
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const FormTitle(),
            FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //-------------------------------------------------
                    FormLabelGroup(
                      title: 'Please provide the speed of vehicle?',
                      subtitle: 'please select one option given below',
                    ),
                    FormBuilderRadioGroup(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      name: "speed",
                      orientation: OptionsOrientation.vertical,
                      // separator: const Padding(padding: EdgeInsets.all(20)),
                      options: const [
                        FormBuilderFieldOption(value: 'abvoe 40km/h'),
                        FormBuilderFieldOption(value: 'below 40km/h'),
                        FormBuilderFieldOption(value: '0km/h')
                      ],
                      onChanged: (String? value) {
                        debugPrint(value);
                      },
                    ),
                    //-------------------------------------------------
                    FormLabelGroup(title: 'Enter remarks'),
                    FormBuilderTextField(
                      name: 'remark',
                      decoration: InputDecoration(
                        hintText: 'Enter your remarks',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                      ),
                      onChanged: (String? value) {
                        debugPrint(value);
                      },
                    ),
                    //-------------------------------------------------
                    FormLabelGroup(
                      title: 'Please provide the high speed of vehicle?',
                      subtitle: 'please select one option given below',
                    ),
                    FormBuilderDropdown(
                      name: 'highspeed',
                      decoration: InputDecoration(
                        hintText: 'Select option',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'high', child: Text('High')),
                        DropdownMenuItem(
                            value: 'medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                      ],
                      onChanged: (String? value) {
                        debugPrint(value);
                      },
                    ),
                    //-------------------------------------------------
                    FormLabelGroup(
                      title: 'Please provide the speed of vehicle past 1 hour?',
                      subtitle: 'please select one or more options given below',
                    ),
                    FormBuilderCheckboxGroup(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      name: "selectSpeed",
                      orientation: OptionsOrientation.vertical,
                      // separator: const Padding(padding: EdgeInsets.all(20)),
                      options: const [
                        FormBuilderFieldOption(value: '20km/h'),
                        FormBuilderFieldOption(value: '30km/h'),
                        FormBuilderFieldOption(value: '40km/h'),
                        FormBuilderFieldOption(value: '50km/h'),
                      ],
                      onChanged: (List<String>? value) {
                        debugPrint(value.toString());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload),
          onPressed: () {
            _formKey.currentState?.saveAndValidate();
            String? formString = _formKey.currentState?.value.toString();
            alertDialog(context, formString!);
          }),
    );
  }
}

// ignore: must_be_immutable
class FormLabelGroup extends StatelessWidget {
  FormLabelGroup({super.key, required this.title, this.subtitle});

  String title;
  String? subtitle;

  Widget conditionalSubtitle(BuildContext context) {
    if (subtitle != null) {
      return Text(subtitle!,
          style: Theme.of(context).textTheme.labelLarge?.apply(
              fontSizeFactor: 1.25,
              // ignore: deprecated_member_use
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.apply(fontSizeFactor: 1.25)),
          conditionalSubtitle(context)
        ],
      ),
    );
  }
}

class FormTitle extends StatelessWidget {
  const FormTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Form title',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text('description', style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

void alertDialog(BuildContext context, String contentText) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Submission Completed"),
      icon: const Icon(Icons.check_circle),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Tancar'),
          child: const Text('Tancar'),
        ),
      ],
    ),
  );
}
