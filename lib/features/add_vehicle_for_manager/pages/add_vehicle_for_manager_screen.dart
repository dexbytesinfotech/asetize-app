import 'dart:async';
import 'package:asetize/features/add_vehicle_for_manager/pages/search_house_number_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_global_components/network_status_alert_view.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../../widgets/common_search_bar.dart';
import '../../find_helper/bloc/find_helper_bloc.dart';
import '../../find_helper/models/find_helper_model.dart';
import '../../find_helper/widgets/common_filter_bottomsheet.dart';
import '../../find_helper/widgets/helper_card_widget.dart';
import '../bloc/add_vehicle_manager_bloc.dart';
import '../bloc/add_vehicle_manager_event.dart';
import '../bloc/add_vehicle_manager_state.dart';
import '../models/add_vehicle_for_manager_model.dart';
import '../widgets/block_card_widget.dart';

class AddVehicleForManager extends StatefulWidget {
  const AddVehicleForManager({super.key});

  @override
  State<AddVehicleForManager> createState() => _AddVehicleForManagerState();
}

class _AddVehicleForManagerState extends State<AddVehicleForManager> {
  TextEditingController controller = TextEditingController();
  List<Blocks> searchedBlocks = [];
  late AddVehicleManagerBloc addVehicleManagerBloc;
  late StreamSubscription<AddVehicleManagerState> _subscription;
   bool isShowLoader = true;

  void filter(String searchText) {
    List<Blocks> results = [];
    if (searchText.isEmpty) {
      results = addVehicleManagerBloc.addVehicleManagerData!.blocks!;
    } else {
      results = addVehicleManagerBloc.addVehicleManagerData!.blocks!
          .where((block) =>
          block.blockName!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    setState(() {
      searchedBlocks = results;
    });
  }

  Widget searchBar() {
    return CommonSearchBar(
      controller: controller,
      hintText: AppString.searchBlockSmall,
      onChangeTextCallBack:(searchText) {
        filter(searchText);
      },
      onClickCrossCallBack: () {
      controller.clear();
      FocusScope.of(context).unfocus();
      if (controller.text.isEmpty) {
        searchedBlocks = addVehicleManagerBloc.addVehicleManagerData!.blocks!;
      }
    },
    );
  }


  void apiCalling() {
    if (addVehicleManagerBloc.addVehicleManagerData == null) {
      isShowLoader = true;
      addVehicleManagerBloc.add(OnGetBlockListEvent(mContext: context));
    } else {
      isShowLoader = false;
      setState(() {
        searchedBlocks = addVehicleManagerBloc.addVehicleManagerData!.blocks!;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    apiCalling();

    // Listen to the bloc state changes and store the subscription
    _subscription = addVehicleManagerBloc.stream.listen((state) {
      if (state is AddVehicleManagerDoneState) {
        if (mounted) { // Ensure the widget is still in the tree
          setState(() {
            searchedBlocks = addVehicleManagerBloc.addVehicleManagerData!.blocks!;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel the subscription to prevent memory leaks
    controller.dispose(); // Dispose of the text controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget noBlockList(){
      return SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppString.noBlock,
              style: appTextStyle.noDataTextStyle(),
            )
          ],
        ),
      );
    }

    Widget blockList (){
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 5),
          physics: const BouncingScrollPhysics(),
          itemCount: searchedBlocks.length,
          itemBuilder: (context, index) {
            final block = searchedBlocks[index];
            return BlockCardView(
              title: block.blockName ?? "",
              onTap: () {
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    widget:
                        SearchHouseNumberScreen(
                          housesList: block.houses ?? [],
                        ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: false,
        isListScrollingNeed: true,
        appBar: const CommonAppBar(
          title: AppString.searchBlock,
          icon: WorkplaceIcons.backArrow,
        ),
        containChild:
        BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
          listener: (context, state) {
            if (state is AddVehicleManagerErrorState) {

              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
          },
          child: BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
            builder: (context, state) {
              if (state is AddVehicleManagerInitialState) {
                addVehicleManagerBloc
                    .add(OnGetBlockListEvent(mContext: context));
              }

              return Stack(
                children: [
                  Column(
                    children: [
                      searchBar(),
                      if (state is AddVehicleManagerDoneState &&
                          searchedBlocks.isEmpty)
                        noBlockList()
                      else
                        blockList()
                    ],
                  ),
                  if (state is AddVehicleManagerLoadingState && isShowLoader)
                    Center(
                      child: WorkplaceWidgets.progressLoader(context),
                    ),
                  NetworkStatusAlertView(onReconnect: (){
                    addVehicleManagerBloc.add(OnGetBlockListEvent(mContext: context));
                  },)
                ],
              );
            },
          ),
        ));
  }
}
