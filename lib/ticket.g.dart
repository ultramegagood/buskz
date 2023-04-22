// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusTicket _$BusTicketFromJson(Map<String, dynamic> json) => BusTicket(
      id: json['id'] as String?,
      price: json['price'] as int?,
      from: json['from'] as String?,
      to: json['to'] as String?,
      distance: json['distance'] as String?,
      isDiscounted: json['isDiscounted'] as bool?,
      discount: (json['discount'] as num?)?.toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      busId: json['busId'] as String?,
      discountType: json['discountType'] as String?,
    )..paymentDate = json['paymentDate'] == null
        ? null
        : DateTime.parse(json['paymentDate'] as String);

Map<String, dynamic> _$BusTicketToJson(BusTicket instance) => <String, dynamic>{
      'id': instance.id,
      'busId': instance.busId,
      'price': instance.price,
      'from': instance.from,
      'to': instance.to,
      'discountType': instance.discountType,
      'distance': instance.distance,
      'isDiscounted': instance.isDiscounted,
      'discount': instance.discount,
      'discountedPrice': instance.discountedPrice,
      'paymentDate': instance.paymentDate?.toIso8601String(),
    };
