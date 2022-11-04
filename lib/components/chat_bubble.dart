import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:devhub/components/text_time.dart';
import 'package:devhub/models/enum/message_type.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubbleWidget extends StatefulWidget {
  final String? message;
  final MessageType? type;
  final Timestamp? time;
  final bool? isMe;

  ChatBubbleWidget({
    @required this.message,
    @required this.time,
    @required this.isMe,
    @required this.type,
  });

  @override
  _ChatBubbleWidgetState createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  Color? chatBubbleColor() {
    if (widget.isMe!) {
      return Theme.of(context).colorScheme.primary;
    } else {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.grey[800];
      } else {
        return Color.fromARGB(255, 172, 172, 172);
      }
    }
  }

  Color? chatBubbleReplyColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Color.fromARGB(255, 92, 92, 92);
    } else {
      return Color.fromARGB(255, 193, 192, 192);
    }
  }

  @override
  Widget build(BuildContext context) {
    final align =
        widget.isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = widget.isMe!
        ? const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          );
    return Container(

      // color: Colors.red,
      width: double.minPositive,
      
      child: Column(
        crossAxisAlignment: align,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              color: widget.isMe! ?chatBubbleColor() : chatBubbleReplyColor(),
            ),
            // elevation: 0.0,
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(5.0),
            alignment:
                widget.isMe! ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.all(widget.type == MessageType.TEXT ? 10 : 0),
                  child: widget.type == MessageType.TEXT
                      ? Text(
                          widget.message!,
                          style: TextStyle(
                            color: widget.isMe!
                                ? Color.fromARGB(255, 0, 0, 0)
                                : Theme.of(context).textTheme.headline6!.color,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: "${widget.message}",
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.contain,
                        ),
                ),
              ],
            ),
          ),
          Padding(
            padding: widget.isMe!
                ? const EdgeInsets.only(
                    right: 10.0,
                    bottom: 10.0,
                  )
                : const EdgeInsets.only(
                    left: 10.0,
                    bottom: 10.0,
                  ),
            child: TextTime(
              child: Text(
                timeago.format(widget.time!.toDate()),
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6!.color,
                  fontSize: 10.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
