// lib/features/report_incident/bloc/report_state.dart

import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/models/incident_report.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {
  const ReportInitial();
}

class ReportLoading extends ReportState {
  const ReportLoading();
}

class ReportError extends ReportState {
  final String message;
  final String? errorCode;

  const ReportError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

// Form States
class ReportFormState extends ReportState {
  final String title;
  final String description;
  final String category;
  final ReportPriority priority;
  final LatLng? location;
  final String address;
  final List<File> photos;
  final Map<String, String> validationErrors;
  final bool isValid;
  final bool isDraft;
  final String? draftId;
  final DateTime lastUpdated;

  const ReportFormState({
    this.title = '',
    this.description = '',
    this.category = '',
    this.priority = ReportPriority.medium,
    this.location,
    this.address = '',
    this.photos = const [],
    this.validationErrors = const {},
    this.isValid = false,
    this.isDraft = false,
    this.draftId,
    required this.lastUpdated,
  });

  ReportFormState copyWith({
    String? title,
    String? description,
    String? category,
    ReportPriority? priority,
    LatLng? location,
    String? address,
    List<File>? photos,
    Map<String, String>? validationErrors,
    bool? isValid,
    bool? isDraft,
    String? draftId,
    DateTime? lastUpdated,
  }) {
    return ReportFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      location: location ?? this.location,
      address: address ?? this.address,
      photos: photos ?? this.photos,
      validationErrors: validationErrors ?? this.validationErrors,
      isValid: isValid ?? this.isValid,
      isDraft: isDraft ?? this.isDraft,
      draftId: draftId ?? this.draftId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        category,
        priority,
        location,
        address,
        photos,
        validationErrors,
        isValid,
        isDraft,
        draftId,
        lastUpdated,
      ];
}

class ReportFormValidated extends ReportState {
  final bool isValid;
  final Map<String, String> validationErrors;

  const ReportFormValidated({
    required this.isValid,
    required this.validationErrors,
  });

  @override
  List<Object> get props => [isValid, validationErrors];
}

class ReportDraftSaved extends ReportState {
  final String draftId;
  final DateTime savedAt;

  const ReportDraftSaved({
    required this.draftId,
    required this.savedAt,
  });

  @override
  List<Object> get props => [draftId, savedAt];
}

class ReportDraftLoaded extends ReportState {
  final IncidentReport draft;

  const ReportDraftLoaded(this.draft);

  @override
  List<Object> get props => [draft];
}

class ReportDraftDeleted extends ReportState {
  final String draftId;

  const ReportDraftDeleted(this.draftId);

  @override
  List<Object> get props => [draftId];
}

// Submission States
class ReportSubmitting extends ReportState {
  final double progress;
  final String? currentStep;

  const ReportSubmitting({
    this.progress = 0.0,
    this.currentStep,
  });

  @override
  List<Object?> get props => [progress, currentStep];
}

class ReportSubmitted extends ReportState {
  final IncidentReport report;
  final String confirmationId;

  const ReportSubmitted({
    required this.report,
    required this.confirmationId,
  });

  @override
  List<Object> get props => [report, confirmationId];
}

class ReportSubmissionFailed extends ReportState {
  final String message;
  final IncidentReport report;
  final bool canRetry;

  const ReportSubmissionFailed({
    required this.message,
    required this.report,
    this.canRetry = true,
  });

  @override
  List<Object> get props => [message, report, canRetry];
}

// History States
class ReportHistoryLoaded extends ReportState {
  final List<IncidentReport> reports;
  final List<IncidentReport> filteredReports;
  final int totalCount;
  final bool hasMore;

  const ReportHistoryLoaded({
    required this.reports,
    required this.filteredReports,
    required this.totalCount,
    this.hasMore = false,
  });

  @override
  List<Object> get props => [reports, filteredReports, totalCount, hasMore];
}

class ReportDetailsLoaded extends ReportState {
  final IncidentReport report;
  final List<ReportUpdate> updates;

  const ReportDetailsLoaded({
    required this.report,
    required this.updates,
  });

  @override
  List<Object> get props => [report, updates];
}

class ReportStatusUpdated extends ReportState {
  final String reportId;
  final ReportStatus newStatus;
  final DateTime updatedAt;

  const ReportStatusUpdated({
    required this.reportId,
    required this.newStatus,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [reportId, newStatus, updatedAt];
}

class ReportDeleted extends ReportState {
  final String reportId;

  const ReportDeleted(this.reportId);

  @override
  List<Object> get props => [reportId];
}

// Categories States
class ReportCategoriesLoaded extends ReportState {
  final List<ReportCategory> categories;
  final List<ReportCategory> customCategories;

  const ReportCategoriesLoaded({
    required this.categories,
    required this.customCategories,
  });

  @override
  List<Object> get props => [categories, customCategories];
}

class CustomCategoryAdded extends ReportState {
  final ReportCategory category;

  const CustomCategoryAdded(this.category);

  @override
  List<Object> get props => [category];
}

// Analytics States
class ReportAnalyticsLoaded extends ReportState {
  final ReportAnalytics analytics;

  const ReportAnalyticsLoaded(this.analytics);

  @override
  List<Object> get props => [analytics];
}

class ReportSummaryGenerated extends ReportState {
  final ReportSummary summary;
  final String filePath;

  const ReportSummaryGenerated({
    required this.summary,
    required this.filePath,
  });

  @override
  List<Object> get props => [summary, filePath];
}

// Offline States
class ReportQueuedForSync extends ReportState {
  final IncidentReport report;
  final int queuePosition;

  const ReportQueuedForSync({
    required this.report,
    required this.queuePosition,
  });

  @override
  List<Object> get props => [report, queuePosition];
}

class ReportsSyncing extends ReportState {
  final int totalReports;
  final int syncedReports;
  final double progress;

  const ReportsSyncing({
    required this.totalReports,
    required this.syncedReports,
    required this.progress,
  });

  @override
  List<Object> get props => [totalReports, syncedReports, progress];
}

class ReportsSynced extends ReportState {
  final int syncedCount;
  final int failedCount;
  final List<String> failedReportIds;

  const ReportsSynced({
    required this.syncedCount,
    required this.failedCount,
    required this.failedReportIds,
  });

  @override
  List<Object> get props => [syncedCount, failedCount, failedReportIds];
}

class OfflineReportsLoaded extends ReportState {
  final List<IncidentReport> offlineReports;
  final int pendingSyncCount;

  const OfflineReportsLoaded({
    required this.offlineReports,
    required this.pendingSyncCount,
  });

  @override
  List<Object> get props => [offlineReports, pendingSyncCount];
}

// Export States
class ReportExporting extends ReportState {
  final String format;
  final double progress;

  const ReportExporting({
    required this.format,
    required this.progress,
  });

  @override
  List<Object> get props => [format, progress];
}

class ReportExported extends ReportState {
  final String filePath;
  final String format;
  final int reportCount;

  const ReportExported({
    required this.filePath,
    required this.format,
    required this.reportCount,
  });

  @override
  List<Object> get props => [filePath, format, reportCount];
}

// Additional Models for States
class ReportUpdate {
  final String id;
  final String reportId;
  final ReportStatus status;
  final String message;
  final DateTime timestamp;
  final String? updatedBy;

  const ReportUpdate({
    required this.id,
    required this.reportId,
    required this.status,
    required this.message,
    required this.timestamp,
    this.updatedBy,
  });
}

class ReportCategory {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final bool isCustom;
  final int reportCount;

  const ReportCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    this.isCustom = false,
    this.reportCount = 0,
  });
}

class ReportAnalytics {
  final int totalReports;
  final int pendingReports;
  final int resolvedReports;
  final Map<String, int> categoryBreakdown;
  final Map<ReportPriority, int> priorityBreakdown;
  final Map<DateTime, int> timelineData;
  final double averageResolutionTime;

  const ReportAnalytics({
    required this.totalReports,
    required this.pendingReports,
    required this.resolvedReports,
    required this.categoryBreakdown,
    required this.priorityBreakdown,
    required this.timelineData,
    required this.averageResolutionTime,
  });
}

class ReportSummary {
  final DateTime startDate;
  final DateTime endDate;
  final int totalReports;
  final Map<String, int> categoryStats;
  final Map<ReportStatus, int> statusStats;
  final List<IncidentReport> criticalReports;
  final String summary;

  const ReportSummary({
    required this.startDate,
    required this.endDate,
    required this.totalReports,
    required this.categoryStats,
    required this.statusStats,
    required this.criticalReports,
    required this.summary,
  });
}
