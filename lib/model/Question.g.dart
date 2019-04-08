// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      inputType: _$enumDecodeNullable(_$InputTypeEnumMap, json['inputType']),
      answers: (json['answers'] as List)
          ?.map((e) =>
              e == null ? null : Answer.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..validator = json['validator'] as String;
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'inputType': _$InputTypeEnumMap[instance.inputType],
      'validator': instance.validator,
      'answers': instance.answers
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$InputTypeEnumMap = <InputType, dynamic>{
  InputType.text: 'text',
  InputType.select: 'select'
};
