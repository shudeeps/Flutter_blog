import 'package:flutter/material.dart';
import 'sql_helper.dart';

//
//This is search page and this will search blog targeting title
// https://www.kindacode.com/article/how-to-create-a-filter-search-listview-in-flutter/

class search extends StatefulWidget {

  @override
  _searchstate createState() => _searchstate();
}

class _searchstate extends State<search> {


  final List<Map<String, dynamic>> _allUsers = [];

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];

  void _refreshJournals() async {

  }

  @override
  initState() {
    // at the beginning, all users are shown
    _refreshJournals();
    _foundUsers = _allUsers;
    super.initState();

  }


  void _filterList(v) async {
    final data = await SQLHelper.search(v);
    setState(() {
      _foundUsers = data;

    });

    print(_foundUsers);
  }
  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    print(enteredKeyword);
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {

      _filterList(enteredKeyword);

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI

    print(results);
    setState(() {
      _foundUsers = results;
    });
  }

  void _showClick(content){

    print('here');
    print(content);
    var date=content['createdAt'];
    var formattedDate =  date.substring(0, 10);

    print(formattedDate);

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 20.0),
          height: 600,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              Text(
                content['title'],
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'date :' +''+formattedDate,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.blue,
                ),
              ),
              Text(
                content['description'],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              ),

              ElevatedButton(
                child: const Text('Share'),
                onPressed: () => Navigator.pop(context),
              ),

              ListTile(
                leading: new Icon(Icons.cancel),
                title: new Text('Close'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),


            ],
          ),

        );
      },
    );



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) => Card(

                  key: ValueKey(_foundUsers[index]["id"]),
                  color: Colors.lightBlueAccent,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Text(
                      _foundUsers[index]["id"].toString(),
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(_foundUsers[index]['title']),
                    subtitle: Text(_foundUsers[index]['description']),
                    onTap: () => _showClick(_foundUsers[index]),
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}