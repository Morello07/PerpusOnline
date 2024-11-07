import 'package:flutter/material.dart';
import 'package:perpus_flutter/controllers/PerpusControl.dart';
import 'package:perpus_flutter/models/perpusdata.dart';
import 'package:perpus_flutter/widgets/modals.dart';
import 'package:perpus_flutter/widgets/bottomnavigation.dart';

class PerpusPage extends StatefulWidget {
  const PerpusPage({super.key});

  @override
  State<PerpusPage> createState() => _PerpusViewState();
}

class _PerpusViewState extends State<PerpusPage> {
  final PerpusController perpusController = PerpusController();
  final TextEditingController judulInput = TextEditingController();
  final TextEditingController deskripsiInput = TextEditingController();
  final TextEditingController stokInput = TextEditingController();
  final TextEditingController pengarangInput = TextEditingController();
  final TextEditingController penerbitInput = TextEditingController();
  final TextEditingController coverInput = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ModalWidget modal = ModalWidget();

  List<String> listAct = ["Ubah", "Hapus"];
  List<Perpus>? buku;
  int? bukuId;

  void getBuku() {
    setState(() {
      buku = perpusController.perpus;
    });
  }

  void addBuku(Perpus data) {
    buku!.add(data);
    getBuku();
  }

  @override
  void initState() {
    super.initState();
    getBuku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.library_books,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text(
              'Perpustakaan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                bukuId = null;
              });
              judulInput.clear();
              deskripsiInput.clear();
              stokInput.clear();
              pengarangInput.clear();
              penerbitInput.clear();
              coverInput.clear();
              modal.showFullModal(context, fromTambah(null));
            },
            icon: const Icon(Icons.add_sharp),
          ),
        ],
      ),
      body: buku != null && buku!.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: buku!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              buku![index].cover,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.blue,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                buku![index].judul,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Pengarang: ${buku![index].pengarang}",
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Stok: ${buku![index].stok}",
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 30.0),
                          itemBuilder: (BuildContext context) {
                            return listAct.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                                onTap: () {
                                  if (choice == "Ubah") {
                                    setState(() {
                                      bukuId = buku![index].id;
                                    });
                                    judulInput.text = buku![index].judul;
                                    deskripsiInput.text = buku![index].deskripsi;
                                    stokInput.text = buku![index].stok.toString();
                                    pengarangInput.text = buku![index].pengarang;
                                    penerbitInput.text = buku![index].penerbit;
                                    coverInput.text = buku![index].cover;
                                    modal.showFullModal(context, fromTambah(index));
                                  } else if (choice == "Hapus") {
                                    setState(() {
                                      buku!.removeWhere((item) => item.id == buku![index].id);
                                    });
                                    getBuku();
                                  }
                                },
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "Data Kosong",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[600]),
              ),
            ),
      bottomNavigationBar: Bottomnavigation(1),
    );
  }

  Widget fromTambah(int? index) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              index == null ? "Tambah Data Buku" : "Ubah Data Buku",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            const SizedBox(height: 16.0),
            buildTextField("Judul", judulInput),
            buildTextField("Deskripsi", deskripsiInput),
            buildTextField("Stok", stokInput, isNumber: true),
            buildTextField("Pengarang", pengarangInput),
            buildTextField("Penerbit", penerbitInput),
            buildTextField("Cover", coverInput),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (index != null) {
                    // Update existing book
                    buku![index].judul = judulInput.text;
                    buku![index].deskripsi = deskripsiInput.text;
                    buku![index].stok = int.parse(stokInput.text);
                    buku![index].pengarang = pengarangInput.text;
                    buku![index].penerbit = penerbitInput.text;
                    buku![index].cover = coverInput.text;
                  } else {
                    bukuId = (buku?.length ?? 0) + 1;
                    Perpus data = Perpus(
                      id: bukuId!,
                      judul: judulInput.text,
                      deskripsi: deskripsiInput.text,
                      stok: int.parse(stokInput.text),
                      pengarang: pengarangInput.text,
                      penerbit: penerbitInput.text,
                      cover: coverInput.text,
                    );
                    addBuku(data);
                  }
                  Navigator.pop(context);
                  clearInputs();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(index == null ? "Simpan" : "Update", style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
    );
  }

  void clearInputs() {
    judulInput.clear();
    deskripsiInput.clear();
    stokInput.clear();
    pengarangInput.clear();
    penerbitInput.clear();
    coverInput.clear();
  }
}
