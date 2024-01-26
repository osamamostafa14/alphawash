import 'package:alphawash/provider/ReportProvider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportFilterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext? context) {
    return Consumer<ReportProvider>(
      builder: (context, reportProvider, child) {
        List<String> _data = ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];

        return SizedBox(
          height: 45,
          child:
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
            itemCount: _data.length,
            itemBuilder: (context, index){
             String _item = _data[index];

              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: InkWell(
                  onTap: () {
                    reportProvider.setSelectedFilterType(_item.toLowerCase());
                    Provider.of<ReportProvider>(context, listen: false).clearOffset();
                    Provider.of<ReportProvider>(context, listen: false)
                        .getTaskUpdates(context, '1', reportProvider.selectedFilterType.toLowerCase(), '', '', reportProvider.updatesType.toLowerCase());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 115,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: reportProvider.selectedFilterType == _item.toLowerCase()?
                        Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.1),
                        border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                      child: Center(child: Text('${_item}',
                          style: TextStyle(color: reportProvider.selectedFilterType == _item.toLowerCase()? Colors.white :
                          Theme.of(context).primaryColor, fontSize: 14, fontWeight: FontWeight.w500))),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
