import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/config/time_converter.dart';
import 'package:flutter_port_taxi/models/ride_case.dart';
import 'package:flutter_port_taxi/widget/car_number_tag.dart';
import '../config/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RideRecordDetail extends StatefulWidget {

  final RideCase theCase;
  const RideRecordDetail({Key? key, required this.theCase}) : super(key: key);

  @override
  State<RideRecordDetail> createState() => _RideRecordDetailState();
}

class _RideRecordDetailState extends State<RideRecordDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.rideDetail),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Text('${DateTimeConverter.dateTime(widget.theCase.createTime!)}'),
            const SizedBox(height: 30,),
            Text('${AppLocalizations.of(context)!.driver}${widget.theCase.driverName}',),
            Row(
              children: [
                Text('${AppLocalizations.of(context)!.car}${widget.theCase.carModel}'),
                CarNumberTag(carNumber: widget.theCase.carIdNumber!)
              ],
            ),
            const SizedBox(height: 30,),
            Text(AppLocalizations.of(context)!.pickUpAddress,style: const TextStyle(fontSize: 14)),
            Text(widget.theCase.onAddress!, style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Text(AppLocalizations.of(context)!.dropOffAddress,style: const TextStyle(fontSize: 14)),
            widget.theCase.offAddress == null ? Text(AppLocalizations.of(context)!.notSpecified) : Text(widget.theCase.offAddress!, style: const TextStyle(fontWeight: FontWeight.bold),),
            const Divider(color: Colors.black,height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.fare,style: const TextStyle(fontSize: 14)),
                Text.rich(
                    TextSpan(
                        children: [
                          const TextSpan(text:'\$ ',style: TextStyle(fontSize: 14)),
                          widget.theCase.caseMoney == null
                              ? TextSpan(text: AppLocalizations.of(context)!.noData)
                              : TextSpan(text: widget.theCase.caseMoney!.toString(), style: const TextStyle(color: AppColor.red, fontWeight: FontWeight.bold, fontSize: 26))
                        ]))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
