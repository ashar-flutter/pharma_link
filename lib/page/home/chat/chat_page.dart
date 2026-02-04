import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/controller/chat_controller.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatScreenView extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final String? receiverRole;

  const ChatScreenView({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    this.receiverRole,
  });

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final ChatController controller = Get.find<ChatController>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController msgController = TextEditingController();


  @override
  void initState() {
    super.initState();WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.openChat(
        widget.receiverId,
        widget.receiverName,
        widget.receiverImage,
        widget.receiverRole,
      );
    });
  }

  @override
  void dispose() {
    controller.closeChat();
    scrollController.dispose();
    msgController.dispose();
    super.dispose();
  }

  void sendMsg() {
    final text = msgController.text.trim();
    if (text.isNotEmpty) {
      msgController.clear();
      controller.sendMessage(text);
      Future.delayed(Duration(milliseconds: 100), () {
        FocusManager.instance.primaryFocus?.unfocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: MyColors.primary,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: MyColors.primary,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Image.asset("assets/images/back.png", height: 3.5.h),
            onPressed: () => Get.back(),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 2.6.h,
                backgroundColor: Colors.grey[200],
                backgroundImage: widget.receiverImage.isNotEmpty
                    ? CachedNetworkImageProvider(widget.receiverImage)
                    : null,
              ),
              SizedBox(width: 2.4.w),
              GetBuilder<ChatController>(
                id: 'header',
                builder: (ctrl) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text_widget(
                        widget.receiverName,
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 0.5.h),
                      if (ctrl.receiverOnline)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.greenAccent,
                            ),
                            SizedBox(width: 1.w),
                            text_widget(
                              "Online",
                              fontSize: 13.8.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            if (widget.receiverRole != null && widget.receiverRole!.isNotEmpty)
              Container(
                width: 25.w,
                height: 2.8.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(90),
                ),
                margin: EdgeInsets.only(right: 16),
                child: Center(
                  child: text_widget(
                    widget.receiverRole!,
                    fontSize: 12.4.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.0),
                  child: GetBuilder<ChatController>(
                    id: 'messages',
                    builder: (ctrl) {
                      return ListView.builder(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        reverse: false,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 12.0,
                        ),
                        itemCount: ctrl.messages.length,
                        itemBuilder: (context, index) {
                          final msg = ctrl.messages[index];
                          final me = msg.senderId == currentUser.id;
                          final time = ctrl.formatTime(msg.timestamp);

                          Widget content;

                          if (msg.messageType == 'image' &&
                              msg.fileUrl != null) {
                            content = GestureDetector(
                              onTap: () {
                                Get.dialog(
                                  Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      width: Get.width * 0.9,
                                      height: Get.height * 0.7,
                                      child: CachedNetworkImage(
                                        imageUrl: msg.fileUrl!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 60.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: msg.fileUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            content = Text(
                              msg.message,
                              style: GoogleFonts.plusJakartaSans(
                                color: me ? Colors.white : Colors.black,
                              ),
                            );
                          }

                          return Align(
                            alignment: me
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: me
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 2.w),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: me
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: me
                                                ? MyColors.primary1
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                              bottomLeft: Radius.circular(
                                                me ? 16 : 0,
                                              ),
                                              bottomRight: Radius.circular(
                                                me ? 0 : 16,
                                              ),
                                            ),
                                          ),
                                          child: content,
                                        ),
                                        text_widget(
                                          time,
                                          fontSize: 11.sp,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                  child: Row(
                    children: [
                      onPress(
                        ontap: () => controller.sendImage(),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/link.png",
                            height: 3.5.h,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: msgController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type message here...",
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      color: Colors.grey,
                                      fontSize: 14.sp,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.sp,
                                  ),
                                  onSubmitted: (value) => sendMsg(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      onPress(
                        ontap: sendMsg,
                        child: Image.asset(
                          "assets/icons/send.png",
                          height: 5.h,
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
