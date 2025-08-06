import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/preferences_provider/preferences_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/theme_provider/theme_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/sign_in_sign_up/sign_in_sign_up.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/custom_listile/custom_listTile.dart';
import 'package:provider/provider.dart';
import '../../../provider/auth_provider/auth_provider.dart';
import '../../../provider/local_auth_provider/local_auth_provider.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final TextEditingController _bioController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  final GlobalKey<FormState> _updatePassKey =  GlobalKey<FormState>();
  final GlobalKey<FormState> _deletePassKey =  GlobalKey<FormState>();
  final GlobalKey<FormState> _pinLockKey = GlobalKey<FormState>();


  bool isAddingBio = false;

  bool isLocalAuthEnabled = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    user?.reload().then((_){ //manually signup korle user er nam show hobe
      setState(() {

      });
    });
  }

  @override
  void didChangeDependencies() {
    _bioController.text = context.watch<PreferencesProvider>().bio??'';
    super.didChangeDependencies();
  }
  
  void changeTheme(BuildContext context){
    var theme = Theme.of(context);
    final themeProvider = context.read<ThemeProvider>();
    AppThemeMode selected = themeProvider.mode;
    showDialog(
        context: context, 
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Change theme',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...AppThemeMode.values.map((mode){
                    return RadioListTile(
                      tileColor: Colors.transparent,
                      title: mode==AppThemeMode.light?
                      Text('Light mode',style: theme.textTheme.titleMedium,)
                      :mode==AppThemeMode.dark?Text('Dark mode',style: theme.textTheme.titleMedium,)
                      :Text('System default',style: theme.textTheme.titleMedium,),
                        value: mode,
                        groupValue: selected,
                        onChanged: (value){
                          themeProvider.setTheme(mode);
                          Navigator.pop(context);
                        },
                    );
                  })
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Text('Cancel',style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),)
              )
            ],
          );
        }
    );
  }

  void enableLocalAuthAlert(BuildContext context){
    var theme = Theme.of(context);
    final provider = context.read<LocalAuthProvider>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Set a new 4 digit pin',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),),
            content: Form(
              key: _pinLockKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _pinController,
                      cursorColor: theme.colorScheme.primary,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a 4-digit pin code";
                        }
                        if (value.length != 4) {
                          return "Pin code must be exactly 4 digits";
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        hintText: 'Enter your 4 digit pin code',
                        hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    ElevatedButton(
                        onPressed: ()async{
                          if(_pinLockKey.currentState!.validate()){
                            await provider.savePin(_pinController.text);
                            await context.read<PreferencesProvider>().toggleLocalAuth(true);
                            ToastMsg.successToast('Pin lock enabled successfully');
                            Navigator.pop(context);
                            _pinController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: theme.colorScheme.primary,
                            minimumSize: Size(double.infinity.w, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)
                            ),
                        ),
                        child: Text('Set pin lock', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w500),)
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),)
              )
            ],
          );
        }
    );
  }



  void updatePassAlert(BuildContext context){
    var theme = Theme.of(context);
    final auth = context.read<AuthProvider>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Update password',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),),
            content: Form(
              key: _updatePassKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Fill up the credentials below & update your password',style: theme.textTheme.titleMedium,),
                    SizedBox(height: 20.h,),
                    TextFormField(
                     controller: _emailController,
                      validator: (value){
                       if(value!.isEmpty){
                         return 'Please enter your email address';
                       }
                       if(!value.contains('@') || !value.contains('.com')){
                         return 'Please enter a valid email address';
                       }
                       return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _currentPassController,
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter your current password',
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _newPassController,
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please enter your new password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter your new password',
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    ElevatedButton(
                        onPressed: ()async{
                         if(_updatePassKey.currentState!.validate()){
                           bool success = await auth.reauthenticateAndChangePassword(
                               email: _emailController.text.trim(),
                               currentPassword: _currentPassController.text.trim(),
                               newPassword: _newPassController.text.trim()
                           );
                           if(success){
                             ToastMsg.successToast('Password updated successfully, Please re login with new password');
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInSignUp()));
                           }
                           else{
                             ToastMsg.errorToast(auth.errorMsg!);
                           }
                         }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: Size(double.infinity.w, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: context.watch<AuthProvider>().isLoading?AppLoader.lightThemeLoader():Text('Update password',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: Colors.white),)
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Text('Cancel',style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),)
              )
            ],
          );
        }
    );
  }

  void deleteAccountAlert(BuildContext context){
    var theme = Theme.of(context);
    final auth = context.read<AuthProvider>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Delete account',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: Colors.red),),
            content: Form(
              key: _deletePassKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Are you sure you want to delete this account?\nThis can not be undone',style: theme.textTheme.titleMedium,),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _emailController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please enter your email address';
                        }
                        if(!value.contains('@') || !value.contains('.com')){
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _currentPassController,
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter your current password',
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    ElevatedButton(
                        onPressed: ()async{
                          if(_deletePassKey.currentState!.validate()){
                            bool success = await auth.reauthenticateAndDeleteAccount(
                                email: _emailController.text.trim(),
                                password: _currentPassController.text.trim(),
                            );
                            if(success){
                              ToastMsg.successToast('Account deletion successful');
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInSignUp()));
                            }
                            else{
                              ToastMsg.errorToast(auth.errorMsg!);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.red,
                          minimumSize: Size(double.infinity.w, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: context.watch<AuthProvider>().isLoading?AppLoader.lightThemeLoader():Text('Delete account',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: Colors.white),)
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),)
              )
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final prefs = context.watch<PreferencesProvider>();
    bool isDark = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('User profile', style: theme.textTheme.headlineMedium),
        iconTheme: theme.iconTheme,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: isDark ? Brightness.light : Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            user?.photoURL != null
                ? CircleAvatar(
              radius: 50.r,
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
            )
                :
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                  child: Icon(Icons.person, color: theme.colorScheme.primary, size: 60),
                ),


            SizedBox(height: 20.h),
            Text(
              user?.displayName ?? '',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAddingBio)
                    Row(
                      children: [
                        SizedBox(
                          width: 180.w,
                          child: TextField(
                            controller: _bioController,
                            cursorColor: theme.colorScheme.primary,
                            decoration: InputDecoration(
                              hintText: 'Add a bio',
                              hintStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final newBio = _bioController.text.trim();
                            if (newBio.isNotEmpty) {
                              await prefs.saveUserBio(newBio);
                            }
                            setState(() {
                              isAddingBio = false;
                            });
                          },
                          child: Text('Save', style: TextStyle(fontSize: 15, color: theme.colorScheme.primary)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isAddingBio = false;
                            });
                          },
                          child: Text('Cancel', style: TextStyle(fontSize: 15, color: Colors.red)),
                        ),
                      ],
                    )
                  else if (prefs.bio != null && prefs.bio!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(prefs.bio!, style: theme.textTheme.titleMedium),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isAddingBio = true;
                        });
                      },
                      child: Text(
                        'Write something about yourself',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500,color: Colors.grey),
                      ),
                    ),

                  if (!isAddingBio)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isAddingBio = true;
                        });
                      },
                      icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                    ),

                  if (prefs.bio != null && prefs.bio!.isNotEmpty && !isAddingBio)
                    IconButton(
                      onPressed: () async {
                        await prefs.clearUserBio();
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                ],
              ),
            ),

            SizedBox(height: 10.h,),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text('Personalisation',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            CustomListTile(
                title: 'Change theme',
                leadingIcon: isDark?Icons.dark_mode: context.watch<ThemeProvider>().currentTheme==ThemeMode.system?Icons.android:Icons.light_mode,
                onTap: (){
                  changeTheme(context);
                }
            ),
            CustomListTile(
                title: 'Change language',
                leadingIcon: Icons.language,
                onTap: (){

                }
            ),
            CustomListTile(
                title: 'Notifications',
                leadingIcon: Icons.notifications,
                onTap: (){

                }
            ),
            SizedBox(height: 10.h,),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text('Security',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Card(
                elevation: 0,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  tileColor: Colors.transparent,
                  contentPadding: EdgeInsetsGeometry.all(10),
                  leading: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Icon(Icons.lock,color: theme.iconTheme.color,),
                  ),
                  title: Text('Enable Biometric / Pin lock',style: theme.textTheme.titleMedium,),
                  trailing: Switch(
                      value: prefs.isAuthEnabled,
                      onChanged: (value)async{
                        final localAuth = context.read<LocalAuthProvider>();
                        if(value){
                          if (!localAuth.isPinSet) {
                            enableLocalAuthAlert(context);
                          }
                          else{
                            await context.read<PreferencesProvider>().toggleLocalAuth(true);
                          }
                        }
                        else{
                          await context.read<PreferencesProvider>().toggleLocalAuth(false);
                          await localAuth.deletePin();
                        }
                      }
                  )
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text('Account',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            CustomListTile(
                title: 'Sign out',
                leadingIcon: Icons.logout,
                onTap: ()async{
                  await context.read<AuthProvider>().signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInSignUp()));
                }
            ),
            CustomListTile(
                title: 'Change password',
                leadingIcon: Icons.password,
                onTap: (){
                  updatePassAlert(context);
                }
            ),
            CustomListTile(
                title: 'Delete account',
                leadingIcon: Icons.delete_forever,
                iconColor: Colors.red,
                onTap: (){
                  deleteAccountAlert(context);
                }
            ),
          ],
        ),
      ),
    );
  }
}
