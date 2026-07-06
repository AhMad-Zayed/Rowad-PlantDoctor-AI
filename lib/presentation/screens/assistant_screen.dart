import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../providers/app_state.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    final appState = Provider.of<AppState>(context, listen: false);
    
    // Send message
    await appState.sendChatMessage(text);
    
    // Auto scroll to bottom
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد الذكي', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'مسح المحادثة',
            onPressed: () {
              Provider.of<AppState>(context, listen: false).clearChat();
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final chatHistory = appState.chatHistory;
          final isChatLoading = appState.isChatLoading;
          
          // Trigger scroll to bottom on new messages
          if (chatHistory.isNotEmpty) {
            _scrollToBottom();
          }

          return Column(
            children: [
              // Chat Messages List
              Expanded(
                child: chatHistory.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.smart_toy_outlined,
                                size: 80,
                                color: theme.colorScheme.primary.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'مرحباً بك في المساعد الذكي!',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'اسألني أي سؤال عن نباتاتك، ريها، تسميدها، أو تشخيص مشاكلها وسأجيبك فوراً.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: chatHistory.length,
                        itemBuilder: (context, index) {
                          final message = chatHistory[index];
                          final part = message.parts.first;
                          final text = part is TextPart ? part.text : '';
                          final isUser = message.role == 'user';

                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isUser 
                                    ? theme.colorScheme.primaryContainer.withOpacity(0.9) 
                                    : theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
                                  bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: isUser 
                                      ? theme.colorScheme.onPrimaryContainer 
                                      : theme.colorScheme.onSurface,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              
              if (isChatLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'جاري التفكير...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Error Message Banner (if any)
              if (appState.errorMessage != null)
                Container(
                  color: theme.colorScheme.errorContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          appState.errorMessage!,
                          style: TextStyle(color: theme.colorScheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),

              // Chat Input Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'اسألني أي شيء عن النباتات...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
