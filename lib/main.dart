// Packages:
import './_inner_packages.dart';
import './_external_packages.dart';

// Screens:
import './screens/_screens.dart';

// Models:
import './models/_models.dart';

void main() {
  // Disables the Landscape mode:
  // WidgetsFlutterBinding.ensureInitialized(); // Without this it might not work in some devices:
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // With one single provider:
  // runApp(ChangeNotifierProvider(
  //   create: (context) => AppData(),
  //   // child: MyApp(),
  //   child: InitialSplashScreen(),
  // ));

  // With several providers:
  runApp(MultiProvider(
    providers: [
      // Route Observer:
      RouteObserverProvider(),

      // Config about the app:
      ChangeNotifierProvider<AppData>(
        create: (context) => AppData(),
      ),

      // Data related to the Product objects: (sqlite DB)
      ChangeNotifierProvider<ProductsData>(
        create: (context) => ProductsData(),
      ),

      // Data related to the FavoriteProduct objects: (sqlite DB)
      ChangeNotifierProvider<FavoriteProductsData>(
        create: (context) => FavoriteProductsData(),
      ),

      // Data related to the CartItem objects: (sqlite DB)
      ChangeNotifierProvider<CartItemsData>(
        create: (context) => CartItemsData(),
      ),
    ],
    child: InitialSplashScreen(),
  ));
}

class InitialSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String appLogo = 'assets/images/shoppy_logo_1024_x_1024.png';

    return MaterialApp(
      home: SplashScreen(
        seconds: 2,
        navigateAfterSeconds: MyApp(),
        gradientBackground: LinearGradient(colors: [
          Color(0xFFFFFEF1),
          Color(0xFFFFFEF1),
          // Colors.white70,
        ]),
        image: Image.asset(
          appLogo,
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(),
        title: Text(
          'Reymillenium\nProductions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Luminari',
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        loadingText: Text(
          'Version 1.0.1',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        photoSize: 180,
        onClick: () {},
        loaderColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    ThemeData currentThemeData = appData.currentThemeData;
    Map currentThemeFont = appData.currentThemeFont;
    final String appTitle = 'Shoppy';

    return MaterialApp(
      title: appTitle,
      // theme: currentThemeData,
      theme: currentThemeData.copyWith(
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        textTheme: currentThemeData.textTheme.copyWith(
          headline6: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: currentThemeFont['fontFamily'],
            // color: currentThemeData.textTheme.headline6.color,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1),
            fontFamily: currentThemeFont['fontFamily'],
          ),
          bodyText2: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1),
            fontFamily: currentThemeFont['fontFamily'],
          ),
        ),
        appBarTheme: currentThemeData.appBarTheme.copyWith(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  // color: Colors.yellow,
                ),
              ),
        ),
      ),
      // navigatorObservers: [routeObserver],
      // navigatorObservers: <RouteObserver<ModalRoute<void>>>[routeObserver],
      navigatorObservers: [RouteObserverProvider.of(context)],
      debugShowCheckedModeBanner: false,
      // home: ProductIndexScreen(appTitle: appTitle),
      initialRoute: ProductIndexScreen.screenId,

      // Named Routes with none or few arguments:
      routes: {
        ProductIndexScreen.screenId: (context) => ProductIndexScreen(appTitle: appTitle),
        CartItemIndexScreen.screenId: (context) => CartItemIndexScreen(appTitle: 'Cart'),
        FavoritesScreen.screenId: (context) => FavoritesScreen(),
        ProductNewScreen.screenId: (context) => ProductNewScreen(),
        // ProductEditScreen.screenId: (context) => ProductEditScreen(),
        // FavoritesScreen.screenId: (context) => FavoritesScreen(),
      },

      // Named Routes with extra arguments:
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map;

        switch (settings.name) {
          case ProductShowScreen.screenId:
            return MaterialPageRoute(
              builder: (context) {
                return ProductShowScreen(product: args['product']);
              },
            );
            break;

          default:
            return MaterialPageRoute(
              builder: (context) {
                return UnknownScreen(
                  appTitle: 'Unknown screen',
                );
              },
            );
            break;
        }
      },

      // 404 screen:
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return UnknownScreen(
              appTitle: 'Unknown screen',
            );
          },
        );
      },
    );
  }
}
