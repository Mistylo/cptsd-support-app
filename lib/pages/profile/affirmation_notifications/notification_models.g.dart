// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAffirmationCollection on Isar {
  IsarCollection<Affirmation> get affirmations => this.collection();
}

const AffirmationSchema = CollectionSchema(
  name: r'Affirmation',
  id: -5052806666404387660,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isEnabled': PropertySchema(
      id: 1,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'isShown': PropertySchema(
      id: 2,
      name: r'isShown',
      type: IsarType.bool,
    ),
    r'text': PropertySchema(
      id: 3,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _affirmationEstimateSize,
  serialize: _affirmationSerialize,
  deserialize: _affirmationDeserialize,
  deserializeProp: _affirmationDeserializeProp,
  idName: r'id',
  indexes: {
    r'isEnabled': IndexSchema(
      id: 1854025363566937220,
      name: r'isEnabled',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isEnabled',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isShown': IndexSchema(
      id: -2507104598800072028,
      name: r'isShown',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isShown',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _affirmationGetId,
  getLinks: _affirmationGetLinks,
  attach: _affirmationAttach,
  version: '3.1.0+1',
);

int _affirmationEstimateSize(
  Affirmation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _affirmationSerialize(
  Affirmation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeBool(offsets[1], object.isEnabled);
  writer.writeBool(offsets[2], object.isShown);
  writer.writeString(offsets[3], object.text);
}

Affirmation _affirmationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Affirmation();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isEnabled = reader.readBool(offsets[1]);
  object.isShown = reader.readBool(offsets[2]);
  object.text = reader.readString(offsets[3]);
  return object;
}

P _affirmationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _affirmationGetId(Affirmation object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _affirmationGetLinks(Affirmation object) {
  return [];
}

void _affirmationAttach(
    IsarCollection<dynamic> col, Id id, Affirmation object) {
  object.id = id;
}

extension AffirmationQueryWhereSort
    on QueryBuilder<Affirmation, Affirmation, QWhere> {
  QueryBuilder<Affirmation, Affirmation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhere> anyIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isEnabled'),
      );
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhere> anyIsShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isShown'),
      );
    });
  }
}

extension AffirmationQueryWhere
    on QueryBuilder<Affirmation, Affirmation, QWhereClause> {
  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> isEnabledEqualTo(
      bool isEnabled) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isEnabled',
        value: [isEnabled],
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> isEnabledNotEqualTo(
      bool isEnabled) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isEnabled',
              lower: [],
              upper: [isEnabled],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isEnabled',
              lower: [isEnabled],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isEnabled',
              lower: [isEnabled],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isEnabled',
              lower: [],
              upper: [isEnabled],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> isShownEqualTo(
      bool isShown) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isShown',
        value: [isShown],
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterWhereClause> isShownNotEqualTo(
      bool isShown) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isShown',
              lower: [],
              upper: [isShown],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isShown',
              lower: [isShown],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isShown',
              lower: [isShown],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isShown',
              lower: [],
              upper: [isShown],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AffirmationQueryFilter
    on QueryBuilder<Affirmation, Affirmation, QFilterCondition> {
  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      isEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> isShownEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isShown',
        value: value,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension AffirmationQueryObject
    on QueryBuilder<Affirmation, Affirmation, QFilterCondition> {}

extension AffirmationQueryLinks
    on QueryBuilder<Affirmation, Affirmation, QFilterCondition> {}

extension AffirmationQuerySortBy
    on QueryBuilder<Affirmation, Affirmation, QSortBy> {
  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByIsShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShown', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByIsShownDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShown', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension AffirmationQuerySortThenBy
    on QueryBuilder<Affirmation, Affirmation, QSortThenBy> {
  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByIsShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShown', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByIsShownDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShown', Sort.desc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Affirmation, Affirmation, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension AffirmationQueryWhereDistinct
    on QueryBuilder<Affirmation, Affirmation, QDistinct> {
  QueryBuilder<Affirmation, Affirmation, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Affirmation, Affirmation, QDistinct> distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<Affirmation, Affirmation, QDistinct> distinctByIsShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isShown');
    });
  }

  QueryBuilder<Affirmation, Affirmation, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension AffirmationQueryProperty
    on QueryBuilder<Affirmation, Affirmation, QQueryProperty> {
  QueryBuilder<Affirmation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Affirmation, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Affirmation, bool, QQueryOperations> isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<Affirmation, bool, QQueryOperations> isShownProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isShown');
    });
  }

  QueryBuilder<Affirmation, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationSettingsCollection on Isar {
  IsarCollection<NotificationSettings> get notificationSettings =>
      this.collection();
}

const NotificationSettingsSchema = CollectionSchema(
  name: r'NotificationSettings',
  id: 4766171496376314778,
  properties: {
    r'dailyFrequency': PropertySchema(
      id: 0,
      name: r'dailyFrequency',
      type: IsarType.long,
    ),
    r'enabled': PropertySchema(
      id: 1,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'quietHoursEnd': PropertySchema(
      id: 2,
      name: r'quietHoursEnd',
      type: IsarType.long,
    ),
    r'quietHoursStart': PropertySchema(
      id: 3,
      name: r'quietHoursStart',
      type: IsarType.long,
    )
  },
  estimateSize: _notificationSettingsEstimateSize,
  serialize: _notificationSettingsSerialize,
  deserialize: _notificationSettingsDeserialize,
  deserializeProp: _notificationSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationSettingsGetId,
  getLinks: _notificationSettingsGetLinks,
  attach: _notificationSettingsAttach,
  version: '3.1.0+1',
);

int _notificationSettingsEstimateSize(
  NotificationSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _notificationSettingsSerialize(
  NotificationSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dailyFrequency);
  writer.writeBool(offsets[1], object.enabled);
  writer.writeLong(offsets[2], object.quietHoursEnd);
  writer.writeLong(offsets[3], object.quietHoursStart);
}

NotificationSettings _notificationSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationSettings();
  object.dailyFrequency = reader.readLong(offsets[0]);
  object.enabled = reader.readBool(offsets[1]);
  object.id = id;
  object.quietHoursEnd = reader.readLong(offsets[2]);
  object.quietHoursStart = reader.readLong(offsets[3]);
  return object;
}

P _notificationSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationSettingsGetId(NotificationSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationSettingsGetLinks(
    NotificationSettings object) {
  return [];
}

void _notificationSettingsAttach(
    IsarCollection<dynamic> col, Id id, NotificationSettings object) {
  object.id = id;
}

extension NotificationSettingsQueryWhereSort
    on QueryBuilder<NotificationSettings, NotificationSettings, QWhere> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationSettingsQueryWhere
    on QueryBuilder<NotificationSettings, NotificationSettings, QWhereClause> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationSettingsQueryFilter on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {
  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> dailyFrequencyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> dailyFrequencyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> dailyFrequencyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> dailyFrequencyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietHoursEndEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietHoursEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietHoursEndGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quietHoursEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietHoursEndLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quietHoursEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietHoursEndBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quietHoursEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietHoursStartEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietHoursStart',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietHoursStartGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quietHoursStart',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietHoursStartLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quietHoursStart',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietHoursStartBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quietHoursStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationSettingsQueryObject on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {}

extension NotificationSettingsQueryLinks on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {}

extension NotificationSettingsQuerySortBy
    on QueryBuilder<NotificationSettings, NotificationSettings, QSortBy> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByDailyFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyFrequency', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByDailyFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyFrequency', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietHoursEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietHoursEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietHoursStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietHoursStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.desc);
    });
  }
}

extension NotificationSettingsQuerySortThenBy
    on QueryBuilder<NotificationSettings, NotificationSettings, QSortThenBy> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByDailyFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyFrequency', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByDailyFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyFrequency', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietHoursEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietHoursEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietHoursStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietHoursStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.desc);
    });
  }
}

extension NotificationSettingsQueryWhereDistinct
    on QueryBuilder<NotificationSettings, NotificationSettings, QDistinct> {
  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByDailyFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyFrequency');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByQuietHoursEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quietHoursEnd');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByQuietHoursStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quietHoursStart');
    });
  }
}

extension NotificationSettingsQueryProperty on QueryBuilder<
    NotificationSettings, NotificationSettings, QQueryProperty> {
  QueryBuilder<NotificationSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      dailyFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyFrequency');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      quietHoursEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietHoursEnd');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      quietHoursStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietHoursStart');
    });
  }
}
