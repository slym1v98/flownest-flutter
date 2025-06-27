import 'package:equatable/equatable.dart';
import 'package:kappa/kappa.dart';

class ApiDataModel<Model extends BaseModel> extends Equatable {
  final int? statusCode;
  final String? message;
  final SingleOrList<Model>? data;
  final Map<String, dynamic>? errors;
  final Map<String, dynamic>? meta;

  const ApiDataModel({
    this.message,
    this.statusCode,
    this.data,
    this.errors,
    this.meta,
  });

  @override
  List<Object?> get props => [statusCode, message, data, errors, meta];

  factory ApiDataModel.fromJson(Map<String, dynamic> json) {
    return ApiDataModel(
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] is List
          ? ListOf((json['data'] as List).map((e) => BaseModel.fromJson(e) as Model).toList())
          : Single(BaseModel.fromJson(json['data']) as Model),
      errors: json['errors'],
      meta: json['meta'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status_code'] = statusCode;
    json['message'] = message;
    json['data'] = data?.when(
      single: (model) => model.toJson(),
      list: (models) => models.map((e) => e.toJson()).toList(),
    );
    json['errors'] = errors;
    json['meta'] = meta;
    return json;
  }
}
