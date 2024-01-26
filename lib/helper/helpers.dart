
import 'dart:ui';

import 'package:flutter/material.dart';

class Helpers {
  static String? statusConverter(String status) {
    if(status == 'pending'){
      return 'Pending';
    }
    if(status == 'confirmed'){
      return 'Confirmed';
    }
    if(status == 'on_the_way'){
      return 'On the way';
    }
    if(status == 'delivered'){
      return 'Delivered';
    }
    if(status == 'canceled'){
      return 'Canceled';
    }
    if(status == 'pickup_loaded'){
      return 'Pickup Loaded';
    }
    if(status == 'arrived_to_pickup'){
      return 'Arrived to pickup';
    }
    if(status == 'arrived_to_dropoff'){
      return 'Arrived to dropoff';
    }
    if(status == 'delivery_in_progress'){
      return 'Delivery is in progress';
    }
    if(status == 'finished'){
      return 'Finished';
    }
    if(status == 'returned'){
      return 'Returned';
    }

    if(status == 'accepted'){
      return 'Accepted';
    }

    if(status == 'rejected'){
      return 'Rejected';
    }
  }


  static Color? statusColor(String status) {
    if(status == 'pending'){
      return Colors.blueAccent;
    }
    if(status == 'confirmed'){
      return Colors.cyan;
    }
    if(status == 'on_the_way'){
      return Colors.orange;
    }
    if(status == 'delivered'){
      return Colors.green;
    }
    if(status == 'canceled'){
      return Colors.red;
    }
    if(status == 'pickup_loaded'){
      return Colors.cyan;
    }
    if(status == 'arrived_to_pickup'){
      return Colors.cyan;
    }
    if(status == 'arrived_to_dropoff'){
      return Colors.cyan;
    }
    if(status == 'delivery_in_progress'){
      return Colors.cyan;
    }
    if(status == 'finished'){
      return Colors.green;
    }
    if(status == 'returned'){
      return Colors.red;
    }

    if(status == 'accepted'){
      return Colors.cyan;
    }
    if(status == 'rejected'){
      return Colors.red;
    }
  }

  static final List<String> colombiaCities = [
    'Bogotá',
    'Medellín',
    'Cali',
    'Barranquilla',
    'Cartagena',
    'Cúcuta',
    'Soledad',
    'Ibagué',
    'Bucaramanga',
    'Soacha',
    'Santa Marta',
    'Villavicencio',
    'Pasto',
    'Manizales',
    'Neiva',
    'Pereira',
    'Montería',
    'Tunja',
    'Popayán',
    'Valledupar',
    'Quibdó',
    'Armenia',
    'Sincelejo',
    'Riohacha',
  ];

}
