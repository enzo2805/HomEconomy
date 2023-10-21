import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class PieGraphWidget extends StatefulWidget {
  final List<double> data;
  final List<String> name;

  const PieGraphWidget({Key key, this.data, this.name}) : super(key: key);

  @override
  _PieGraphWidgetState createState() => _PieGraphWidgetState();
}

class DataPieGraph {
  double value;
  String tag;

  DataPieGraph(this.value, this.tag);
}

class _PieGraphWidgetState extends State<PieGraphWidget> {
  @override
  Widget build(BuildContext context) {

    List<DataPieGraph> dataList = [];

    int length = widget.data.length;
    for (int i=0; i<length ; i++){
      DataPieGraph auxData = DataPieGraph(widget.data.elementAt(i), widget.name.elementAt(i));
      dataList.add(auxData);
    }

    List<Series<DataPieGraph, num>> series = [
      Series<DataPieGraph, int>(
        id: 'Gasto',
        domainFn: (value, index) => index,
        measureFn: (value, _) => value.value,
        data: dataList,
        strokeWidthPxFn: (_, __) => 4,
        labelAccessorFn: (value, _) {
          //String newValue = (value.value*100).toStringAsFixed(0);
          String tag = value.tag;
          return tag;
        },
      )
    ];

    return PieChart(series,
      defaultRenderer: ArcRendererConfig(
        arcRendererDecorators: [ArcLabelDecorator()]
      ),
    );
  }
}


class LineGraphWidget extends StatefulWidget {
  final List<double> data;
  final String type;

  const LineGraphWidget({Key key, this.data, this.type}) : super(key: key);

  @override
  _LineGraphWidgetState createState() => _LineGraphWidgetState();
}

class _LineGraphWidgetState extends State<LineGraphWidget> {
  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum;
      });
    }

    print(time);
    print(measures);

    // Request a build.
    //setState(() {
    //_time = time;
    //_measures = measures;
    //});
  }

  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Gasto',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];

    return LineChart(series,
      animate: false,
      selectionModels: [
        SelectionModelConfig(
          type: SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: NumericAxisSpec(
          tickProviderSpec: (widget.type == 'month')?
          StaticNumericTickProviderSpec(
              [
                TickSpec(0, label: '1'),
                TickSpec(4, label: '5'),
                TickSpec(9, label: '10'),
                TickSpec(14, label: '15'),
                TickSpec(19, label: '20'),
                TickSpec(24, label: '25'),
                TickSpec(29, label: '30'),
              ]
          ):
          StaticNumericTickProviderSpec(
              [
                TickSpec(0, label: '1'),
                TickSpec(1, label: '2'),
                TickSpec(2, label: '3'),
                TickSpec(3, label: '4'),
                TickSpec(4, label: '5'),
                TickSpec(5, label: '6'),
                TickSpec(6, label: '7'),
                TickSpec(7, label: '8'),
                TickSpec(8, label: '9'),
                TickSpec(9, label: '10'),
                TickSpec(10, label: '11'),
                TickSpec(11, label: '12'),
              ]
          )
      ),
      primaryMeasureAxis: NumericAxisSpec(
        tickProviderSpec: BasicNumericTickProviderSpec(
          desiredTickCount: 4,
        ),
      ),
    );
  }
}