import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_upload/sql_helper.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const Halaman2());

class Halaman2 extends StatefulWidget {
  const Halaman2({Key? key}) : super(key: key);

  @override
  _Halaman2State createState() => _Halaman2State();
}

class _Halaman2State extends State<Halaman2> {
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController gambarController = TextEditingController();

  List<Map<String, dynamic>> catatan = [];
  Map<String, dynamic>? catatanDihapus;

  void refreshCatatan() async {
    final data = await SQLHelper.getCatatan();
    setState(() {
      catatan = data;
    });
  }

  @override
  void initState() {
    refreshCatatan();
    super.initState();
  }

  Future<void> _ambilGambar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        gambarController.text = pickedFile.path;
      });
    }
  }

  Future<void> tambahCatatan(
      String judul, String deskripsi, String gambar) async {
    await SQLHelper.tambahCatatan(judul, deskripsi, gambar);
    refreshCatatan();
  }

  Future<void> hapusCatatan(int id) async {
    catatanDihapus = catatan.firstWhere((item) => item['id'] == id);
    await SQLHelper.hapusCatatan(id);

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
              tambahCatatan(
                catatanDihapus!['judul'],
                catatanDihapus!['deskripsi'],
                catatanDihapus!['gambar'],
              );
              catatanDihapus = null;
            }
          },
          textColor: Colors.yellow,
        ),
      ),
    );

    refreshCatatan();
  }

  Future<void> ubahCatatan(
      int id, String judul, String deskripsi, String gambar) async {
    await SQLHelper.ubahCatatan(id, judul, deskripsi, gambar);
    refreshCatatan();
  }

  void modalForm(int? id) async {
    if (id != null) {
      final dataCatatan = catatan.firstWhere((item) => item['id'] == id);

      judulController.text = dataCatatan['judul'];
      deskripsiController.text = dataCatatan['deskripsi'];
      gambarController.text = dataCatatan['gambar'];
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
              TextField(
                controller: gambarController,
                decoration: const InputDecoration(hintText: "Path Gambar"),
              ),
              ElevatedButton(
                onPressed: _ambilGambar,
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      "Pilih Gambar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (judulController.text.isEmpty ||
                      deskripsiController.text.isEmpty ||
                      gambarController.text.isEmpty) {
                    // Tampilkan alert bahwa form masih kosong
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor:
                            Colors.yellow[50], // Background color putih
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
                      await tambahCatatan(
                        judulController.text,
                        deskripsiController.text,
                        gambarController.text,
                      );
                      print("Tambah");
                    } else {
                      print("Update");
                      await ubahCatatan(
                        id,
                        judulController.text,
                        deskripsiController.text,
                        gambarController.text,
                      );
                    }
                    judulController.text = '';
                    deskripsiController.text = '';
                    gambarController.text = '';
                    Navigator.pop(context);
                    refreshCatatan();
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
            "List Foto",
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
            contentPadding: EdgeInsets.all(10.0),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: FileImage(File(catatan[index]['gambar'])),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catatan[index]['judul'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(catatan[index]['deskripsi']),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Row(
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
                      backgroundColor: Color.fromARGB(255, 255, 59, 59),
                      child: IconButton(
                        onPressed: () {
                          hapusCatatan(catatan[index]['id']);
                        },
                        icon: Icon(Icons.delete, color: Colors.yellow[50]),
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
