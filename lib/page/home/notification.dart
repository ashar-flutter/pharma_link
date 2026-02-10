import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/notification_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff10B66D),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset("assets/images/back.png", height: 3.5.h),
                  ),
                  const Spacer(),
                  text_widget(
                    "Notifications",
                    color: Colors.white,
                    fontSize: 21.sp,
                  ),
                  const Spacer(),
                  Image.asset(
                    "assets/images/back.png",
                    height: 3.5.h,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: GetBuilder<NotificationController>(
                id: 'notifications',
                builder: (ctrl) {
                  final unread = ctrl.unreadNotifications;
                  final read = ctrl.readNotifications;

                  return ListView(
                    padding: EdgeInsets.only(top: 10),
                    children: [
                      _sectionTitle("Unread Notifications", true),
                      ...unread.map((data) {
                        return _notificationTile(
                          title: data.title,
                          desc: data.description,
                          time: _formatTime(data.timestamp),
                          isUnread: !data.isRead,
                          onDelete: () {},
                          onTap: () {
                            ctrl.markAsRead(data.id);
                          },
                        );
                      }),

                      SizedBox(height: 2.h),

                      _sectionTitle("Read Notifications", false),
                      ...read.map((data) {
                        return _notificationTile(
                          title: data.title,
                          desc: data.description,
                          time: _formatTime(data.timestamp),
                          isUnread: !data.isRead,
                          onDelete: () {},
                          onTap: () {
                            ctrl.markAsRead(data.id);
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool primary) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
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

  Widget _notificationTile({
    required String title,
    required String desc,
    required String time,
    required bool isUnread,
    required VoidCallback onDelete,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              time,
                              style: GoogleFonts.plusJakartaSans(
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
                          style: GoogleFonts.plusJakartaSans(
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
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return '${time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}/${time.year % 100}';
    }
  }
}