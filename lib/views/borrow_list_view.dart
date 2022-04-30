import 'package:flutter/material.dart';
import 'package:flutter_mvvm/models/borrow_info_model.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../services/calculator.dart';
import 'borrow_list_view_model.dart';

const String _womenImageUrl =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmLi_BSePjHLv0mWV4jUzOwNwO8Ce_G79Yal19X-9pRK5_H4kQpSxCe6hjBfP2_Ku6bKM&usqp=CAU';
const String _menImageUrl =
    'https://media.istockphoto.com/photos/headshot-portrait-of-smiling-male-employee-in-office-picture-id1309328823?b=1&k=20&m=1309328823&s=170667a&w=0&h=a-f8vR5TDFnkMY5poQXfQhDSnK1iImIfgVTVpFZi_KU=';

class BarrowListView extends StatefulWidget {
  final Book book;
  const BarrowListView({Key? key, required this.book}) : super(key: key);

  @override
  State<BarrowListView> createState() => _BarrowListViewState();
}

class _BarrowListViewState extends State<BarrowListView> {
  @override
  Widget build(BuildContext context) {
    List<BorrowInfo>? borrowList = widget.book.borrows ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Borrow List')),
      body: ChangeNotifierProvider<BorrowListViewModel>(
        create: (context) => BorrowListViewModel(),
        builder: (context, child) => Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: borrowList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(_womenImageUrl),
                    ),
                    title: Text(
                        '${borrowList[index].name} ${borrowList[index].surname}'),
                  );
                },
                separatorBuilder: (context, _) => const Divider(),
              ),
            ),
            InkWell(
              onTap: () async {
                BorrowInfo? newBorrowInfo =
                    await showModalBottomSheet<BorrowInfo>(
                        context: context,
                        builder: (context) {
                          return const BorrowForm();
                        });
                if (newBorrowInfo != null) {
                  setState(() {
                    borrowList.add(newBorrowInfo);
                  });

                  context.read<BorrowListViewModel>().updateBook(
                        book: widget.book,
                        borrowList: borrowList,
                      );
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 65,
                color: Colors.blueAccent,
                child: const Text(
                  'Add Borrow',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BorrowForm extends StatefulWidget {
  const BorrowForm({Key? key}) : super(key: key);

  @override
  State<BorrowForm> createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  TextEditingController nameCntr = TextEditingController();
  TextEditingController surNameCntr = TextEditingController();
  TextEditingController borrowDateCntr = TextEditingController();
  TextEditingController returnDateCntr = TextEditingController();

  DateTime? _selectedBorrowDate;
  DateTime? _selectedReturnDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameCntr.dispose();
    surNameCntr.dispose();
    borrowDateCntr.dispose();
    returnDateCntr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(_menImageUrl),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -10,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.photo_camera_rounded),
                          color: Colors.grey.shade100,
                          iconSize: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameCntr,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Bu alan boş bırakılamaz';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: surNameCntr,
                        decoration: const InputDecoration(
                          hintText: 'Surname',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Bu alan boş bırakılamaz';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: borrowDateCntr,
                    onTap: () async {
                      _selectedBorrowDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)));
                      if (_selectedBorrowDate != null) {
                        borrowDateCntr.text =
                            Calculator.dateTimeToString(_selectedBorrowDate!);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Borrow Date',
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Bu alan boş bırakılamaz';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: TextFormField(
                    controller: returnDateCntr,
                    onTap: () async {
                      _selectedReturnDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)));
                      if (_selectedReturnDate != null) {
                        returnDateCntr.text =
                            Calculator.dateTimeToString(_selectedReturnDate!);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Return Date',
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Bu alan boş bırakılamaz';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  BorrowInfo newBorrowInfo = BorrowInfo(
                    name: nameCntr.text,
                    surname: surNameCntr.text,
                    photoUrl: '',
                    borrowDate:
                        Calculator.dateTimeToTimestamp(_selectedBorrowDate!),
                    returnDate:
                        Calculator.dateTimeToTimestamp(_selectedBorrowDate!),
                  );

                  Navigator.pop(context, newBorrowInfo);
                }
              },
              child: const Text('Add Borrow'),
            )
          ],
        ),
      ),
    );
  }
}
