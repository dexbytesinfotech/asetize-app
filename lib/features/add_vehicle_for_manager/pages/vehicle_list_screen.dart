/*
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../widgets/vehicle_card_widget.dart';
import '../bloc/add_vehicle_manager_bloc.dart';
import '../bloc/add_vehicle_manager_event.dart';
import '../bloc/add_vehicle_manager_state.dart';
import '../models/vehicle_list_model.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  late AddVehicleManagerBloc addVehicleManagerBloc;


  @override
  void initState() {
    addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);
    addVehicleManagerBloc.add(GetAllVehicleListEvent(mContext: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return  BlocListener<AddVehicleManagerBloc, AddVehicleManagerState>(
      listener: (context, state) {
        if (state is GetAllVehicleListErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: BlocBuilder<AddVehicleManagerBloc, AddVehicleManagerState>(
        builder: (context, state) {
          if (state is AddVehicleManagerInitialState) {

          }

          return Stack(
            children: [
              addVehicleManagerBloc.vehicleListData.isEmpty ?  SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child:  Text(
                    AppString.noData,
                    textAlign: TextAlign.center,
                    style: appStyles.noDataTextStyle(),
                  ),
                ),
              ):ListView.builder(
                padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addVehicleManagerBloc.vehicleListData.length,
                  itemBuilder: (context,index)
                  {
                    VehicleListData vehicleData =  addVehicleManagerBloc.vehicleListData[index];
                    return VehicleCardWidget(
                      registrationNumber: vehicleData.registrationNumber,
                      ownerName: vehicleData.ownerName,
                      vehicleType: vehicleData.vehicleType,
                    );
                  }),
              if (state is AddVehicleManagerLoadingState )
                WorkplaceWidgets.progressLoader(context)
            ],
          );
        },
      ),
    );
  }
}
*/
