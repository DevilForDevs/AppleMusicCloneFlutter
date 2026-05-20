import 'package:flutter/material.dart';
import '../../models/SongItem.dart';
class SongViewItem extends StatefulWidget {
  final SongItem item;
  final bool isPlaying;
  final Function(SongItem item) onItemClick;

  const SongViewItem({
    super.key,
    required this.item,
    required this.onItemClick,
    this.isPlaying = false,
  });

  @override
  State<SongViewItem> createState() => _SongViewItemState();
}

class _SongViewItemState extends State<SongViewItem>
    with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onItemClick(widget.item),

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        child: Row(
          children: [

            /// LEFT
            Expanded(
              child: Row(
                children: [

                  /// THUMBNAIL
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      widget.item.thumbnail??"",
                      width: 80,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// TEXTS
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      mainAxisSize: MainAxisSize.min,

                      children: [

                        /// TITLE
                        Text(
                          widget.item.title,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: widget.isPlaying
                                ? const Color(0xFFFF2D55)
                                : Colors.black,

                            fontWeight: widget.isPlaying
                                ? FontWeight.w600
                                : FontWeight.w400,

                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 2),

                        /// ARTIST
                        Text(
                          widget.item.artist??"",

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(
                              60,
                              60,
                              67,
                              0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// RIGHT
            widget.isPlaying
                ? _buildEqualizer()
                : const Icon(
              Icons.menu,
              size: 20,
              color: Color.fromRGBO(
                60,
                60,
                67,
                0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEqualizer() {
    return SizedBox(
      height: 20,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          _animatedBar(_controller1),
          const SizedBox(width: 3),

          _animatedBar(_controller2),
          const SizedBox(width: 3),

          _animatedBar(_controller3),
        ],
      ),
    );
  }

  Widget _animatedBar(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,

      builder: (context, child) {
        final height = 6 + (12 * controller.value);

        return Container(
          width: 3,
          height: height,

          decoration: BoxDecoration(
            color: const Color(0xFFFF2D55),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}