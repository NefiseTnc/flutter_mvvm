import 'package:flutter/material.dart';
import 'package:flutter_mvvm/services/calculator.dart';
import 'package:flutter_mvvm/views/add_book_view_model.dart';
import 'package:provider/provider.dart';

class AddBookView extends StatefulWidget {
  const AddBookView({Key? key}) : super(key: key);

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  late TextEditingController bookCntr;
  late TextEditingController authorCntr;
  late TextEditingController publishCntr;
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    bookCntr = TextEditingController();
    authorCntr = TextEditingController();
    publishCntr = TextEditingController();
  }

  @override
  void dispose() {
    bookCntr.dispose();
    authorCntr.dispose();
    publishCntr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookViewModel>(
      create: (BuildContext context) => AddBookViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(title: const Text('Add Book')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: bookCntr,
                    decoration: const InputDecoration(
                      hintText: 'Book Name',
                      icon: Icon(Icons.book),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bu alan boş geçilemez.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: authorCntr,
                    decoration: const InputDecoration(
                      hintText: 'Author Name',
                      icon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bu alan boş geçilemez.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    onTap: () async {
                      _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(-1000),
                          lastDate: DateTime.now());
                      if (_selectedDate != null) {
                        publishCntr.text =
                            Calculator.dateTimeToString(_selectedDate!);
                      }
                    },
                    controller: publishCntr,
                    decoration: const InputDecoration(
                      hintText: 'Publish Date',
                      icon: Icon(Icons.date_range),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen tarih seçiniz.';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        //todo kullanıcı bilgileri ile addNewBook metodu çağırılacak.
                        //todo navigator.pop

                        await context.read<AddBookViewModel>().addNewBook(
                            bookName: bookCntr.text,
                            authorName: authorCntr.text,
                            publishDate: _selectedDate!);

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
