import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/authorization/change_email_page.dart';
import 'package:personal_frontend/authorization/change_password_page.dart';
import 'package:personal_frontend/authorization/login_or_register.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/account_management/cookies_policy_page.dart';
import 'package:personal_frontend/pages/account_management/end_user_liscence_agreement_page.dart';
import 'package:personal_frontend/pages/account_management/privacy_policy_page.dart';
import 'package:personal_frontend/pages/account_management/terms_and_conditions_app.dart';
import 'package:personal_frontend/pages/account_management/terms_and_conditions_web.dart';
import 'package:personal_frontend/services/authorization_services.dart';
import 'package:personal_frontend/services/user_account_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SettingsPage extends StatelessWidget {
  final UserModel? user;
  
  SettingsPage({
    super.key,
    required this.user,
  });

  // object to user UserAccountServices methods
  final UserAccountServices userAccountServices = UserAccountServices();

  // object to use AuthService methods
  final AuthServices authServices = AuthServices();

  // logout user
  void logout(BuildContext context) {
    authServices.clearCachedToken();
    FirebaseAuth.instance.signOut();

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegister()), // Replace LoginPage with your actual login screen
    );
  }

  // Show confirmation dialog for account deletion
  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {

              // Perform account deletion logic here
                try {
                  if (user != null) {
                    // Check if the profile image is not the default one
                    if (user!.profileImageUrl !=
                        'https://firebasestorage.googleapis.com/v0/b/personal-app-fe948.appspot.com/o/profile_images%2Fdefault_profile_image.jpg?alt=media&token=f33a9720-2010-41b4-a6d0-4ba450db2f99') {
                      try {
                        // Delete the profile image from Firebase Storage
                        await firebase_storage.FirebaseStorage.instance
                            .refFromURL(user!.profileImageUrl)
                            .delete();
                        print('Profile image deleted successfully');
                      } catch (e) {
                        print('Error deleting profile image: $e');
                      }
                    }

                    // Call your backend API to delete the user document and posts
                    await userAccountServices.deleteUser();

                    // Delete the user's Firebase authentication record
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      await currentUser.delete();
                    }

                    // If successful, navigate to the login screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginOrRegister()), // Replace LoginPage with your actual login screen
                    );
                  } else {
                    print('Error: user is null');
                  }
                } on FirebaseAuthException catch (e) {
                  // Handle errors specifically related to Firebase authentication
                  if (e.code == 'requires-recent-login') {
                    // If the error is about requiring recent login, reauthenticate the user
                    // and try deleting again. Here, you could show a dialog prompting the user
                    // to re-authenticate.
                    print("Error: ${e.message}");
                    displayMessageToUser(
                        "Please re-authenticate and try again.", context);
                  } else {
                    print("Error deleting authentication record: ${e.message}");
                    displayMessageToUser("Failed to delete account", context);
                  }
                } catch (e) {
                  // Handle other errors, such as those from userServices.deleteUser()
                  print("Error deleting account: $e");
                  displayMessageToUser("Failed to delete account", context);
                };
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logout button
                MySmallButton(
                  text: "Logout", 
                  onTap: () => logout(context),
                ),
            
                const SizedBox(height: 10,),
            
                // Change Email button
                MySmallButton(
                  text: "Change Email", 
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChangeEmailPage()),
                    );
                  },
                ),
            
                const SizedBox(height: 10,),
            
                // Change Password Button
                MySmallButton(
                  text: "Change Password", 
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                    );
                  },
                ),
            
                const SizedBox(height: 10,),
            
                // Delete Account button
                MySmallButton(
                  text: "Delete Account", 
                  onTap: () => showDeleteAccountDialog(context),
                ),
            
                const SizedBox(height: 10,),
            
                MySmallButton(
                  text: "Privacy Policy", 
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                    );
                  },
                ),
            
                const SizedBox(height: 10,),
            
                MySmallButton(
                  text: "Terms and Conditions for Website", 
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TermsAndConditionsWeb()),
                    );
                  },
                ),
            
                const SizedBox(height: 10,),
            
                MySmallButton(
                  text: "Terms and Conditions for App", 
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TermsAndConditionsApp()),
                    );
                  },
                ),
            
                const SizedBox(height: 10,),
            
                MySmallButton(
                  text: "Cookies Policy for Website", 
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CookiesPolicyPage()),
                    );
                  },
                ),
            
                const SizedBox(height: 10,),
            
                MySmallButton(
                  text: "End User Liscence Agreement", 
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const EndUserLiscenceAgreementPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
