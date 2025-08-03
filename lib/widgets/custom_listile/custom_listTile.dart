
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final Color? iconColor;
  final VoidCallback onTap;
  const CustomListTile({super.key, required this.title, required this.leadingIcon, this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Card(
        elevation: 0,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        child: ListTile(
          onTap: onTap,
          tileColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(10),
          leading: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Icon(leadingIcon,color: iconColor ?? theme.iconTheme.color,),
          ),
          title: Text(title,style: theme.textTheme.titleMedium,),
          trailing: Icon(Icons.arrow_forward_ios_outlined,color: theme.iconTheme.color,),
        ),
      ),
    );
  }
}
