import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/multi_dropdown_button.dart';
import 'package:multi_dropdown_button_example/models/user.dart';

void main() {
  runApp(const MultiDropdownButtonDemoApp());
}

class MultiDropdownButtonDemoApp extends StatelessWidget {
  const MultiDropdownButtonDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi DropdownButton Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        title: 'Multi DropdownButton Demo',
        users: User.generateRandomUser,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.title,
    required this.users,
  }) : super(key: key);

  final String title;
  final List<User> users;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User>? selectedUsers;

  void onUsersSelectionChanged(List<User?>? users) {
    debugPrint(users.toString());
    selectedUsers = users!.map((e) => e!).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              height: kToolbarHeight,
              child: MultiDropdownButton<User?>(
                values: selectedUsers,
                items: widget.users
                    .map(
                      (user) => MultiDropdownMenuItem<User?>(
                        value: user,
                        child: Text(
                          user.name,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (users) {
                  onUsersSelectionChanged(users);
                },
              ),
            ),
            selectedUsers != null && selectedUsers!.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'You have selected following users:',
                      ),
                      Flexible(
                        child: Column(
                          children: selectedUsers!
                              .map(
                                (user) => Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              )
                              .toList(),
                        ),
                      )
                    ],
                  )
                : const Text('No users selected yet'),
          ],
        ),
      ),
    );
  }
}
