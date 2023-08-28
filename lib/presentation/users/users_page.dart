import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:realtime_database/presentation/add_users/add_users_page.dart';
import 'package:realtime_database/presentation/update/update_user_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final user = FirebaseAuth.instance.currentUser;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('contacts');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Users'),
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.login_rounded)),
        ],
      ),
      body: FirebaseAnimatedList(
        query: dbRef,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          Map Contact = snapshot.value as Map;
          Contact['key'] = snapshot.key;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UpdateUserPage(
                    contactKey: Contact['key'],
                  ),
                ),
              );
              print(Contact['key']);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.indigo[100],
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ),
                  onPressed: () {
                    dbRef.child(Contact['key']).remove();
                  },
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    Contact['url'],
                  ),
                ),
                title: Text(
                  Contact['name'],
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  Contact['number'],
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddUsersPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
