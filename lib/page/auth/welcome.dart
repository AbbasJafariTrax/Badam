import 'package:badam_app/style/style.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/img/logo.png",
              height: 150,
            ),
            welcomeText("خوش امدید به بادام ملک", context),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              child: Card(
                elevation: 3,
                child: FlatButton(
                  onPressed: () {
                    
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/codephoneVarify");
                    

                  },
                  padding: EdgeInsets.all(20),
                  hoverColor: Colors.grey.withOpacity(0.9),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[textMedim("شروع کردن", context), Icon(Icons.person_add,size: 25,color: Theme.of(context).primaryColor,)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: (){}, child: Text("شرایط و ضوابط",),),
          ],
        ),
      ),
    );
  }
}
