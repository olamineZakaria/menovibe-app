import 'package:equatable/equatable.dart';
import 'agent.dart';

enum MessageType { text, image, audio, resource }

class Message extends Equatable {
  final String id;
  final String content;
  final MessageType type;
  final Agent? sender;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final String? audioUrl;

  const Message({
    required this.id,
    required this.content,
    required this.type,
    this.sender,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.audioUrl,
  });

  Message copyWith({
    String? id,
    String? content,
    MessageType? type,
    Agent? sender,
    bool? isUser,
    DateTime? timestamp,
    String? imageUrl,
    String? audioUrl,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      sender: sender ?? this.sender,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        type,
        sender,
        isUser,
        timestamp,
        imageUrl,
        audioUrl,
      ];
}
