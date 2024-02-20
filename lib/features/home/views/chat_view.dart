import 'package:empowher/core/core.dart';
import 'package:empowher/features/home/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  List<Content> content = [];
  late final TextEditingController chatController;
  bool isLoading = false;

  Future<void> getResponse() async {
    if (chatController.text.isEmpty) return;
    final prompt = chatController.text;
    setState(() {
      content.insert(0, Content(parts: [Parts(text: prompt)], role: 'user'));
      chatController.clear();
      isLoading = true;
    });
    ref
        .read(geminiProvider)
        .text(prompt)
        .then((value) => setState(() {
              content.insert(0, Content(parts: [Parts(text: value?.output ?? 'Some error occurred. Please try again')], role: 'gemini'));
              isLoading = false;
            }))
        .catchError((e) => setState(() {
              content.add(Content(parts: [Parts(text: e.toString())], role: 'gemini'));
              isLoading = false;
            }));
  }

  @override
  void initState() {
    super.initState();
    chatController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: content.length,
                itemBuilder: (context, index) {
                  return ChatCard(text: content[index].parts?[0].text ?? '', role: content[index].role!);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController,
                      onSubmitted: (_) => getResponse,
                      decoration: InputDecoration(
                        hintText: 'Type your message here...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                        suffixIcon: IconButton(
                          onPressed: getResponse,
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isLoading)
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(15),
            child: const CircularProgressIndicator(),
          )
      ],
    );
  }
}
