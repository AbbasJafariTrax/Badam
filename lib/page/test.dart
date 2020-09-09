import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class MyTestPage extends StatefulWidget {



  @override
  _MyHomePageState createState() => new _MyHomePageState();
 }

 class _MyHomePageState extends State<MyTestPage> {
  int _counter = 0;
  ScrollController _hideButtonController;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  var _isVisible;
  @override
  initState(){
    super.initState();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_isVisible == true) {
            /* only set when the previous state is false
             * Less widget rebuilds 
             */
            print("**** ${_isVisible} up"); //Move IO away from setState
            setState((){
              _isVisible = false;
            });
        }
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
              /* only set when the previous state is false
               * Less widget rebuilds 
               */
               print("**** ${_isVisible} down"); //Move IO away from setState
               setState((){
                 _isVisible = true;
               });
           }
        }
    }});
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("hellow"),
      ),
      body: new Center(
        child: new CustomScrollView(
          controller: _hideButtonController,
          shrinkWrap: true,
          slivers: <Widget>[
            new SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: new SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    const Text('I\'m dedicating every day to you'),
                    const Text('Domestic life was never quite my style'),
                    const Text('When you smile, you knock me out, I fall apart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('And I thought I was so smart'),
                    const Text('I realize I am crazy'),   
                  ],
                ),
              ),
            ),
          ],
        )
      ),
      floatingActionButton: new Visibility( 
        visible: _isVisible,
        child: new FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ),     
      ),
    );
  }
}