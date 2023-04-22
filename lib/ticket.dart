/// МОдель конструктор BusTicket
import 'package:json_annotation/json_annotation.dart';
part 'ticket.g.dart';

@JsonSerializable()
class BusTicket {
  String? id;
  String? busId;
  int? price;
  String? from;
  String? to;
  String? discountType;
  String? distance;
  bool? isDiscounted;
  double? discount;
  double? discountedPrice;
  DateTime? paymentDate;

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
  ///
  /// КОнвертация json-нан
  ///
  factory BusTicket.fromJson(Map<String, dynamic> json) =>
      _$BusTicketFromJson(json);

  ///
  /// Конвертация в json-га
  ///
  Map<String, dynamic> toJson() => _$BusTicketToJson(this);
}
