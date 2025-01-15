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
