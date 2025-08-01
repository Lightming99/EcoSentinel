import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/models/chat_message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import 'feedback_dialog.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: UNColors.unBlue,
              child: Icon(
                Icons.support_agent,
                size: 18,
                color: UNColors.unWhite,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser ? UNColors.unBlue : UNColors.unWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser
                              ? UNColors.unWhite
                              : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: message.isUser
                              ? UNColors.unWhite.withOpacity(0.7)
                              : UNColors.unGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Feedback buttons for bot messages only
                if (!message.isUser) ...[
                  const SizedBox(height: 8),
                  _buildFeedbackButtons(context),
                ],
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: UNColors.unLightGray,
              child: Icon(
                Icons.person,
                size: 18,
                color: UNColors.unGray,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeedbackButtons(BuildContext context) {
    final hasPositiveFeedback = message.feedback?.isPositive == true;
    final hasNegativeFeedback = message.feedback?.isPositive == false;
    final hasFeedback = message.feedback != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Thumbs up button
        InkWell(
          onTap: hasFeedback ? null : () => _handleThumbsUp(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: hasPositiveFeedback
                  ? UNColors.unGreen.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasPositiveFeedback
                    ? UNColors.unGreen
                    : UNColors.unLightGray,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.thumb_up_outlined,
                  size: 16,
                  color:
                      hasPositiveFeedback ? UNColors.unGreen : UNColors.unGray,
                ),
                if (hasPositiveFeedback) ...[
                  const SizedBox(width: 4),
                  const Text(
                    'Thanks!',
                    style: TextStyle(
                      fontSize: 12,
                      color: UNColors.unGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Thumbs down button
        InkWell(
          onTap: hasFeedback ? null : () => _handleThumbsDown(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: hasNegativeFeedback
                  ? UNColors.unRed.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    hasNegativeFeedback ? UNColors.unRed : UNColors.unLightGray,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.thumb_down_outlined,
                  size: 16,
                  color: hasNegativeFeedback ? UNColors.unRed : UNColors.unGray,
                ),
                if (hasNegativeFeedback) ...[
                  const SizedBox(width: 4),
                  const Text(
                    'Sent',
                    style: TextStyle(
                      fontSize: 12,
                      color: UNColors.unRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleThumbsUp(BuildContext context) {
    context.read<ChatBloc>().add(
          SubmitFeedback(
            messageId: message.id,
            isPositive: true,
          ),
        );
  }

  void _handleThumbsDown(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => FeedbackDialog(
        onSubmit: (comment, categories) {
          context.read<ChatBloc>().add(
                SubmitFeedback(
                  messageId: message.id,
                  isPositive: false,
                  comment: comment,
                  categories: categories,
                ),
              );
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
