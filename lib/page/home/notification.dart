import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> unreadNotifications = [
    {
      "title": "New Message",
      "desc": "Lorem Ipsum is simply dummy text of the printing industry.",
      "time": "2 hours ago",
    },
    {
      "title": "Account Update",
      "desc": "Your profile has been updated successfully.",
      "time": "1 hour ago",
    },
  ];

  List<Map<String, dynamic>> readNotifications = [
    {
      "title": "Welcome",
      "desc": "Thanks for joining our platform.",
      "time": "Yesterday",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff10B66D),
      body: Column(
        children: [
          /// HEADER
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset("assets/images/as24.png", height: 4.h),
                  ),
                  const Spacer(),
                  text_widget(
                    "Notifications",
                    color: Colors.white,
                    fontSize: 21.sp,
                  ),
                  const Spacer(),
                  Image.asset(
                    "assets/images/as24.png",
                    height: 4.h,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          /// BODY
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                padding: EdgeInsets.only(top: 10),
                children: [
                  /// UNREAD
                  _sectionTitle("Unread Notifications", true),
                  ...unreadNotifications.asMap().entries.map((entry) {
                    int index = entry.key;
                    var data = entry.value;

                    return _notificationTile(
                      title: data["title"],
                      desc: data["desc"],
                      time: data["time"],
                      isUnread: true,
                      onDelete: () {
                        setState(() {
                          unreadNotifications.removeAt(index);
                        });
                      },
                    );
                  }),

                  SizedBox(height: 2.h),

                  /// READ
                  _sectionTitle("Read Notifications", false),
                  ...readNotifications.asMap().entries.map((entry) {
                    int index = entry.key;
                    var data = entry.value;

                    return _notificationTile(
                      title: data["title"],
                      desc: data["desc"],
                      time: data["time"],
                      isUnread: false,
                      onDelete: () {
                        setState(() {
                          readNotifications.removeAt(index);
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title, bool primary) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: primary ? const Color(0xff10B66D) : Colors.black,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Container(
              height: 1,
              color: primary ? const Color(0xff10B66D) : Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  /// NOTIFICATION TILE
  Widget _notificationTile({
    required String title,
    required String desc,
    required String time,
    required bool isUnread,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.8.h),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Container(
          height: 10.h,
          decoration: BoxDecoration(
            color: const Color(0xffF6F6F6),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              Container(
                width: 2.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isUnread ? const Color(0xff10B66D) : Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.6.h),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
