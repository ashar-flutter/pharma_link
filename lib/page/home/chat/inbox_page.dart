import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/controller/chat_controller.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'chat_page.dart';

class InboxPage1 extends StatefulWidget {
  const InboxPage1({super.key});

  @override
  State<InboxPage1> createState() => _InboxPage1State();
}

class _InboxPage1State extends State<InboxPage1> {
  final ChatController controller = Get.find<ChatController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      controller.updateSearch(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Spacer(),
                  text_widget("Inbox", color: Colors.white, fontSize: 21.0.sp),
                  Spacer(),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      height: 6.h,
                      width: 90.w,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/icons/ss1.png", height: 2.5.h),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search conversations...",
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey,
                                  fontSize: 14.0.sp,
                                ),
                              ),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.0.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.4.h),
                    GetBuilder<ChatController>(
                      id: 'inbox',
                      builder: (ctrl) {

                        final convs = ctrl.filteredConvs;

                        if (convs.isEmpty) {

                          return Expanded(
                            child: Center(
                              child: text_widget(
                                "No conversations yet",
                                fontSize: 16.0.sp,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: convs.length,
                            itemBuilder: (context, index) {
                              final conv = convs[index];

                              return onPress(
                                ontap: () {

                                  Get.to(
                                        () => ChatScreenView(
                                      receiverId: conv.otherUserId,
                                      receiverName: conv.otherUserName,
                                      receiverImage: conv.otherUserImage,
                                      receiverRole: '',
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 14.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.grey[200],
                                            backgroundImage:
                                            conv.otherUserImage.isNotEmpty
                                                ? CachedNetworkImageProvider(
                                              conv.otherUserImage,
                                            )
                                                : null,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                text_widget(
                                                  conv.otherUserName,
                                                  fontSize: 14.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                SizedBox(height: 4),
                                                text_widget(
                                                  conv
                                                      .lastMessage
                                                      .message
                                                      .length >
                                                      40
                                                      ? '${conv.lastMessage.message.substring(0, 40)}...'
                                                      : conv
                                                      .lastMessage
                                                      .message,
                                                  fontSize: 12.0.sp,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            children: [
                                              text_widget(
                                                ctrl.formatTime(
                                                  conv.lastMessageTime,
                                                ),
                                                fontSize: 12.0.sp,
                                                color: Colors.grey.shade600,
                                              ),
                                              SizedBox(height: 8),
                                              if (conv.unreadCount > 0)
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor:
                                                  MyColors.primary,
                                                  child: text_widget(
                                                    conv.unreadCount > 9
                                                        ? "9+"
                                                        : conv.unreadCount
                                                        .toString(),
                                                    fontSize: 9.0,  // Fixed: int -> double
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Divider(
                                        color: Colors.grey.shade200,
                                        thickness: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}