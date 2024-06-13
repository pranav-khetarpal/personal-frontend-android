import 'dart:async';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_large_button.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/image_services.dart';
import 'package:personal_frontend/services/user_account_services.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
    // variables for displaying the user's information
  late Future<UserModel> futureUser;
  UserModel? currentUser;
  bool isLoadingCurrentUser = true;

  // object to user UserInteractionServices methods
  final UserInteractionServices userInteractionServices = UserInteractionServices();
  final UserAccountServices userAccountServices = UserAccountServices();
  final ImageServices imageServices = ImageServices();

  // text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // Fetch the current user's profile
  }

  // fetch the current user's profile to display their information
  Future<void> fetchCurrentUser() async {
    try {
      UserModel user = await userInteractionServices.fetchCurrentUser();
      setState(() {
        currentUser = user;
        isLoadingCurrentUser = false;
        // Update text controllers with fetched user data
        nameController.text = currentUser?.name ?? '';
        usernameController.text = currentUser?.username ?? '';
        bioController.text = currentUser?.bio ?? '';
      });
    } catch (error) {
      setState(() {
        isLoadingCurrentUser = false;
      });
      // Handle error fetching current user
      print('Error fetching current user: $error');
    }
  }

  // update the current user's information
  void updateProfile() async {
    try {
      // // Check if the username is available
      // bool isAvailable = await userAccountServices.isUsernameAvailable(usernameController.text);
      // if (!isAvailable) {
      //   displayMessageToUser("Username is not available", context);
      //   return;
      // }

      // Check if the username has been changed
      bool usernameChanged = currentUser!.username != usernameController.text;

      // If the username has been changed, then check if it's available
      if (usernameChanged) {
        bool isAvailable = await userAccountServices.isUsernameAvailable(usernameController.text);
        if (!isAvailable) {
          displayMessageToUser("Username is not available", context);
          return;
        }
      }

      // Create a new user model with the updated data
      UserModel updatedUser = UserModel(
        id: currentUser!.id,
        name: nameController.text, // the user's inputted name
        username: usernameController.text, // the user's inputted username
        bio: bioController.text, // the user's inputted bio
        profile_image_url: currentUser!.profile_image_url,
        following: currentUser!.following,
      );

      // Send the updated data to the backend
      bool success = await userAccountServices.updateUserProfile(updatedUser);

      if (success) {
        // Show a success message or perform additional actions
        displayMessageToUser("Profile updated successfully", context);
      } else {
        // Handle failure
        displayMessageToUser("Failed to update profile", context);
      }
    } catch (error) {
      // Handle error
      print('Error updating profile: $error');
      displayMessageToUser("Error updating profile", context);
    }
  }

  // Method to handle photo upload
  void handlePhotoUpload() async {
    try {
      await imageServices.updateUserProfileImage(currentUser!.id);
      // Fetch the updated user profile to refresh the displayed image
      await fetchCurrentUser();
    } catch (e) {
      print('Error uploading profile image: $e');
      displayMessageToUser("Failed to upload profile image", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Center(
        child: isLoadingCurrentUser
          ? const CircularProgressIndicator()
          : Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: currentUser!.profile_image_url.isNotEmpty
                            ? NetworkImage(currentUser!.profile_image_url)
                            : null,
                        onBackgroundImageError: (exception, stackTrace) {
                          print('Error loading profile image: $exception');
                          setState(() {
                            // Fallback to default icon or image in case of an error
                            currentUser!.profile_image_url = '';
                          });
                        },
                        child: currentUser!.profile_image_url.isEmpty
                            ? const Icon(Icons.account_circle, size: 50)
                            : null,
                      ),
                      // CircleAvatar(
                      //   radius: 50,
                      //   backgroundImage: currentUser!.profile_image_url.isNotEmpty
                      //       ? NetworkImage(currentUser!.profile_image_url)
                      //       : null,
                      //   child: currentUser!.profile_image_url.isEmpty
                      //       ? const Icon(Icons.account_circle, size: 50)
                      //       : null,
                      //   // onBackgroundImageError: (exception, stackTrace) {
                      //   //     print('Failed to load profile image: $exception');
                      //   //     setState(() {
                      //   //       currentUser!.profile_image_url = ''; // Reset to default icon
                      //   //     });
                      //   //   },
                      // ),
                      const SizedBox(width: 16),

                      MySmallButton(
                        text: "Upload photo", 
                        onTap: handlePhotoUpload,
                      ),
                      // ElevatedButton(
                      //   onPressed: handlePhotoUpload, // Call the photo upload method
                      //   child: const Text("Upload photo"),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 16,),
            
                  // name textfield
                  MySquareTextField(
                    hintText: "Full Name",
                    obscureText: false,
                    controller: nameController,
                    maxLength: 50,
                    allowSpaces: true,
                  ),
            
                  const SizedBox(height: 10),
            
                  // username textfield
                  MySquareTextField(
                    hintText: "@username",
                    obscureText: false,
                    controller: usernameController,
                    maxLength: 50,
                    allowSpaces: false,
                  ),
                  	
                  const SizedBox(height: 10),
                  
                  MySquareTextField(
                    hintText: "Bio",
                    obscureText: false,
                    controller: bioController,
                    maxLength: 160,  // Twitter-like bio length
                    allowSpaces: true,
              
                  ),
            
                  const SizedBox(height: 35),
            
                  // update button
                  MyLargeButton(
                    text: "Update Public Information",
                    onTap: updateProfile,
                  ),
                ],
              ),
          ),
      ),
    );
  }
}
