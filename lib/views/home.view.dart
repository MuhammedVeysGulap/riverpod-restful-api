import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/controller/controller.dart';
import 'package:riverpod_app/widgets/loading_widget.dart';

final controller = ChangeNotifierProvider((ref) => Controller());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    ref
        .read(controller)
        .getData(); //Riverpod state management paketiyle data okuması yapar.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var read = ref.read(controller);
    var watch = ref.watch(controller);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Riverpod',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: LoadingWidget(
        isLoading: watch.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 6,
                      child: OutlinedButton(
                          onPressed: () => read.notSavedButton(),
                          child: Text('Users (${watch.users.length})'))),
                  const Spacer(),
                  Expanded(
                      flex: 6,
                      child: OutlinedButton(
                          onPressed: () => read.savedButton(),
                          child: Text('Saved (${watch.saved.length})'))),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: PageView(
                  controller: watch.pageController,
                  children: [notSaved(watch), saved(watch)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Saved sayfasındaki Card widgetının tasarım
  ListView saved(Controller watch) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(watch.saved[index]!.avatar!),
                  radius: 20,
                ),
                title: Text(
                  '${watch.saved[index]?.firstName ?? ''} '
                  '${watch.saved[index]?.lastName ?? ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  watch.saved[index]?.email ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey.shade400),
                ),
                trailing: IconButton(
                    onPressed: () => watch.deleted(watch.saved[index]!),
                    icon: const Icon(Icons.delete)),
              ));
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 15,
          );
        },
        itemCount: watch.saved.length);
  }

//Users sayfasındaki Card widgetının tasarım
  ListView notSaved(Controller watch) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(watch.users[index]!.avatar!),
                  radius: 20,
                ),
                title: Text(
                  '${watch.users[index]?.firstName ?? ''} '
                  '${watch.users[index]?.lastName ?? ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  watch.users[index]?.email ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey.shade400),
                ),
                trailing: IconButton(
                    onPressed: () => watch.addSaved(watch.users[index]!),
                    icon: const Icon(Icons.send_and_archive_outlined)),
              ));
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 15,
          );
        },
        itemCount: watch.users.length);
  }
}
