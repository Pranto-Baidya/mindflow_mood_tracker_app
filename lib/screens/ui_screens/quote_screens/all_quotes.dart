import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/l10n/app_localizations.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/model/quote_model.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/internet_connection_provider/internet_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/quotes_provider/quotes_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/theme_provider/theme_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/animated_container/animated_container_widget.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:provider/provider.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final net = context.read<InternetProvider>();
      net.addListener((){
        if(net.isConnected){
          ToastMsg.successToast(AppLocalizations.of(context)!.internet_restored_toast);
        }
      });
    });
  }

  Future<void> toggleFavorite(QuoteModel quote) async {
    final provider = context.read<QuoteProvider>();
    final isFav = provider.allQuotes.any((q) => q.content == quote.content);

    if (isFav) {
      await provider.removeFromFavorite(quote);
      ToastMsg.errorToast(AppLocalizations.of(context)!.removed_from_favorites_toast);
    } else {
      await provider.addToFavorite(quote);
      ToastMsg.successToast(AppLocalizations.of(context)!.added_to_favorites_toast);
    }
    await provider.getFavoriteQuotes();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.read_quotes_title, style: theme.textTheme.headlineMedium),
          iconTheme: theme.iconTheme,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: theme.scaffoldBackgroundColor,
          ),
          bottom: TabBar(
            indicatorColor: theme.colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicatorWeight: 3,
            dividerHeight: 3,
            physics: const BouncingScrollPhysics(),
            tabAlignment: TabAlignment.fill,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.get_a_quote_tab),
              Tab(text: AppLocalizations.of(context)!.favorites_tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _randomQuoteList(theme),
                  SizedBox(height: 20.h),
                  context.watch<InternetProvider>().isConnected?ElevatedButton(
                    onPressed: () async {
                      await context.read<QuoteProvider>().getARandomQuote();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(200.w, 50.h),
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: context.watch<QuoteProvider>().isLoading
                        ? AppLoader.lightThemeLoader()
                        : Text(
                      AppLocalizations.of(context)!.generate_random_quote_button,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ):SizedBox()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: favoriteQuoteList(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _randomQuoteList(ThemeData theme) {
    bool isDark = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;
    return Consumer<InternetProvider>(
        builder: (context,net,_) {
          return net.isConnected?Consumer<QuoteProvider>(
            builder: (context, data, _) {
              final favorites = data.allQuotes;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.randomQuote.length,
                itemBuilder: (context, index) {
                  final quote = data.randomQuote[index];
                  final isFavorite =
                  favorites.any((q) => q.content == quote.content);

                  return Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.generated_random_quote_text,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 22,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: IconButton(
                                onPressed: () => toggleFavorite(quote),
                                icon: isFavorite
                                    ? Icon(Icons.favorite,
                                    color: theme.colorScheme.primary)
                                    : Icon(Icons.favorite_border,
                                    color: theme.colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(quote.content, style: theme.textTheme.titleMedium),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.author_label,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(quote.author, style: theme.textTheme.titleSmall),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.length_label,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text('${quote.length} ${AppLocalizations.of(context)!.characters_label}',
                                style: theme.textTheme.titleSmall),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ):Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150.h,),
                  isDark? Lottie.asset('assets/internet_dark.json', width: 150.w, height: 150.h):Lottie.asset('assets/internet_light.json', width: 150.w, height: 150.h),
                  SizedBox(height: 20.h),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(AppLocalizations.of(context)!.no_internet_message, style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(AppLocalizations.of(context)!.view_saved_quotes_in_favorites, style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget favoriteQuoteList(ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Expanded(
          child: Consumer<QuoteProvider>(
            builder: (context, data, _) {
              final favorites = data.allQuotes;

              if (favorites.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.no_favorite_quotes_message,
                    style: theme.textTheme.titleMedium,
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final quote = favorites[index];
                  final isFavorite = favorites.any((q) => q.content == quote.content);
                  return AnimatedMoodContainerWidget(
                    index: index,
                    offset: Offset(0, 0.2),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border(bottom: BorderSide(color: theme.colorScheme.primary,width: 5))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.favorite_quote_label} #${index + 1}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 22,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: IconButton(
                                  onPressed: () => toggleFavorite(quote),
                                  icon: isFavorite
                                      ? Icon(Icons.favorite,
                                      color: theme.colorScheme.primary)
                                      : Icon(Icons.favorite_border,
                                      color: theme.colorScheme.primary),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(quote.content, style: theme.textTheme.titleMedium),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.author_label,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(quote.author, style: theme.textTheme.titleSmall),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.length_label,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text('${quote.length} ${AppLocalizations.of(context)!.characters_label}',
                                  style: theme.textTheme.titleSmall),
                            ],
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
      ],
    );
  }
}