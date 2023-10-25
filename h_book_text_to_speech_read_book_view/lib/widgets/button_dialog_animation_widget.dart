import 'package:flutter/material.dart';
import 'package:h_book/app/extensions/extensions.dart';

class ButtonDialogAnimationWidget extends StatefulWidget {
  const ButtonDialogAnimationWidget(
      {super.key,
      required this.title,
      this.radius = 10.0,
      required this.items,
      required this.sizeDialog,
      required this.onChanged});
  final Widget title;
  final double radius;
  final List<ItemButton> items;
  final Size sizeDialog;
  final ValueChanged<ItemButton> onChanged;

  @override
  State<ButtonDialogAnimationWidget> createState() =>
      _ButtonDialogAnimationWidgetState();
}

class _ButtonDialogAnimationWidgetState
    extends State<ButtonDialogAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: () {
        final RenderBox renderBox =
            key.currentContext!.findRenderObject() as RenderBox;
        final size = renderBox.size;
        Offset position = renderBox.localToGlobal(Offset.zero);
        position = Offset(position.dx, position.dy - size.height / 2 - 8);
        animation.forward();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Material(
            color: Colors.transparent,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: GestureDetector(
                    onTap: () async {
                      animation.reverse().then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  )),
                  Positioned(
                    top: position.dy,
                    right: position.dx,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.radius),
                      child: ScaleTransition(
                          alignment: Alignment.topRight,
                          scale: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          ),
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInCirc,
                            ),
                            child: SizedBox.fromSize(
                              size: widget.sizeDialog,
                              child: PhysicalModel(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(widget.radius),
                                elevation: 1,
                                child: _ListItem(
                                  heightItem: 56,
                                  items: widget.items,
                                  onSelected: (value) {
                                    animation.reverse().then((_) {
                                      widget.onChanged.call(value);
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      child: PhysicalModel(
        color: Colors.white,
        elevation: 0.3,
        borderRadius: BorderRadius.circular(widget.radius),
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
          height: 56,
          width: double.infinity,
          color: Colors.transparent,
          child: widget.title,
        ),
      ),
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}

class ItemButton {
  final bool selected;
  final String value;
  final String key;

  ItemButton({this.selected = false, required this.value, required this.key});
}

class _ListItem extends StatefulWidget {
  const _ListItem(
      {required this.heightItem,
      required this.items,
      required this.onSelected});
  final double heightItem;
  final List<ItemButton> items;
  final ValueChanged<ItemButton> onSelected;

  @override
  State<_ListItem> createState() => __ListItemState();
}

class __ListItemState extends State<_ListItem> {
  late ScrollController _scrollController;
  int _indexSelected = -1;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double jumpTo = _indexSelected * widget.heightItem;
      if (jumpTo > _scrollController.position.maxScrollExtent) {
        jumpTo = _scrollController.position.maxScrollExtent;
      }
      _scrollController.jumpTo(jumpTo);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      if (item.selected) {
        _indexSelected = i;
      }
      items.add(GestureDetector(
        onTap: item.selected ? null : () => widget.onSelected(item),
        child: Container(
          height: widget.heightItem,
          color: i == _indexSelected ? Colors.amber : Colors.white,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            item.value,
            style: context.appTextTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(children: items),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
