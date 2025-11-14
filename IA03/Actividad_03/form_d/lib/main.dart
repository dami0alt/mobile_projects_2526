import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M0489 - Apps - Form (D)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Salesians Sarrià 25/26 - Damian Altamirano';
  final _formKey = GlobalKey<FormBuilderState>();
  final List<String> _chipOptions = [
    'HTML',
    'CSS',
    'React',
    'Dart',
    'TypeScript',
    'Angular',
  ];
  // 1. Estado para manejar la carga y la lista de nombres
  List<String> countries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData(); // Inicia la carga de datos
  }

  Future<void> _loadData() async {
    // Lee el archivo JSON
    final String jsonString = await rootBundle.loadString(
      'assets/countries.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);

    // Mapea para extraer SÓLO la propiedad "country" (el nombre)
    final List<String> loadedNames = jsonList
        .map((json) => json['country'] as String)
        .toList();

    setState(() {
      countries = loadedNames;
      isLoading = false;
    });
  }

  // 3. Función de sugerencias para el TypeAhead
  Future<List<String>> _getCountrySuggestions(String pattern) async {
    if (pattern.isEmpty) return countries.take(10).toList();

    // Filtra la lista cargada (countries)
    return countries
        .where((name) => name.toLowerCase().startsWith(pattern.toLowerCase()))
        .toList();
  }

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
                    FormLabelGroup(title: 'Autocompleter'),
                    FormBuilderTypeAhead<String>(
                      name: 'country_name',
                      decoration: const InputDecoration(
                        labelText: 'autocomplete',
                        border: OutlineInputBorder(),
                      ),

                      // 3. Usamos la función de sugerencias de Strings
                      suggestionsCallback: _getCountrySuggestions,

                      // 4. itemBuiler para Strings (mucho más simple)
                      itemBuilder: (context, String suggestion) {
                        return ListTile(title: Text(suggestion));
                      },
                    ),
                    //-------------------------------------------------
                    FormLabelGroup(title: 'Date Picker'),
                    FormBuilderDateTimePicker(
                      name: 'Date',
                      inputType: InputType.date,
                      decoration: const InputDecoration(
                        labelText: 'Date Picker',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    //--------------------------------------------
                    FormLabelGroup(title: 'Date Picker'),
                    FormBuilderDateRangePicker(
                      name: 'Date Picker',
                      decoration: const InputDecoration(
                        labelText: 'Rango de fechas',
                        hintText: 'Selecciona un rango',
                        border: OutlineInputBorder(),
                      ),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialValue: DateTimeRange(
                        start: DateTime.now(),
                        end: DateTime.now().add(const Duration(days: 7)),
                      ),
                    ),
                    //-------------------------------------------------
                    FormLabelGroup(title: 'Time Picker'),
                    FormBuilderDateTimePicker(
                      name: 'Time',
                      inputType: InputType.time,
                      decoration: const InputDecoration(
                        labelText: 'Choose a Time',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    FormLabelGroup(title: "Filter Chip"),
                    FormBuilderFilterChips(
                      name: 'skills', // El nombre clave para el formulario
                      // Las opciones que definiste arriba
                      options: _chipOptions
                          .map(
                            (chip) => FormBuilderChipOption(
                              value: chip,
                              child: Text(chip),
                            ),
                          )
                          .toList(),

                      // Opcional: Wrap para que los chips fluyan a la siguiente línea
                      spacing: 8.0,
                      runSpacing: 8.0,
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
        },
      ),
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
      return Text(
        subtitle!,
        style: Theme.of(context).textTheme.labelLarge?.apply(
          fontSizeFactor: 1.25,
          // ignore: deprecated_member_use
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
      );
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
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.apply(fontSizeFactor: 1.25),
          ),
          conditionalSubtitle(context),
        ],
      ),
    );
  }
}

class FormTitle extends StatelessWidget {
  const FormTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Form D',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text('--------', style: Theme.of(context).textTheme.labelLarge),
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
