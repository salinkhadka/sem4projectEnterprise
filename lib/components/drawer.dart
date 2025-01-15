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
              ValueListenableBuilder(
                            valueListenable: expanded,
                            builder: (context, value, child) => ExpansionPanelList(
                              expansionCallback: (panelIndex, isExpanded) {
                                expanded.value = isExpanded;
                              },
                              elevation: 0,
                              expandedHeaderPadding: EdgeInsets.zero,
                              children: [
                                ExpansionPanel(
                                    highlightColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    isExpanded: expanded.value,
                                    canTapOnHeader: true,
                                    headerBuilder: (context, isExpanded) => Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SvgPicture.string(
                                              castOutflowIcon,
                                              allowDrawingOutsideViewBox: true,
                                              height: 20,
                                              fit: BoxFit.fill,
                                              width: 20,
                                              color: Configuration().iconColor,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: AdaptiveText(
                                                TextModel("Cash Flow Projection"),
                                                style: _style.copyWith(fontWeight: FontWeight.w500),
                                                textAlign: TextAlign.left,
                                              ),
                                            )
                                          ],
                                        ),
                                    body: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          drawerWidget(
                                            iconString: castOutflowIcon,
                                            title: 'Cash Inflow',
                                            onTap: () => Navigator.pushNamed(context, Routes.budget, arguments: true),
                                          ),
                                          drawerWidget(
                                            iconString: castOutflowIcon,
                                            title: 'Cash Outflow',
                                            onTap: () => Navigator.pushNamed(context, Routes.budget, arguments: false),
                                          ),
                                          drawerWidget(
                                            iconString: castOutflowIcon,
                                            title: 'Projection Vs Actual',
                                            onTap: () => Navigator.pushNamed(context, Routes.projectAndActual, arguments: false),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          // drawerWidget(
                                      //   iconString: dailyLogIcon,
                                      //   title: 'Daily Log',
                                      //   onTap: () => Navigator.pushNamed(
                                      //     context,
                                      //     Routes.dailyLog,
                                      //   ),
                                      // ),
                                      drawerWidget(
                                          icon: Icons.insert_chart_outlined_outlined,
                                          title: 'Report',
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.report,
                                            );
                                          }),
                                      drawerWidget(
                                          icon: Icons.password,
                                          title: 'Change Password',
                                          onTap: () {
                                            Navigator.pushNamed(context, Routes.changePasswordPage);
                                          }),
                                      drawerWidget(
                                        icon: Icons.backup,
                                        title: 'Backup',
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          Routes.backup,
                                        ),
                                      ),
                                      drawerWidget(
                                        title: "Logout",
                                        icon: Icons.logout,
                                        onTap: () {
                                          showDeleteDialog(context, title: "Confirm Logout", deleteButtonText: "Logout", description: "Do you want to Logout? All your data which are not backed up will be lost",
                                              onDeletePress: () async {
                                            await FirebaseAuth.instance.signOut();
                                            SharedPreferenceService().clearPreference();

                                            await AppDatabase().myDatabase.closeAndDeleteDatabase();
                                            Navigator.pushNamedAndRemoveUntil(context, Routes.authenticationPage, (route) => false);
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            // drawerWidget(
                                        //   iconString: dailyLogIcon,
                                        //   title: 'Daily Log',
                                        //   onTap: () => Navigator.pushNamed(
                                        //     context,
                                        //     Routes.dailyLog,
                                        //   ),
                                        // ),
                                        drawerWidget(
                                            icon: Icons.insert_chart_outlined_outlined,
                                            title: 'Report',
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                Routes.report,
                                              );
                                            }),
                                        drawerWidget(
                                            icon: Icons.password,
                                            title: 'Change Password',
                                            onTap: () {
                                              Navigator.pushNamed(context, Routes.changePasswordPage);
                                            }),
                                        drawerWidget(
                                          icon: Icons.backup,
                                          title: 'Backup',
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            Routes.backup,
                                          ),
                                        ),
                                        drawerWidget(
                                          title: "Logout",
                                          icon: Icons.logout,
                                          onTap: () {
                                            showDeleteDialog(context, title: "Confirm Logout", deleteButtonText: "Logout", description: "Do you want to Logout? All your data which are not backed up will be lost",
                                                onDeletePress: () async {
                                              await FirebaseAuth.instance.signOut();
                                              SharedPreferenceService().clearPreference();

                                              await AppDatabase().myDatabase.closeAndDeleteDatabase();
                                              Navigator.pushNamedAndRemoveUntil(context, Routes.authenticationPage, (route) => false);
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
