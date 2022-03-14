import 'package:cloud_firestore/cloud_firestore.dart';

abstract class InclusionExclusionEntity {
  String? idOperatorInclusion;
  Timestamp? inclusionDate;
  String? idOperatorExclusion;
  Timestamp? exclusionDate;

  InclusionExclusionEntity({
    this.idOperatorInclusion,
    this.inclusionDate,
    this.idOperatorExclusion,
    this.exclusionDate,
  });
}
