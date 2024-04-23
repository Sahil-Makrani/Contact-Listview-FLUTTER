import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyAppstateful();
  }
}

class MyAppstateful extends StatefulWidget{
  const MyAppstateful({super.key});

  @override
  State<MyAppstateful> createState() => MyAppstate();
}

class MyAppstate extends State<MyAppstateful>{

List<Contact> contacts =[];


  @override
  void initState() {
    super.initState();
    askparmission();
  }
  
  void askparmission() async{
    if(!await Permission.contacts.isGranted){
      await Permission.contacts.request();
      if(await Permission.contacts.isGranted){
        List<Contact> contacts=await ContactsService.getContacts();
      setState(() {
        this.contacts=contacts;
      });
      }
    }else{
      List<Contact> contacts=await ContactsService.getContacts();
      setState(() {
        this.contacts=contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(backgroundColor: Colors.black,title: const Text("Contacts",style: TextStyle(color: Colors.grey),),),body: ListView.builder(itemBuilder:(context, index) {
      return Container(color: Colors.grey,child: ListTile(title: Text(contacts[index].displayName!, style: const TextStyle(color: Colors.black)),
      subtitle: Text(contacts[index].phones![0].value!,
      style: const TextStyle(color: Colors.black)),
      leading: Text(contacts[index].displayName![0].toUpperCase(),style: const TextStyle(fontSize: 24),),));
    }, itemCount: contacts.length, shrinkWrap: true,),));
  }
  
}