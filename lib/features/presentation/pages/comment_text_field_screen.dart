import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:http/http.dart' as http;
import '../../../imports.dart';

class CommentTextFieldScreen extends StatefulWidget {
  const CommentTextFieldScreen({super.key});

  @override
  State<CommentTextFieldScreen> createState() => _CommentTextFieldScreenState();
}

class _CommentTextFieldScreenState extends State<CommentTextFieldScreen> {
  final MentionTagTextEditingController _controller =
      MentionTagTextEditingController();
  String? mentionValue;
  List searchResults = []; // data add when API call

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  MentionTagTextField mentionField() {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none);
    return MentionTagTextField(
      controller: _controller,
      onMention: onMention,
      mentionTagDecoration: MentionTagDecoration(
          mentionStart: ['@', '#'],
          mentionBreak: ' ',
          allowDecrement: false,
          allowEmbedding: false,
          showMentionStartSymbol: true,
          maxWords: null,
          mentionTextStyle: TextStyle(
              color: Colors.blue, backgroundColor: Colors.blue.shade50)),
      decoration: InputDecoration(
          hintText: 'Post your reply',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: border,
          focusedBorder: border,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          suffixIcon: InkWell(
              onTap: () {
                debugPrint('Post your reply');
              },
              child: const Icon(
                Icons.send,
                color: Colors.blueAccent,
              ))),
    );
  }

  Widget suggestions() {
    if (searchResults.isEmpty) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Flexible(
        fit: FlexFit.loose,
        child: ListView.builder(
            //List of all user with their profile photo
            itemCount: searchResults.length,
            reverse: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _controller.addMention(
                    label:
                        "${searchResults[index]['firstName']} ${searchResults[index]['lastName']}",
                    data: User(
                        id: searchResults[index]['id'],
                        name:
                            "${searchResults[index]['firstName']} ${searchResults[index]['lastName']}"),

                    // stylingWidget: _controller.mentions.length == 1
                    //     ?
                    // MyCustomTag(controller: _controller, text: "${searchResults[index]['firstName']} ${searchResults[index]['lastName']}")
                    //
                    //     : null
                  );
                  mentionValue = null;
                  setState(() {});
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(searchResults[index]['image']),
                  ),
                  title: Text(
                      "${searchResults[index]['firstName']} ${searchResults[index]['lastName']}"),
                  subtitle: Text(
                    "@${searchResults[index]['username']}",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ),
              );
            }));
  }

  Future<void> onMention(String? value) async {
    mentionValue = value;
    searchResults.clear();
    setState(() {});
    if (value == null) return;
    final searchInput = value.substring(1);
    searchResults = await fetchSuggestionsFromServer(searchInput) ?? [];
    setState(() {});
  }

  Future<List?> fetchSuggestionsFromServer(String input) async {
    //Future function call API and return list
    try {
      final response = await http
          .get(Uri.parse('http://dummyjson.com/users/search?q=$input'));
      return jsonDecode(response.body)['users'];
      // final response = await http.get(Uri.parse('https://cms-api.dexbytes.in/api/user'),  headers: {
      //   'Content-Type': 'application/json',
      //   'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDJiMDExMjdlNmEwMWU3MjQ0MTE0M2E5OGYzOGRjNTg0YTI5ZjFhYmQ2NDcyM2IzOWE4OWQ4MmVlNDFhZTBmODFmMzljMjRkZGVmMDk2N2EiLCJpYXQiOjE3MjA2MTE2OTIuMDUwNjM1LCJuYmYiOjE3MjA2MTE2OTIuMDUwNjM4LCJleHAiOjE3NTIxNDc2OTIuMDQ1NTUxLCJzdWIiOiIxMiIsInNjb3BlcyI6WyJNZW1iZXIiXX0.Kxs7eDhAqgyDY4nOIzl_Xsg3e016r2AN2rYotoYnQpcT5v8zY2oWIVaH5zQxYBzHJxkHAGC7k5JeXc8Bbm8TWVuwuF6-8pvqzhDs91iq7qOBzF77QDd21Mh8h2iApGhvdmzZ1yMRYeiH58US1EZrfJQWPKkK-MOVoZYljrqEJFAfRPoWByyQ9XczM8UvlR8nErCixcAWR88iIbCuQtN7T_MiMG7LOv4uQQJyo4fndVV74IsMKRvLHJo9tSVcCNFUIZLsvH2mTL1WlB_VBtHZbWQNdh9QlWRp90dhTwFncrbvS0-qqO9u7LV6xSS8oxTt3tPL7s1X922sDF8bfqiUZGE8hFYBM3yiwo09-9aXpPztTUWwz3f-IjaKctTyXuC71L3ei02g9PWXD9QgNeuznYahaMoMNoa9Vn9ZyIYjI9_bWb_agJMyqFdbqBroxn0FK1BnmepMkkZSUTjaGHqPLisjRP0lwD9PND6hZuDdtXRsCfNBJDD4dT3AjT2BiyuqRl-Ln0o1MqG-pyLmEyZOZZd9p4UMMAbXeyg4R2tHGvD3VKrPoE6eSO5sraHYxg3PeIAU0Tq-SoC95u6ikT9Uhef2MT6curU4HTlvsKSFXByzTZwcpdytx33GnE7-gShyuKTujgTPGN4gdiwTkUiCyNz3ex_WQb4HSAudNop-WMA',
      // },);
      // if (response.statusCode == 200) {
      //   return json.decode(response.body)['data'];
      //
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (mentionValue != null)
                suggestions()
              else
                const Expanded(child: SizedBox()),
              const SizedBox(
                height: 16,
              ),
              mentionField(),
            ],
          ),
        ),
      ),
    );
  }
}
// class MyCustomTag extends StatelessWidget {
//   const MyCustomTag({
//     super.key,
//     required this.controller,
//     required this.text,
//   });
//
//   final MentionTagTextEditingController controller;
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
//       decoration: BoxDecoration(
//           color: Colors.yellow.shade50,
//           borderRadius: const BorderRadius.all(Radius.circular(50))),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(text,
//               style: TextStyle(
//                 color: Colors.yellow.shade700,
//               )),
//           const SizedBox(
//             width: 6.0,
//           ),
//           GestureDetector(
//             onTap: () {
//               controller.remove(index: 1);
//               print(controller.text);
//             },
//             child: Icon(
//               Icons.close,
//               size: 12,
//               color: Colors.yellow.shade700,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class User {
//   const User({required this.id, required this.name});
//   final int id;
//   final String name;
// }
