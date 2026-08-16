// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inner_studio_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUnlockedStickerCollection on Isar {
  IsarCollection<UnlockedSticker> get unlockedStickers => this.collection();
}

const UnlockedStickerSchema = CollectionSchema(
  name: r'UnlockedSticker',
  id: -856460671925694274,
  properties: {
    r'imagePath': PropertySchema(
      id: 0,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'isCustom': PropertySchema(
      id: 1,
      name: r'isCustom',
      type: IsarType.bool,
    ),
    r'isMilestone': PropertySchema(
      id: 2,
      name: r'isMilestone',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(
      id: 4,
      name: r'tags',
      type: IsarType.stringList,
    ),
    r'unlockedAt': PropertySchema(
      id: 5,
      name: r'unlockedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _unlockedStickerEstimateSize,
  serialize: _unlockedStickerSerialize,
  deserialize: _unlockedStickerDeserialize,
  deserializeProp: _unlockedStickerDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _unlockedStickerGetId,
  getLinks: _unlockedStickerGetLinks,
  attach: _unlockedStickerAttach,
  version: '3.1.0+1',
);

int _unlockedStickerEstimateSize(
  UnlockedSticker object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.imagePath.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _unlockedStickerSerialize(
  UnlockedSticker object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.imagePath);
  writer.writeBool(offsets[1], object.isCustom);
  writer.writeBool(offsets[2], object.isMilestone);
  writer.writeString(offsets[3], object.name);
  writer.writeStringList(offsets[4], object.tags);
  writer.writeDateTime(offsets[5], object.unlockedAt);
}

UnlockedSticker _unlockedStickerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UnlockedSticker();
  object.id = id;
  object.imagePath = reader.readString(offsets[0]);
  object.isCustom = reader.readBool(offsets[1]);
  object.isMilestone = reader.readBool(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.tags = reader.readStringList(offsets[4]) ?? [];
  object.unlockedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _unlockedStickerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _unlockedStickerGetId(UnlockedSticker object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _unlockedStickerGetLinks(UnlockedSticker object) {
  return [];
}

void _unlockedStickerAttach(
    IsarCollection<dynamic> col, Id id, UnlockedSticker object) {
  object.id = id;
}

extension UnlockedStickerQueryWhereSort
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QWhere> {
  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UnlockedStickerQueryWhere
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QWhereClause> {
  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterWhereClause>
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

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterWhereClause> idBetween(
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

extension UnlockedStickerQueryFilter
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QFilterCondition> {
  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      isCustomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCustom',
        value: value,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      isMilestoneEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMilestone',
        value: value,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      unlockedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      unlockedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      unlockedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterFilterCondition>
      unlockedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unlockedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UnlockedStickerQueryObject
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QFilterCondition> {}

extension UnlockedStickerQueryLinks
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QFilterCondition> {}

extension UnlockedStickerQuerySortBy
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QSortBy> {
  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByIsMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMilestone', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByIsMilestoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMilestone', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      sortByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension UnlockedStickerQuerySortThenBy
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QSortThenBy> {
  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByIsMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMilestone', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByIsMilestoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMilestone', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QAfterSortBy>
      thenByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension UnlockedStickerQueryWhereDistinct
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QDistinct> {
  QueryBuilder<UnlockedSticker, UnlockedSticker, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QDistinct>
      distinctByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCustom');
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QDistinct>
      distinctByIsMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMilestone');
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }

  QueryBuilder<UnlockedSticker, UnlockedSticker, QDistinct>
      distinctByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedAt');
    });
  }
}

extension UnlockedStickerQueryProperty
    on QueryBuilder<UnlockedSticker, UnlockedSticker, QQueryProperty> {
  QueryBuilder<UnlockedSticker, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UnlockedSticker, String, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<UnlockedSticker, bool, QQueryOperations> isCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCustom');
    });
  }

  QueryBuilder<UnlockedSticker, bool, QQueryOperations> isMilestoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMilestone');
    });
  }

  QueryBuilder<UnlockedSticker, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<UnlockedSticker, List<String>, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<UnlockedSticker, DateTime, QQueryOperations>
      unlockedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStudioStateDataCollection on Isar {
  IsarCollection<StudioStateData> get studioStateDatas => this.collection();
}

const StudioStateDataSchema = CollectionSchema(
  name: r'StudioStateData',
  id: 8153289088217737844,
  properties: {
    r'completedActivityCounts': PropertySchema(
      id: 0,
      name: r'completedActivityCounts',
      type: IsarType.longList,
    ),
    r'completedActivityKeys': PropertySchema(
      id: 1,
      name: r'completedActivityKeys',
      type: IsarType.stringList,
    ),
    r'currentProgressPoints': PropertySchema(
      id: 2,
      name: r'currentProgressPoints',
      type: IsarType.long,
    ),
    r'currentStickerIndex': PropertySchema(
      id: 3,
      name: r'currentStickerIndex',
      type: IsarType.long,
    ),
    r'currentTargetPoints': PropertySchema(
      id: 4,
      name: r'currentTargetPoints',
      type: IsarType.long,
    )
  },
  estimateSize: _studioStateDataEstimateSize,
  serialize: _studioStateDataSerialize,
  deserialize: _studioStateDataDeserialize,
  deserializeProp: _studioStateDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _studioStateDataGetId,
  getLinks: _studioStateDataGetLinks,
  attach: _studioStateDataAttach,
  version: '3.1.0+1',
);

int _studioStateDataEstimateSize(
  StudioStateData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.completedActivityCounts.length * 8;
  bytesCount += 3 + object.completedActivityKeys.length * 3;
  {
    for (var i = 0; i < object.completedActivityKeys.length; i++) {
      final value = object.completedActivityKeys[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _studioStateDataSerialize(
  StudioStateData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.completedActivityCounts);
  writer.writeStringList(offsets[1], object.completedActivityKeys);
  writer.writeLong(offsets[2], object.currentProgressPoints);
  writer.writeLong(offsets[3], object.currentStickerIndex);
  writer.writeLong(offsets[4], object.currentTargetPoints);
}

StudioStateData _studioStateDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StudioStateData();
  object.completedActivityCounts = reader.readLongList(offsets[0]) ?? [];
  object.completedActivityKeys = reader.readStringList(offsets[1]) ?? [];
  object.currentProgressPoints = reader.readLong(offsets[2]);
  object.currentStickerIndex = reader.readLong(offsets[3]);
  object.currentTargetPoints = reader.readLong(offsets[4]);
  object.id = id;
  return object;
}

P _studioStateDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _studioStateDataGetId(StudioStateData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _studioStateDataGetLinks(StudioStateData object) {
  return [];
}

void _studioStateDataAttach(
    IsarCollection<dynamic> col, Id id, StudioStateData object) {
  object.id = id;
}

extension StudioStateDataQueryWhereSort
    on QueryBuilder<StudioStateData, StudioStateData, QWhere> {
  QueryBuilder<StudioStateData, StudioStateData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StudioStateDataQueryWhere
    on QueryBuilder<StudioStateData, StudioStateData, QWhereClause> {
  QueryBuilder<StudioStateData, StudioStateData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterWhereClause>
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

  QueryBuilder<StudioStateData, StudioStateData, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterWhereClause> idBetween(
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

extension StudioStateDataQueryFilter
    on QueryBuilder<StudioStateData, StudioStateData, QFilterCondition> {
  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedActivityCounts',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedActivityCounts',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedActivityCounts',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedActivityCounts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityCounts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityCounts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityCounts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityCounts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityCounts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityCountsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityCounts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedActivityKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedActivityKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedActivityKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedActivityKeys',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'completedActivityKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'completedActivityKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'completedActivityKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'completedActivityKeys',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedActivityKeys',
        value: '',
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'completedActivityKeys',
        value: '',
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityKeys',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityKeys',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityKeys',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityKeys',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityKeys',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      completedActivityKeysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedActivityKeys',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentProgressPointsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentProgressPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentProgressPointsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentProgressPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentProgressPointsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentProgressPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentProgressPointsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentProgressPoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentStickerIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStickerIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentStickerIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStickerIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentStickerIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStickerIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentStickerIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStickerIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentTargetPointsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTargetPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentTargetPointsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentTargetPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentTargetPointsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentTargetPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      currentTargetPointsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentTargetPoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<StudioStateData, StudioStateData, QAfterFilterCondition>
      idBetween(
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
}

extension StudioStateDataQueryObject
    on QueryBuilder<StudioStateData, StudioStateData, QFilterCondition> {}

extension StudioStateDataQueryLinks
    on QueryBuilder<StudioStateData, StudioStateData, QFilterCondition> {}

extension StudioStateDataQuerySortBy
    on QueryBuilder<StudioStateData, StudioStateData, QSortBy> {
  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      sortByCurrentProgressPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentProgressPoints', Sort.asc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      sortByCurrentProgressPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentProgressPoints', Sort.desc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      sortByCurrentStickerIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStickerIndex', Sort.asc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      sortByCurrentStickerIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStickerIndex', Sort.desc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      sortByCurrentTargetPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTargetPoints', Sort.asc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      sortByCurrentTargetPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTargetPoints', Sort.desc);
    });
  }
}

extension StudioStateDataQuerySortThenBy
    on QueryBuilder<StudioStateData, StudioStateData, QSortThenBy> {
  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      thenByCurrentProgressPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentProgressPoints', Sort.asc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      thenByCurrentProgressPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentProgressPoints', Sort.desc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      thenByCurrentStickerIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStickerIndex', Sort.asc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      thenByCurrentStickerIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStickerIndex', Sort.desc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      thenByCurrentTargetPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTargetPoints', Sort.asc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy>
      thenByCurrentTargetPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTargetPoints', Sort.desc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension StudioStateDataQueryWhereDistinct
    on QueryBuilder<StudioStateData, StudioStateData, QDistinct> {
  QueryBuilder<StudioStateData, StudioStateData, QDistinct>
      distinctByCompletedActivityCounts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedActivityCounts');
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QDistinct>
      distinctByCompletedActivityKeys() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedActivityKeys');
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QDistinct>
      distinctByCurrentProgressPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentProgressPoints');
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QDistinct>
      distinctByCurrentStickerIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStickerIndex');
    });
  }

  QueryBuilder<StudioStateData, StudioStateData, QDistinct>
      distinctByCurrentTargetPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentTargetPoints');
    });
  }
}

extension StudioStateDataQueryProperty
    on QueryBuilder<StudioStateData, StudioStateData, QQueryProperty> {
  QueryBuilder<StudioStateData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StudioStateData, List<int>, QQueryOperations>
      completedActivityCountsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedActivityCounts');
    });
  }

  QueryBuilder<StudioStateData, List<String>, QQueryOperations>
      completedActivityKeysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedActivityKeys');
    });
  }

  QueryBuilder<StudioStateData, int, QQueryOperations>
      currentProgressPointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentProgressPoints');
    });
  }

  QueryBuilder<StudioStateData, int, QQueryOperations>
      currentStickerIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStickerIndex');
    });
  }

  QueryBuilder<StudioStateData, int, QQueryOperations>
      currentTargetPointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentTargetPoints');
    });
  }
}
