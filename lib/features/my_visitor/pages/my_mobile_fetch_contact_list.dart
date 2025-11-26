import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class MyMobileFetchContactList extends StatefulWidget {
  final Function(List<ContactInfo>) onContactsSelected;
  const MyMobileFetchContactList({super.key, required this.onContactsSelected});

  @override
  MyMobileFetchContactListState createState() => MyMobileFetchContactListState();
}

class MyMobileFetchContactListState extends State<MyMobileFetchContactList> {
  List<ContactInfo> _contacts = [];
  List<ContactInfo> _filteredContacts = [];
  List<ContactInfo> selectedContacts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _fetchContacts() async {
    try {
      Iterable<ContactInfo> contacts = await FlutterContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
        orderByGivenName: true,
        iOSLocalizedLabels: true,
        androidLocalizedLabels: true,
      );
      List<ContactInfo> validContacts = contacts.where((c) => c.identifier != null).toList();
      setState(() {
        _contacts = validContacts;
        _filteredContacts = validContacts;
        _isLoading = false;
      });
      for (var contact in _contacts) {
        print('Contact: ${contact.displayName ?? 'No Name'}, Phones: ${contact.phones?.map((p) => p.value).toList() ?? []}, Identifier: ${contact.identifier}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      WorkplaceWidgets.errorSnackBar(context, '${AppString.errorFetchingContacts} $e');
    }
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        final name = contact.displayName?.toLowerCase() ?? '';
        final phone = contact.phones?.isNotEmpty == true
            ? contact.phones!.first.value?.toLowerCase() ?? ''
            : '';
        return name.contains(query) || phone.contains(query);
      }).toList();
      // print('Filtered contacts: ${_filteredContacts.length}');
    });
  }

  void _toggleSelection(ContactInfo contact) {
    setState(() {
      if (selectedContacts.contains(contact)) {
        selectedContacts.remove(contact);
      } else {
        selectedContacts.add(contact);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget searchVisitorsContacts(){
      return Container(
        margin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        child: TextField(
          controller: _searchController,
          style: appTextStyle.appSubTitleStyle(
              fontWeight: FontWeight.normal, fontSize: 16),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: AppString.searchVisitorsContacts,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                FocusScope.of(context).unfocus();
                _filterContacts(); // reset filter
              },
            )
                : null,
            contentPadding: const EdgeInsets.only(top: 5),
          ),
        ),
      );
    }
    Widget mobileContactsList(){
      return Expanded(
        child: _isLoading
            ?  Center(child:WorkplaceWidgets.progressLoader(
          context,
        ),)
            : _filteredContacts.isEmpty
            ? const Center(child: Text(AppString.noContactsFound))
            : ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = _filteredContacts[index];
            final isSelected = selectedContacts.contains(contact);
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(contact.displayName ?? 'No Name'),
              subtitle: Text(contact.phones?.isNotEmpty == true
                  ? contact.phones!.first.value ?? 'No Phone'
                  : 'No Phone'),
              trailing: Checkbox(
                value: isSelected,
                activeColor: AppColors.appBlueColor,
                checkColor: Colors.white,
                onChanged: (value) {
                  _toggleSelection(contact);
                },
              ),
              onTap: () {
                _toggleSelection(contact);
              },
            );
          },
        ),
      );
    }
    return ContainerFirst(
      contextCurrentView: context,
      resizeToAvoidBottomInset: false,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: CommonAppBar(
        title: AppString.visitorsContacts,
        icon: WorkplaceIcons.backArrow,
        action: TextButton(
          onPressed: selectedContacts.isNotEmpty
              ? () {
            widget.onContactsSelected(selectedContacts);
            Navigator.pop(context);
          }
              : null,
          child: Text(
            '${AppString.done} (${selectedContacts.length})',
            style: TextStyle(
              fontSize: 16,
              color: selectedContacts.isNotEmpty ? AppColors.appBlueColor : Colors.grey,
            ),
          ),
        ),
      ),
      containChild: Padding(
        padding: const EdgeInsets.only(left: 5,right: 5),
        child: Column(
          children: [
            searchVisitorsContacts(),
            mobileContactsList()
          ],
        ),
      ),
    );
  }
}
