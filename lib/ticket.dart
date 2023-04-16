import 'package:json_annotation/json_annotation.dart';
part 'ticket.g.dart';

@JsonSerializable()
class BusTicket {
  int? id;
  String? busId;
  int? price;
  String? from;
  String? to;
  String? discountType;
  String? distance;
  bool? isDiscounted;
  double? discount;
  double? discountedPrice;

  BusTicket(
      {this.id,
      this.price,
      this.from,
      this.to,
      this.distance,
      this.isDiscounted,
      this.discount,
      this.discountedPrice,
      this.busId,
      this.discountType});

  factory BusTicket.fromJson(Map<String, dynamic> json) =>
      _$BusTicketFromJson(json);

  Map<String, dynamic> toJson() => _$BusTicketToJson(this);
}
