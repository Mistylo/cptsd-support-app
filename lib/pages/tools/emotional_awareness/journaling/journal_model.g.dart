// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetJournalEntryCollection on Isar {
  IsarCollection<JournalEntry> get journalEntrys => this.collection();
}

const JournalEntrySchema = CollectionSchema(
  name: r'JournalEntry',
  id: -8443410721192565146,
  properties: {
    r'backgroundColorValue': PropertySchema(
      id: 0,
      name: r'backgroundColorValue',
      type: IsarType.long,
    ),
    r'backgroundPattern': PropertySchema(
      id: 1,
      name: r'backgroundPattern',
      type: IsarType.string,
    ),
    r'contentJson': PropertySchema(
      id: 2,
      name: r'contentJson',
      type: IsarType.string,
    ),
    r'fontFamily': PropertySchema(
      id: 3,
      name: r'fontFamily',
      type: IsarType.string,
    ),
    r'placedStickersJson': PropertySchema(
      id: 4,
      name: r'placedStickersJson',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 5,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _journalEntryEstimateSize,
  serialize: _journalEntrySerialize,
  deserialize: _journalEntryDeserialize,
  deserializeProp: _journalEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'type': IndexSchema(
      id: 5117122708147080838,
      name: r'type',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _journalEntryGetId,
  getLinks: _journalEntryGetLinks,
  attach: _journalEntryAttach,
  version: '3.1.0+1',
);

int _journalEntryEstimateSize(
  JournalEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.backgroundPattern;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.contentJson.length * 3;
  bytesCount += 3 + object.fontFamily.length * 3;
  {
    final value = object.placedStickersJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _journalEntrySerialize(
  JournalEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.backgroundColorValue);
  writer.writeString(offsets[1], object.backgroundPattern);
  writer.writeString(offsets[2], object.contentJson);
  writer.writeString(offsets[3], object.fontFamily);
  writer.writeString(offsets[4], object.placedStickersJson);
  writer.writeDateTime(offsets[5], object.timestamp);
  writer.writeString(offsets[6], object.title);
  writer.writeString(offsets[7], object.type);
}

JournalEntry _journalEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = JournalEntry();
  object.backgroundColorValue = reader.readLong(offsets[0]);
  object.backgroundPattern = reader.readStringOrNull(offsets[1]);
  object.contentJson = reader.readString(offsets[2]);
  object.fontFamily = reader.readString(offsets[3]);
  object.id = id;
  object.placedStickersJson = reader.readStringOrNull(offsets[4]);
  object.timestamp = reader.readDateTime(offsets[5]);
  object.title = reader.readStringOrNull(offsets[6]);
  object.type = reader.readString(offsets[7]);
  return object;
}

P _journalEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _journalEntryGetId(JournalEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _journalEntryGetLinks(JournalEntry object) {
  return [];
}

void _journalEntryAttach(
    IsarCollection<dynamic> col, Id id, JournalEntry object) {
  object.id = id;
}

extension JournalEntryQueryWhereSort
    on QueryBuilder<JournalEntry, JournalEntry, QWhere> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhere> anyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'type'),
      );
    });
  }
}

extension JournalEntryQueryWhere
    on QueryBuilder<JournalEntry, JournalEntry, QWhereClause> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> typeEqualTo(
      String type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type',
        value: [type],
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> typeNotEqualTo(
      String type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [],
              upper: [type],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [type],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [type],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [],
              upper: [type],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> typeGreaterThan(
    String type, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [type],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> typeLessThan(
    String type, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [],
        upper: [type],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> typeBetween(
    String lowerType,
    String upperType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [lowerType],
        includeLower: includeLower,
        upper: [upperType],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> typeStartsWith(
      String TypePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [TypePrefix],
        upper: ['$TypePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type',
        value: [''],
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'type',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'type',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'type',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'type',
              upper: [''],
            ));
      }
    });
  }
}

extension JournalEntryQueryFilter
    on QueryBuilder<JournalEntry, JournalEntry, QFilterCondition> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backgroundColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundColorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'backgroundColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundColorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'backgroundColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'backgroundColorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'backgroundPattern',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'backgroundPattern',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backgroundPattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'backgroundPattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'backgroundPattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'backgroundPattern',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'backgroundPattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'backgroundPattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'backgroundPattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'backgroundPattern',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backgroundPattern',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      backgroundPatternIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'backgroundPattern',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentJson',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      contentJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentJson',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontFamily',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fontFamily',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      fontFamilyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'placedStickersJson',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'placedStickersJson',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placedStickersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'placedStickersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'placedStickersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'placedStickersJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'placedStickersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'placedStickersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'placedStickersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'placedStickersJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placedStickersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      placedStickersJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'placedStickersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension JournalEntryQueryObject
    on QueryBuilder<JournalEntry, JournalEntry, QFilterCondition> {}

extension JournalEntryQueryLinks
    on QueryBuilder<JournalEntry, JournalEntry, QFilterCondition> {}

extension JournalEntryQuerySortBy
    on QueryBuilder<JournalEntry, JournalEntry, QSortBy> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByBackgroundColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColorValue', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByBackgroundColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColorValue', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByBackgroundPattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundPattern', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByBackgroundPatternDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundPattern', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByContentJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentJson', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByContentJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentJson', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByPlacedStickersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placedStickersJson', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByPlacedStickersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placedStickersJson', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension JournalEntryQuerySortThenBy
    on QueryBuilder<JournalEntry, JournalEntry, QSortThenBy> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByBackgroundColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColorValue', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByBackgroundColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColorValue', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByBackgroundPattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundPattern', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByBackgroundPatternDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundPattern', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByContentJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentJson', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByContentJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentJson', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByPlacedStickersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placedStickersJson', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByPlacedStickersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placedStickersJson', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension JournalEntryQueryWhereDistinct
    on QueryBuilder<JournalEntry, JournalEntry, QDistinct> {
  QueryBuilder<JournalEntry, JournalEntry, QDistinct>
      distinctByBackgroundColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backgroundColorValue');
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct>
      distinctByBackgroundPattern({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backgroundPattern',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByContentJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByFontFamily(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontFamily', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct>
      distinctByPlacedStickersJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placedStickersJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension JournalEntryQueryProperty
    on QueryBuilder<JournalEntry, JournalEntry, QQueryProperty> {
  QueryBuilder<JournalEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<JournalEntry, int, QQueryOperations>
      backgroundColorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backgroundColorValue');
    });
  }

  QueryBuilder<JournalEntry, String?, QQueryOperations>
      backgroundPatternProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backgroundPattern');
    });
  }

  QueryBuilder<JournalEntry, String, QQueryOperations> contentJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentJson');
    });
  }

  QueryBuilder<JournalEntry, String, QQueryOperations> fontFamilyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontFamily');
    });
  }

  QueryBuilder<JournalEntry, String?, QQueryOperations>
      placedStickersJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placedStickersJson');
    });
  }

  QueryBuilder<JournalEntry, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<JournalEntry, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<JournalEntry, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
