import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPageDrawer extends StatefulWidget {
  const MainPageDrawer({super.key});

  @override
  State<MainPageDrawer> createState() => _MainPageDrawerState();
}

class _MainPageDrawerState extends State<MainPageDrawer> {
  late TextEditingController dropDownMenuCon;
  @override
  void initState() {
    dropDownMenuCon = TextEditingController(text: 'Suits');
    super.initState();
  }

  @override
  void dispose() {
    dropDownMenuCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Filter',
                      style: TextStyle(fontFamily: 'DM Sans', fontSize: 10.sp)),
                  const Icon(Icons.swap_calls)
                ],
              ),
            ),
            SizedBox(height: 3.h),
            const Divider(
              thickness: 3,
            ),
            SizedBox(height: 1.h),
            Text('Category',
                style: TextStyle(
                    fontFamily: 'DM Sans', fontSize: 9.sp, color: Colors.grey)),
            SizedBox(height: 2.h),
            SizedBox(
              width: 63.w,
              child: DropdownMenu(
                  controller: dropDownMenuCon,
                  width: 62.w,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 0, label: 'Suits'),
                    DropdownMenuEntry(value: 1, label: 'Pants')
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
