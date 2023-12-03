import 'package:flutter/material.dart';
import 'package:flutter_upload/sql_helper.dart';

class Halaman1 extends StatefulWidget {
  const Halaman1({Key? key}) : super(key: key);

  @override
  _Halaman1State createState() => _Halaman1State();
}

class _Halaman1State extends State<Halaman1> {
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  List<Map<String, dynamic>> catatan = [];
  Map<String, dynamic>? catatanDihapus;

  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  Future<void> refreshNote() async {
    final data = await SQLHelper.getNote();
    setState(() {
      catatan = data;
    });
  }

  Future<void> tambahNote(String judul, String deskripsi) async {
    await SQLHelper.tambahNote(judul, deskripsi);
    refreshNote();
  }

  Future<void> hapusNote(int id) async {
    catatanDihapus = catatan.firstWhere((item) => item['id'] == id);
    await SQLHelper.hapusNote(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Berhasil Dihapus",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Warna teks
          ),
        ),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            if (catatanDihapus != null) {
              tambahNote(
                catatanDihapus!['judul'],
                catatanDihapus!['deskripsi'],
              );
              catatanDihapus = null;
            }
          },
          textColor: Colors.yellow,
        ),
      ),
    );

    refreshNote();
  }

  Future<void> ubahNote(int id, String judul, String deskripsi) async {
    await SQLHelper.ubahNote(id, judul, deskripsi);
    refreshNote();
  }

  void modalForm(int? id) async {
    if (id != null) {
      final dataCatatan = catatan.firstWhere((item) => item['id'] == id);

      judulController.text = dataCatatan['judul'];
      deskripsiController.text = dataCatatan['deskripsi'];
    }
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        height: 800,
        color: Colors.yellow[50],
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: const InputDecoration(hintText: "Masukkan Judul"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: deskripsiController,
                decoration:
                    const InputDecoration(hintText: "Masukkan Deskripsi"),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (judulController.text.isEmpty ||
                      deskripsiController.text.isEmpty) {
                    // Tampilkan alert bahwa form masih kosong
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white, // Background color putih
                        title: Text(
                          "Form Kosong",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        content: Text(
                            "Pastikan semua form diisi sebelum menambahkan catatan."),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.yellow,
                            ),
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (id == null) {
                      await tambahNote(
                          judulController.text, deskripsiController.text);
                      print("Tambah");
                    } else {
                      print("Update");
                      await ubahNote(
                          id, judulController.text, deskripsiController.text);
                    }
                    judulController.text = '';
                    deskripsiController.text = '';
                    Navigator.pop(context);
                    refreshNote();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                ),
                child: Text(
                  id == null ? 'Tambah Catatan' : 'Ubah Catatan',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "List Catatan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: catatan.length,
        itemBuilder: (context, index) => Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Color.fromARGB(255, 223, 223, 223), width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            catatan[index]['judul'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(catatan[index]['deskripsi']),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              onPressed: () => modalForm(catatan[index]['id']),
                              icon: Icon(
                                Icons.edit,
                                color: Colors.yellow[50],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            child: IconButton(
                              onPressed: () {
                                hapusNote(catatan[index]['id']);
                              },
                              icon:
                                  Icon(Icons.delete, color: Colors.yellow[50]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        tooltip: 'Tambah Catatan',
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
    );
  }
}
