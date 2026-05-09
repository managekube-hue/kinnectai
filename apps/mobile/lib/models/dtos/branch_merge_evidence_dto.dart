import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_merge_evidence_dto.freezed.dart';
part 'branch_merge_evidence_dto.g.dart';

/// Evidence supporting a branch merge in the family tree graph.
/// Returned when viewing the subgraph for a merge operation.
@freezed
abstract class BranchMergeEvidenceDTO with _$BranchMergeEvidenceDTO {
  const factory BranchMergeEvidenceDTO({
    @JsonKey(name: 'merge_id') required String mergeId,
    @JsonKey(name: 'source_branch_id') required String sourceBranchId,
    @JsonKey(name: 'target_branch_id') required String targetBranchId,
    @JsonKey(name: 'kin_score') required double kinScore,
    @JsonKey(name: 'shared_ancestors') required int sharedAncestors,
    @JsonKey(name: 'evidence_type') required String evidenceType,
    @JsonKey(name: 'confidence_percent') required int confidencePercent,
    @JsonKey(name: 'merged_at') DateTime? mergedAt,
    @JsonKey(name: 'merged_by') String? mergedBy,
  }) = _BranchMergeEvidenceDTO;

  factory BranchMergeEvidenceDTO.fromJson(Map<String, dynamic> json) =>
      _$BranchMergeEvidenceDTOFromJson(json);
}
