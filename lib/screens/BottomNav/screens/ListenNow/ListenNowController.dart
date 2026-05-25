import 'package:apple_music/screens/BottomNav/screens/ListenNow/utils/endpoints.dart';
import 'package:apple_music/screens/BottomNav/screens/ListenNow/utils/feedsparser.dart';
import 'package:apple_music/screens/BottomNav/screens/ListenNow/utils/musicfeedContinuation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../../../../TopLevelController.dart';
import '../../../../models/HomepageFeeds.dart';
import '../../../../models/Section.dart';

class ListenNowController extends GetxController {
  final TopLevelController top = Get.find<TopLevelController>();
  RxList<Section> feeds = <Section>[].obs;

  RxBool isLoading = false.obs;


  RxnString continuation = RxnString();

  @override
  void onInit() {
    super.onInit();

    loadFeeds();
  }


  Future<void> loadFeeds({int retryCount = 0}) async {
    if (feeds.isNotEmpty) return;
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final data = await musicFeeds();

      final HomepageFeeds initial = await parseFeeds(data);

      top.client.value = initial.client;

      feeds.assignAll(initial.sections);

      continuation.value = initial.continuation;

      print("Initial feeds: ${feeds.length}");

      final ic1 = await fetchFeedsContinuation(
        continuationToken: continuation.value ?? "",
        clientContext: initial.client,
      );

      final data2 = await getContinuationItems(data: ic1);

      print("Continuation sections: ${data2.sections.length}");

      feeds.addAll(List<Section>.from(data2.sections));

      feeds.refresh();

      continuation.value = data2.continuation;

      print("Final feeds: ${feeds.length}");

      if (feeds.isEmpty && retryCount < 3) {
        print("Retrying loadFeeds... Attempt ${retryCount + 1}");
        await Future.delayed(const Duration(seconds: 1));

        isLoading.value = false;

        return loadFeeds(retryCount: retryCount + 1);
      }
    } catch (e, s) {
      Fluttertoast.showToast(msg: e.toString());
      if (retryCount < 3) {
        print("Retrying after error... Attempt ${retryCount + 1}");
        await Future.delayed(const Duration(seconds: 1));

        isLoading.value = false;

        return loadFeeds(retryCount: retryCount + 1);
      }
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> loadMore() async {
    print("loadingmore");
    if(isLoading.value)return;
    isLoading.value=true;
    if(continuation.value==null)return;
    final ic1 = await fetchFeedsContinuation(
      continuationToken: continuation.value ?? "",
      clientContext: top.client,
    );

    final data2 = await getContinuationItems(data: ic1);
    feeds.addAll(List<Section>.from(data2.sections));
    feeds.refresh();
    continuation.value = data2.continuation;



  }
}