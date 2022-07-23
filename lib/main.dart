import 'package:flutter/material.dart';
import 'package:reactive_flutter_typeahead/reactive_flutter_typeahead.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final form = FormGroup({
      'email': FormControl<String>(validators: [Validators.required]),
      'firstName': FormControl<String>(validators: [Validators.required]),
      'lastName': FormControl<String>(validators: [Validators.required]),
      'phone': FormControl<String>(validators: [Validators.required]),
    });

    form.control('email').valueChanges.listen((event) {
      if (event != null) {
        form.control('firstName').updateValue(event.firstName);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ReactiveFormBuilder(
        form: () => form,
        builder: (context, form, child) {
          return Column(
            children: [
              ReactiveTypeAhead<String, Member>(
                formControlName: 'email',
                textFieldConfiguration: const TextFieldConfiguration(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    icon: Icon(Icons.email),
                  ),
                ),
                stringify: (Member member) {
                  return member.email;
                },
                suggestionsCallback: (pattern) =>
                    queryMemberEmailData3(pattern),
                itemBuilder: (context, Member suggestion) {
                  return ListTile(
                    title: Text(suggestion.email),
                    subtitle: Text(
                        '${suggestion.firstName} ${suggestion.lastName} ${suggestion.phone}'),
                  );
                },
              ),
              Row(
                children: [
                  Flexible(
                    child: ReactiveTextField(
                      formControlName: 'firstName',
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        icon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ReactiveTextField(
                      formControlName: 'lastName',
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        icon: Icon(Icons.person),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  //ref.watch(screenTypeProvider) == ScreenType.view
                  //    ?
                  Flexible(
                    flex: 6,
                    child: ReactiveTextField(
                      formControlName: 'phone',
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        icon: Icon(Icons.person),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Column(
                      children: [
                        IconButton(
                          tooltip: 'Add Booking',
                          icon: Icon(Icons.save),
                          onPressed: () {
                            if (form.valid) {
                              print('form Valid');
                              print(form.value);
                            } else {
                              print('form Invalid');
                              print(form.value);
                              form.markAllAsTouched();
                            }
                          },
                        ),
                        Text('Book'),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<List<Member>> queryMemberEmailData3(patternin) async {
  final pattern = patternin.toLowerCase();
  print('email queryMemberEmail');
  print(
      'pattern length: ${pattern.length} memberList length: ${emailMembersList.length}');
  //print('membersList: ${membersList}');
  List<Member> emailList = [];

  emailMembersList.forEach((member) {
    print(member);
    if (member.email.startsWith(pattern)) {
      emailList.add(member);
    }
  });

  return emailList;
}

final emailMembersList = {
  Member(
      email: 'test1@abc.com',
      firstName: 'Test',
      lastName: '1',
      phone: '999 999-9999'),
  Member(
      email: 'test2@abc.com',
      firstName: 'Test',
      lastName: '2',
      phone: '666 666-6666'),
  Member(
      email: 'test3@abc.com',
      firstName: 'Test',
      lastName: '3',
      phone: '333 333-3333'),
  Member(
      email: 'test4@abc.com',
      firstName: 'Test',
      lastName: '4',
      phone: '444 444-4444'),
};

class Member {
  String firstName;
  String lastName;
  String phone;
  String email;

  Member(
      {required this.firstName,
      required this.lastName,
      required this.phone,
      required this.email});
}
