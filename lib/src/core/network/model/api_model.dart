import 'package:equatable/equatable.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/core/network/model/api_data_model.dart';

class ApiModel<Model extends BaseModel> extends Equatable {
  final int? code;
  final String? message;
  final String? method;
  final Map<String, dynamic>? requestHeader;
  final Map<String, dynamic>? responseHeader;
  final dynamic responseOrigin;
  final ApiDataModel<Model>? data;

  const ApiModel({
    this.code,
    this.message,
    this.data,
    this.requestHeader,
    this.method,
    this.responseHeader,
    this.responseOrigin,
  });

  @override
  List<Object?> get props => [code, message, data, requestHeader, method, responseHeader, responseOrigin];

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      code: json['code'],
      message: json['message'],
      data: json['data'] as ApiDataModel<Model>,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['code'] = code;
    json['message'] = message;
    json['data'] = data!.toJson();
    return json;
  }
}
