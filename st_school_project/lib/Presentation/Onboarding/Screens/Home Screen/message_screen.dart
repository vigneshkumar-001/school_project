import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/controller/student_home_controller.dart';
import '../../../../Core/Utility/app_color.dart';
import '../../../../Core/Utility/app_loader.dart';
import '../../../../Core/Utility/google_font.dart';

import '../../../../Core/Widgets/custom_container.dart';
import 'package:get/get.dart';

import '../../../../Core/Widgets/date_and_time_convert.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final TextEditingController textController;
  final StudentHomeController controller = Get.put(StudentHomeController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMessageList();
    });
    textController = TextEditingController();
  }

  Future<void> _handleSend() async {
    final text = textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
          content: Row(
            children: const [
              Icon(Icons.error_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Type a message before sending.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    await controller.reactForStudentMessage(text: text);

    textController.clear();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.getMessageList();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        CustomContainer.leftSaitArrow(
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 33),
                    Text(
                      'Today Message to Teacher',
                      style: GoogleFont.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // --- Input Box ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.lightGrey,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color:
                              textController.text.isNotEmpty
                                  ? AppColor.black
                                  : AppColor.lightGrey,
                          width: textController.text.isNotEmpty ? 2 : 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: textController,
                        minLines: 5,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        style: GoogleFont.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Type Here',
                          border: InputBorder.none,
                          counterText: '',
                          suffixIcon:
                              textController.text.isNotEmpty
                                  ? GestureDetector(
                                    onTap: () {
                                      textController.clear();
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12,
                                        right: 8,
                                      ),
                                      child: Text(
                                        'Clear',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.grayop,
                                        ),
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => AppButton.button(
                        loader:
                            controller.isLoading.value
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : null,
                        text: 'Send to Class Teacher',
                        onTap: _handleSend,
                        image: AppImages.rightSaitArrow,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'History',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                    ),
                  ]),
                ),
              ),

              // --- Message History List ---
              Obx(() {
                if (controller.isMsgLoading.value) {
                  return SliverFillRemaining(
                    child: Center(child: AppLoader.circularLoader()),
                  );
                }

                final grouped = controller.groupedMessages;

                if (grouped.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(child: Text("No messages available")),
                  );
                }

                List<Color> colors = [
                  AppColor.lightBlueG1,
                  AppColor.lowLightYellow,
                  AppColor.lowLightNavi,
                  AppColor.lowLightPink,
                ];

                final groups = grouped.entries.toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, groupIndex) {
                    final group = groups[groupIndex];
                    final groupTitle = group.key;
                    final messages = group.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Center(
                            child: Text(
                              groupTitle,
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.grey,
                              ),
                            ),
                          ),

                          // Messages
                          ...messages.asMap().entries.map((entry) {
                            final index = entry.key;
                            final msg = entry.value;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomContainer.messageScreen(
                                sentTo: msg.teacher?.name.toString() ?? '',
                                IconOntap: () {},
                                Reacts: msg.reacted ? 'Teacher Reacts' : null,
                                ImagePath:
                                    msg.reacted ? AppImages.likeImage : null,
                                mainText: msg.text,
                                backRoundColor: colors[index % colors.length],
                                Date:
                                    DateAndTimeConvert.formatDateTime(
                                      msg.createdAt.toIso8601String(),
                                      showTime: false,
                                      showDate: true,
                                    ) ??
                                    "-",
                                time:
                                    DateAndTimeConvert.formatDateTime(
                                      msg.createdAt.toIso8601String(),
                                      showTime: true,
                                      showDate: false,
                                    ) ??
                                    "-",
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }, childCount: groups.length),
                );
              }),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.getMessageList();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer.leftSaitArrow(
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 33),
                  Text(
                    'Today Message to Teacher',
                    style: GoogleFont.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.lightGrey,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color:
                            textController.text.isNotEmpty
                                ? AppColor.black
                                : AppColor.lightGrey,
                        width: textController.text.isNotEmpty ? 2 : 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: textController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: GoogleFont.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 5,
                      maxLines: 10,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Type Here',
                        hintStyle: GoogleFont.inter(
                          color: AppColor.grayop,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        suffixIcon:
                            textController.text.isNotEmpty
                                ? GestureDetector(
                                  onTap: () {
                                    textController.clear();
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      right: 8,
                                    ),
                                    child: Text(
                                      'Clear',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.grayop,
                                      ),
                                    ),
                                  ),
                                )
                                : null,
                      ),
                    ),
                  ),

                  // const SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'You can send 1 message today',
                  //       style: GoogleFont.ibmPlexSans(
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w600,
                  //         color: AppColor.black,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                  Obx(
                    () => AppButton.button(
                      loader:
                          controller.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : null, // Show loader only when submitting
                      text: 'Send to Class Teacher',
                      onTap: _handleSend,
                      image: AppImages.rightSaitArrow,
                      width: double.infinity,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'History',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Obx(() {
                    if (controller.isMsgLoading.value) {
                      return Center(child: AppLoader.circularLoader());
                    }

                    final grouped = controller.groupedMessages;

                    if (grouped.isEmpty) {
                      return const Center(child: Text("No messages available"));
                    }

                    List<Color> colors = [
                      AppColor.lightBlueG1,
                      AppColor.lowLightYellow,
                      AppColor.lowLightNavi,
                      AppColor.lowLightPink,
                    ];

                    final groups = grouped.entries.toList();

                    return RefreshIndicator(
                      onRefresh: () async {
                        await controller.getMessageList();
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: groups.length,
                        itemBuilder: (context, groupIndex) {
                          // now safely access groups
                          final group = groups[groupIndex];
                          final groupTitle = group.key;
                          final messages = group.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section Header
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Center(
                                  child: Text(
                                    groupTitle,
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.grey,
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListView.builder(
                                  itemCount: messages.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final msg = messages[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomContainer.messageScreen(
                                        sentTo:
                                            msg.teacher?.name.toString() ?? '',
                                        IconOntap: () {},
                                        Reacts:
                                            msg.reacted
                                                ? 'Teacher Reacts'
                                                : null,
                                        ImagePath:
                                            msg.reacted
                                                ? AppImages.likeImage
                                                : null,
                                        mainText: msg.text,
                                        backRoundColor:
                                            colors[index % colors.length],
                                        Date:
                                            DateAndTimeConvert.formatDateTime(
                                              msg.createdAt.toIso8601String(),
                                              showTime: false,
                                              showDate: true,
                                            ) ??
                                            "-",
                                        time:
                                            DateAndTimeConvert.formatDateTime(
                                              msg.createdAt.toIso8601String(),
                                              showTime: true,
                                              showDate: false,
                                            ) ??
                                            "-",
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
