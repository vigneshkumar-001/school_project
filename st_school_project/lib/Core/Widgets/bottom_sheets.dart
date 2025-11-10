import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';

import '../../Presentation/Admssion/Controller/admission_controller.dart';

class CommonPickerBottomSheet<T> {
  static void show<T>({
    required BuildContext context,
    required String title,
    required RxList<T> rxItems,
    required String Function(T item) displayText,
    String Function(T item)? subtitleText,
    required ValueChanged<T> onSelect,
    RxBool? isLoading, // optional external loading flag
  }) {
    final RxString searchQuery = ''.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                // Search field
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged:
                        (value) =>
                            searchQuery.value = value.trim().toLowerCase(),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Obx(() {
                    final list = rxItems;
                    final loading = isLoading?.value ?? false;

                    if (loading) {
                      return Center(child: AppLoader.circularLoader());
                    }

                    if (list.isEmpty) {
                      return const Center(child: Text('No matching results'));
                    }

                    final filtered =
                        list.where((item) {
                          final text = displayText(item).toLowerCase();
                          final query = searchQuery.value;
                          return text.contains(query);
                        }).toList();

                    if (filtered.isEmpty) {
                      return const Center(child: Text('No matching results'));
                    }

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder:
                          (_, __) =>
                              Divider(height: 1, color: Colors.grey[300]),
                      itemBuilder: (_, index) {
                        final item = filtered[index];
                        return ListTile(
                          title: Text(displayText(item)),
                          subtitle:
                              subtitleText != null
                                  ? Text(subtitleText(item))
                                  : null,
                          onTap: () {
                            onSelect(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
