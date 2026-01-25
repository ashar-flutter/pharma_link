import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatScreenView extends StatefulWidget {
  final bool isBot;
  const ChatScreenView({super.key, required this.isBot});

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MyColors.primary,

        appBar: AppBar(
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: MyColors.primary,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Container(),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Image.asset("assets/images/as24.png", height: 4.h),
            onPressed: () => Get.back(),
          ),
          title: Row(
            children: [
              Image.asset("assets/images/as9.png", height: 5.2.h),
              SizedBox(width: 2.4.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text_widget(
                    "Pharmacy Name",
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 0.5.h),

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
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            Container(
              width: 25.w,
              height: 2.8.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(90),
              ),
              margin: EdgeInsets.only(right: 16),
              child: Center(
                child: text_widget(
                  "Staff Pharmacist",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: ChatScreen(isBot: widget.isBot),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: textFieldWithPrefixSuffuxIconAndHintText(
                          'Type message here....'.tr,

                          fillColor: MyColors.primary,

                          radius: 40,
                          padd: 14,
                          bColor: Colors.transparent,

                          hintColor: Colors.white,
                          prefixIcon: "assets/icons/link.png",
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.asset("assets/icons/send.png", height: 5.h),
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

class ChatScreen extends StatelessWidget {
  final bool isBot;
  ChatScreen({super.key, required this.isBot});

  final List<Map<String, String>> messages = [
    {
      'sender': 'bot',
      'text':
          'Recuerda que los adjetivos van después del sustantivo en español.',
    },
    {
      'sender': 'user',
      'text':
          'Recuerda que los adjetivos van después del sustantivo en español.',
    },
    {
      'sender': 'bot',
      'text':
          'Recuerda que los adjetivos van después del sustantivo en español.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isBot = message['sender'] == 'bot';
        return Align(
          alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: isBot
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 2.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: isBot
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isBot ? Colors.transparent : MyColors.primary1,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(isBot ? 0 : 16),
                            bottomRight: Radius.circular(isBot ? 16 : 0),
                          ),
                        ),
                        child: Text(
                          message['text']!.tr,
                          style: TextStyle(
                            color: isBot ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      text_widget(
                        "10 min AGO",
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
  }
}
