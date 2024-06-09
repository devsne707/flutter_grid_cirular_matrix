import 'package:flutter/material.dart';

class SliverHome extends StatelessWidget {
  const SliverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
    slivers: <Widget>[
      //2
      SliverAppBar(
        pinned: true,
        floating: true,
        snap: true,
        expandedHeight: 250.0,

        flexibleSpace: FlexibleSpaceBar(
          title:DefaultTabController(length: 5, child:TabBar(tabs: List.generate(5, (i)=> Tab(text: i.toString(),)))),
          background: DecoratedBox(decoration: BoxDecoration(color: Colors.blue))
        ),
      ),
      //3
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, int index) {
            return ListTile(
              leading: Container(
                  padding: EdgeInsets.all(8),
                  width: 100,
                  child: Placeholder()),
              title: Text('Place ${index + 1}', textScaleFactor: 2),
            );
          },
          childCount: 20,
        ),
      ),
    ],
  ),
    );
  }
}