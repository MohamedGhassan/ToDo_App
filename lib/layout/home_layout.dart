import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/aechived_tasks/archived_tasks_screen.dart';
import '../modules/done_tasks/done_tasks_screen.dart';
import '../modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> title = [
    'NewTasks',
    'DoneTasks',
    'ArchivedTasks',
  ];

  Database database;

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title[currentIndex],
        ),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          insertToDatabase();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  Future<String> getName() async {
    return "Ahmed Ali";
  }

  void createDatabase() async {
    database = await openDatabase('ToDoList.db', version: 1,
        onCreate: (database, version) {
      print('database created');
      database.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, date TEXT, time TEXT, status TEXT')
          .then((value) {
            print('table created');
      }).catchError((error) {
        print('Error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      print('database opened');
    });
  }

  void insertToDatabase() {
    database.transaction((txn)
    {
      txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("first task", "02222", "891", "new")')
          .then((value)
      {
        print("$value inserted successfully");
      }).catchError((error)
      {
        print('Error when inserting new record ${error.toString()}');
      });
      return null;
    });
  }
}
