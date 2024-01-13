import 'dart:async';
import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import '../models/sp.dart';
import '../repositories/sp_repository.dart';

class SeriesDetailBloc {
  final StreamController<Sp> _spController = StreamController<Sp>();
  final SpRepository _spRepository = SpRepository();

  late BuildContext context;

  SeriesDetailBloc({required this.context});
  Stream<Sp> get spStream => _spController.stream;

  Future<void> getOneSP(String id) async {
      var future =  _spRepository.getOne(id);
      future.then((response){
        Sp sp = Sp.fromJson(response.data);
        _spController.add(sp);
      }).catchError((error) {
        String message = getMessageFromException(error);
        showTopRightSnackBar(context, message, NotifyType.error);
        _spController.addError("");
      });
  }

  void dispose() {
    _spController.close();
  }
}
