import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/random_user_list_res.dart';
import '../viewmodel/home_viewmodel.dart';
import '../views/item_random_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadRandomUserList();
    viewModel.scrollController.addListener(() {
      if (viewModel.scrollController.position.maxScrollExtent <=
          viewModel.scrollController.offset) {
        viewModel.loadRandomUserList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(232, 232, 232, 1),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Random User - Provider"),
        ),
        body: ChangeNotifierProvider(
          create: (context) => viewModel,
          child: Consumer<HomeViewModel>(
            builder: (ctx, model, index) => Stack(
              children: [
                ListView.builder(
                  controller: viewModel.scrollController,
                  itemCount: viewModel.userList.length,
                  itemBuilder: (ctx, index) {
                    return itemOfRandomUser(viewModel.userList[index], index);
                  },
                ),
                viewModel.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ));
  }
}