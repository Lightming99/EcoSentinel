import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/chat_api_services.dart';
import '../../../shared/models/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatApiService _apiService = ChatApiService();
  final List<ChatMessage> _messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<ClearChat>(_onClearChat);
    on<SubmitFeedback>(_onSubmitFeedback);
  }

  Future<void> _onLoadChatHistory(
      LoadChatHistory event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      // Chat history loading is commented out since getChatHistory was removed
      // If you implement a custom chat history endpoint, uncomment and modify:
      // final messages = await _apiService.getChatHistory();
      // _messages.clear();
      // _messages.addAll(messages);

      // For now, just emit the current messages
      emit(ChatLoaded(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    // Add user message immediately
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    emit(ChatLoaded(messages: List.from(_messages), isTyping: true));

    try {
      // Send to backend and get response(s) - now returns List<ChatMessage>
      final responseMessages = await _apiService.sendMessage(event.message);

      // Add all response messages from Rasa
      for (ChatMessage responseMessage in responseMessages) {
        _messages.add(responseMessage);
      }

      emit(ChatLoaded(messages: List.from(_messages)));
    } catch (e) {
      // Add error message
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Sorry, I encountered an error. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
      emit(ChatLoaded(messages: List.from(_messages)));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    _messages.add(event.message);
    emit(ChatLoaded(messages: List.from(_messages)));
  }

  void _onClearChat(ClearChat event, Emitter<ChatState> emit) {
    _messages.clear();
    emit(const ChatLoaded(messages: []));
  }

  Future<void> _onSubmitFeedback(
      SubmitFeedback event, Emitter<ChatState> emit) async {
    try {
      // Find the message and update it with feedback
      final messageIndex =
          _messages.indexWhere((msg) => msg.id == event.messageId);
      if (messageIndex != -1) {
        final feedback = MessageFeedback(
          isPositive: event.isPositive,
          comment: event.comment,
          categories: event.categories,
          timestamp: DateTime.now(),
        );

        // Update the message with feedback
        _messages[messageIndex] =
            _messages[messageIndex].copyWith(feedback: feedback);

        // Send feedback to backend for Neo4j storage
        await _apiService.submitFeedback(
          messageId: event.messageId,
          messageText: _messages[messageIndex].text,
          isPositive: event.isPositive,
          comment: event.comment,
          categories: event.categories,
        );

        emit(ChatLoaded(messages: List.from(_messages)));
      }
    } catch (e) {
      // Handle error silently or show a snackbar
      print('Error submitting feedback: $e');
    }
  }
}
