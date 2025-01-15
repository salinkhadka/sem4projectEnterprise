class MyDrawer extends StatefulWidget {
  final HomePageState? homePageState;

  const MyDrawer({Key? key, this.homePageState}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}
class _MyDrawerState extends State<MyDrawer> {
  TextStyle _style = TextStyle(
    fontSize: 15,
  );
  late final PreferenceProvider preferenceProvider;
  final ValueNotifier<bool> expanded = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    preferenceProvider = Provider.of<PreferenceProvider>(context, listen: false);
  }

   @override
    Widget build(BuildContext context) {
      return Container(
        color: const Color(0xffffffff),
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.only(
          left: 25,
        ),
        child: Padding(
          padding: MediaQuery.of(context).viewPadding,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              // SizedBox(
              //   height: 15,
              // ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 100,
                    width: 250,
                    fit: BoxFit.cover,
                  )),
              // SizedBox(
              //   height: 15,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              drawerWidget(
                  iconString: dashboardIcon,
                  title: 'Home',
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
              drawerWidget(
                iconString: accountsIcon,
                title: 'Cash & Bank Balance',
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.account,
                ),
              ),
              drawerWidget(
                iconString: categoriesIcon,
                title: 'Categories',
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.category,
                ),
              ),
