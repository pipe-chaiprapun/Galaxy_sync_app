import 'package:de_mobile/widgets/menu.dart';
import 'package:flutter/material.dart';

enum WhyFarther { PayAmtArea, OrderProduct, PaymentCal, Preference, About }

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Domestic Mobile',style: TextStyle(fontSize: 36),),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<WhyFarther>(
            onSelected: (WhyFarther result) {
              // setState(() {
              //   _selection = result;
              // });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.PayAmtArea,
                    child: Text('แสดงยอดรวมแต่ละพื้นที่'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.OrderProduct,
                    child: Text('บันทึกการสั่งสินค้า'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.PaymentCal,
                    child: Text('ตารางค่างวด'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.Preference,
                    child: Text('ปรับแต่ง'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.About,
                    child: Text('เกี่ยวกับ'),
                  )
                ],
          )
        ],
      ),
      body: Menu(),
    );
  }
}
