import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm/views/add_book_view.dart';
import 'package:flutter_mvvm/views/book_view_model.dart';
import 'package:flutter_mvvm/views/borrow_list_view.dart';
import 'package:flutter_mvvm/views/update_book_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/book_model.dart';

class BookView extends StatelessWidget {
  const BookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookViewModel>(
      create: (BuildContext context) => BookViewModel(),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: const Text('Book List')),
        body: Center(
          child: Column(
            children: [
              StreamBuilder<List<Book>>(
                stream: Provider.of<BookViewModel>(context, listen: false)
                    .getBookList(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    log(snapshot.error.toString());
                    return const Center(
                      child:
                          Text('Bir Hata oluştu, daha sonra tekrar deneyiniz'),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<Book> bookList = snapshot.data!;
                      return BuildListview(bookList: bookList);
                    }
                  }
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBookView())),
        ),
      ),
    );
  }
}

class BuildListview extends StatefulWidget {
  const BuildListview({
    Key? key,
    required this.bookList,
  }) : super(key: key);

  final List<Book> bookList;

  @override
  State<BuildListview> createState() => _BuildListviewState();
}

class _BuildListviewState extends State<BuildListview> {
  bool isFiltering = false;
  List<Book> filteredList = [];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search : Book name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  setState(() {
                    isFiltering = true;
                    filteredList = widget.bookList
                        .where((book) => book.bookName
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                } else {
                  setState(() {
                    isFiltering = false;
                  });
                }
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount:
                  isFiltering ? filteredList.length : widget.bookList.length,
              itemBuilder: (context, index) {
                var list = isFiltering ? filteredList : widget.bookList;
                return Slidable(
                    startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.22,
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.person,
                            label: 'Kayıtlar',
                            onPressed: (_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BarrowListView(book: list[index])));
                            },
                          ),
                        ]),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                          onPressed: (_) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateBookView(book: list[index])));
                          },
                        ),
                        SlidableAction(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (_) async {
                            await Provider.of<BookViewModel>(context,
                                    listen: false)
                                .deleteBook(list[index].id);
                          },
                        ),
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(list[index].bookName),
                        subtitle: Text(list[index].authorName),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
