import 'package:equatable/equatable.dart';
import '../../../shared/models/chat_message.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatHistory extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;

  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiveMessage extends ChatEvent {
  final ChatMessage message;

  const ReceiveMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ClearChat extends ChatEvent {}

class SubmitFeedback extends ChatEvent {
  final String messageId;
  final bool isPositive;
  final String? comment;
  final List<String>? categories;

  const SubmitFeedback({
    required this.messageId,
    required this.isPositive,
    this.comment,
    this.categories,
  });

  @override
  List<Object?> get props => [messageId, isPositive, comment, categories];
}
