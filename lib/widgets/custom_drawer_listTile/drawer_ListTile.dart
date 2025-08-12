import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final VoidCallback onTap;

  const DrawerListTile({super.key, required this.title, required this.leadingIcon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Card(
        elevation: 0,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        child: ListTile(
          onTap: onTap,
          tileColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(5),
          leading: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Icon(leadingIcon,color: theme.iconTheme.color,),
          ),
          title: Text(title,style: theme.textTheme.titleMedium,),
          trailing: Icon(Icons.arrow_forward_ios_outlined,color: theme.iconTheme.color,),
        ),
      ),
    );
  }
}
