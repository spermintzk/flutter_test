import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/components/NewsPage/NewsTab1.dart';
import 'package:project1/controller/RequestController.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  late TabController _tabController;
  late PageController _pageController;
  int _currentPageIndex = 0;

  final GetCategoryController categoryController =
      Get.put(GetCategoryController());
  final GetNewsController newsController = Get.put(GetNewsController());

  late List<GetNewsController?> tabControllers;

  _NewsPageState() {
    tabControllers =
        List.generate(categoryController.request.length, (_) => null);
  }

  @override
  void initState() {
    super.initState();

    if (categoryController.request.isNotEmpty) {
      _initializeControllers();
    } else {
      ever(
        categoryController.request,
        (_) {
          if (categoryController.request.isNotEmpty) {
            _initializeControllers();
          }
        },
      );
    }
  }

  void _initializeControllers() {
    if (mounted) {
      _tabController = TabController(
        length: categoryController.request.length,
        vsync: this,
      );
      _pageController = PageController();

      tabControllers = List.generate(
          categoryController.request.length, (_) => GetNewsController());

      _loadTabData(_currentPageIndex);
    }
  }

  void _loadTabData(int index) async {
    if (!mounted) return;

    final selectedCategoryId = categoryController.request[index].id.toString();
    final currentTabController = tabControllers[index] ??= GetNewsController();

    if (!currentTabController.selectedCategoryIds
        .containsKey(selectedCategoryId)) {
      currentTabController.selectedCategoryIds[selectedCategoryId] = true;
      await currentTabController.getNews(selectedCategoryId);
    }

    if (mounted) {
      setState(() {
        _currentPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Мэдээ. мэдээлэл",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Obx(
        () => categoryController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    onTap: (index) {
                      _pageController.jumpToPage(index);
                      _loadTabData(index);
                    },
                    tabs: categoryController.request
                        .map(
                          (category) => Tab(
                            text: category.categoryName,
                          ),
                        )
                        .toList(),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        _tabController.animateTo(index);
                        _loadTabData(index);
                      },
                      itemCount: categoryController.request.length,
                      itemBuilder: (context, index) {
                        return NewsTab1(
                          categoryId:
                              categoryController.request[index].id.toString(),
                          tabController: tabControllers[index]!,
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
