import 'package:flutter/material.dart';
import 'package:eduquality/views/widgets/screens/profile_screen.dart';
import '../../../controllers/search_controller.dart';
import 'package:get/get.dart';

import '../../../models/user.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());



  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: TextFormField(
              decoration: const InputDecoration(
                filled: false,
                hintText: 'Search',
                hintStyle: TextStyle(
                    fontSize: 18, color: Colors.white
                ),
              ),
                //CAN NOT DO IF..ELSE DIRECTLY HERE
              onFieldSubmitted: (value) {

                // Call the appropriate function based on the condition
               /**** NOT READY FOR SEARCH WITH HASHTAG
                 if(value.startsWith("#")) {
                  searchController.searchVideo(value);
                } else {
                  searchController.searchUser(value);

                } *****/
                searchController.searchUser(value);
              },

            ),
          ),
          body: searchController.searchedUsers.isEmpty ? Center(
            child: Text(
              'Search for Video Groups\n Leave blank to see all\n',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ):ListView.builder(
              itemCount: searchController.searchedUsers.length,
              itemBuilder: (context, index) {
                User user = searchController.searchedUsers[index];
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(uid: user.uid),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          user.profilePhoto),
                    ),
                    title: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                    ),
                  ),
                );
                },
          ),
        );
      }
    );
  }
}
