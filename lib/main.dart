import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ypsvfotewoagxwqfddxo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlwc3Zmb3Rld29hZ3h3cWZkZHhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjEyMTUwMjEsImV4cCI6MjAzNjc5MTAyMX0.iKC6ZYsbYNET51hXFwfdt7r6LJKPQauhmWt4zvPPvd4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Countries',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client.from('user').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPage()),
              );

              if (result == null) return;

              await Supabase.instance.client.from('user').insert({'name': result['name'], 'nim': result['nim'], 'food': result['food']});
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  child: ListTile(
                    title: Text(item['name']),
                    leading: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              name: item['name'],
                              nim: item['nim'],
                              food: item['food'],
                            ),
                          ),
                        );
                        await Supabase.instance.client.from('user').update({'name': result['name'], 'nim': result['nim'], 'food': result['food']}).eq('id', item['id']);
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final data = snapshot.data as List<Map<String, dynamic>>;
                        final user = data[index];
                        await Supabase.instance.client.from('user').delete().eq('id', user['id']);
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NIM: ${item['nim']}'),
                        Text('Favorite Food: ${item['food']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _nimController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'NIM',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _foodController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Makanan Favorit',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  {
                    'name': _nameController.text,
                    'nim': _nimController.text,
                    'food': _foodController.text,
                  },
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditPage extends StatefulWidget {
  final String name;
  final String nim;
  final String food;

  const EditPage({
    super.key,
    required this.name,
    required this.nim,
    required this.food,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _nimController.text = widget.nim;
    _foodController.text = widget.food;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _nimController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'NIM',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _foodController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Makanan Favorit',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  {
                    'name': _nameController.text,
                    'nim': _nimController.text,
                    'food': _foodController.text,
                  },
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
