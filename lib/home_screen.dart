import 'package:flutter/material.dart';

import 'const.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyGridScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyGridScreen extends StatefulWidget {
  @override
  _MyGridScreenState createState() => _MyGridScreenState();
}

class _MyGridScreenState extends State<MyGridScreen> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _rowsController = TextEditingController();
  TextEditingController _columnsController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  List<String> alphabetGrid = [];
  FocusNode _columnsFocusNode = FocusNode();
  int rows = 0;
  int columns = 0;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( Strings.appName),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: Strings.enteralphabte,
                    ),
                    onChanged: (value) {
                      setState(() {
                        alphabetGrid = value.replaceAll(RegExp('[^a-zA-Z]'), '').toUpperCase().split('');
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: TextField(
                    controller: _rowsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: Strings.rows,
                    ),
                    onChanged: (value) {
                      setState(() {
                        rows = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: TextField(
                    autofocus: true,
                    focusNode: _columnsFocusNode,
                    controller: _columnsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: Strings.columns,
                    ),
                    onChanged: (value) {
                      setState(() {
                        columns = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: Strings.search,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toUpperCase();
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Perform the search logic here
                    List<int> matchingIndices = findMatchingIndices();

                    // Print the matching indices to the console (you can customize this part)
                    print('Searching for: $searchText');
                    print('Matching Indices: $matchingIndices');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey, // Background color
                  ),
                  child: Text(Strings.search),
                ),
              ],
            ),
            SizedBox(height: 20),
                      Container(
                      width: MediaQuery.of(context).size.width, // Set width to the full screen width
              child: rows > 0 && columns > 0
              ? GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (MediaQuery.of(context).size.width / 80).floor(), // Adjust 100 as per your grid cell width
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              ),
              itemCount: rows * columns,
              itemBuilder: (BuildContext context, int index) {
              if (index < alphabetGrid.length) {
              return buildGridTile(index);
              } else {
              return Container(); // Empty container for remaining cells
              }
              },
              )
                  : Text(Strings.entervalidvalue),
              ),

          ],
        ),
      ),
    );
  }

  Widget buildGridTile(int index) {
    bool isMatched = isMatch(index);

    return Container(
      color: isMatched ? Colors.green : Colors.blue,
      child: Center(
        child: Text(
          alphabetGrid[index],
          style: TextStyle(
            color: isMatched ? Colors.white : Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  bool isMatch(int index) {
    if (searchText.isEmpty) {
      return false;
    }

    int rowIndex = index ~/ columns;
    int colIndex = index % columns;

    // Check east direction
    if (colIndex + searchText.length <= columns) {
      bool eastMatch = true;
      for (int i = 0; i < searchText.length; i++) {
        if (alphabetGrid[index + i] != searchText[i]) {
          eastMatch = false;
          break;
        }
      }
      if (eastMatch) return true;
    }

    // Check south direction
    if (rowIndex + searchText.length <= rows) {
      bool southMatch = true;
      for (int i = 0; i < searchText.length; i++) {
        if (alphabetGrid[index + i * columns] != searchText[i]) {
          southMatch = false;
          break;
        }
      }
      if (southMatch) return true;
    }

    // Check southeast direction
    if (colIndex + searchText.length <= columns && rowIndex + searchText.length <= rows) {
      bool southeastMatch = true;
      for (int i = 0; i < searchText.length; i++) {
        if (alphabetGrid[index + i * columns + i] != searchText[i]) {
          southeastMatch = false;
          break;
        }
      }
      if (southeastMatch) return true;
    }

    return false;
  }

  List<int> findMatchingIndices() {
    List<int> matchingIndices = [];

    for (int i = 0; i < alphabetGrid.length; i++) {
      if (alphabetGrid[i] == searchText) {
        matchingIndices.add(i);
      }
    }

    return matchingIndices;
  }
}
