import 'package:flutter/material.dart';

typedef RemovedItemBuilder = Widget Function(
    BuildContext context, Animation<double> animation);

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedListState => listKey.currentState;

  void insert(int index, E item) {
    if (item == null) {
      return;
    }

    _items.insert(index, item);
    _animatedListState.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);

    if (removedItem != null) {
      _animatedListState.removeItem(
        index,
        removedItemBuilder,
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
