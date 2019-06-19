import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/payment.dart';
import 'package:flutter/material.dart';

class PaymentPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PaymentState2();
  }
}

class PaymentState2 extends State<PaymentPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ข้อมูลการเก็บเงิน")),
      body: FutureBuilder<List<Payments>>(
        future: DBProvider.db.getAllPayments(),
        builder: (BuildContext context, AsyncSnapshot<List<Payments>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Payments item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    // DBProvider.db.deleteClient(item.id);
                  },
                  child: ListTile(
                    title: Text(item.cust_name),
                    leading: Text(item.pay_no.toString()),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                        // DBProvider.db.blockOrUnblock(item);
                        // setState(() {});
                      },
                      value: item.hasImage,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async {
      //     Client rnd = testClients[math.Random().nextInt(testClients.length)];
      //     await DBProvider.db.newClient(rnd);
      //     setState(() {});
      //   },
      // ),
    );
  }
}
