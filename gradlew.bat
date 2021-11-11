import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;

  MonthWidget({Key key, this.documents})
      :
        total = documents.map((doc) => doc['value'])
            .fold(0.0, (a, b) => a + b),
        perDay = List.generate(30, (int index) {
          return documents.where((doc) => doc['day'] == (index + 1))
              .map((doc) => doc['value'])
              .fold(0.0, (a, b) => a + b);
        }),
        categories = documents.fold({}, (Map<String, double> map, document) {
          if (!map.containsKey(document['category'])) {
            map[document['category']] = 0.0;
          }

          map[document['category']] += document['value'];
          return map;
        }),
        super(key: key);

  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.categories);
    return Expanded(
      child: Column(
        children: <Widget>[
          _expenses(),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 24.0,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text("\$${widget.total.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        Text("Total expenses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    return Container(
      height: 250.0,
      child: GraphWidget(
        data: widget.perDay,
      ),
    );
  }

  Widget _item(IconData icon, String name, int perc