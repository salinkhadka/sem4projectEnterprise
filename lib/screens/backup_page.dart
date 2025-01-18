class BackUpPage extends StatefulWidget {
  @override
  _BackUpPageState createState() => _BackUpPageState();
}

class _BackUpPageState extends State<BackUpPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // bool isCreating = false;
  late final Lang language;
  @override
  void initState() {
    super.initState();
    language = Provider.of<PreferenceProvider>(context, listen: false).language;
  }