  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'model/model_kosakata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
    @override
    Widget build(BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MyHomePage(title: 'Kamus Spanyol'),
            ),
          );
        });
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book_rounded,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'Kamus Spanyol',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

  class _MyHomePageState extends State<MyHomePage> {
    TextEditingController txtCari = TextEditingController();
    bool isCari = true;
    List<Datum> filter = [];
    var logger = Logger();

    @override
    void initState() {
      super.initState();
      _PageSearchListDataState();
    }

    Future<List<Datum>?> getKosakata() async {
      try {
        http.Response res = await http.get(Uri.parse(
            'https://destination.superaset.com/apiKosakata/read.php'));

        return modelKosakataFromJson(res.body).data;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()))
        );
        return null; // Return null jika terjadi kesalahan
      }
    }

    _PageSearchListDataState() {
      txtCari.addListener(() {
        setState(() {
          isCari = txtCari.text.isEmpty;
        });
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: getKosakata(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Datum>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextFormField(
                      controller: txtCari,
                      decoration: InputDecoration(
                          hintText: "Cari Kosakata",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none
                          ),
                          filled: true,
                          fillColor: Colors.green.withOpacity(0.1)
                      ),
                    ),
                    isCari ?
                    Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              Datum? data = snapshot.data?[index];
                              return ListTile(
                                title: Text(data!.kosakata.toString()),
                              );
                            }
                        )
                    ) : CreateFilterList(snapshot.data),
                    // Anda perlu menambahkan implementasi CreateFilterList()
                  ],
                ),
              );
            }
          },
        ),
      );
    }


    Widget CreateFilterList(List<Datum>? data) {
      filter = [];
      if (data != null) {
        for (int i = 0; i < data.length; i++) {
          var item = data[i];
          if (item.kosakata.toLowerCase().contains(txtCari.text.toLowerCase())) {
            filter.add(item);
          }
        }
      }
      return HasilSearch();
    }

    Widget HasilSearch() {
      return Expanded(
        child: ListView.builder(
          itemCount: filter.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(filter[index].kosakata),
            );
          },
        ),
      );
    }
  }


