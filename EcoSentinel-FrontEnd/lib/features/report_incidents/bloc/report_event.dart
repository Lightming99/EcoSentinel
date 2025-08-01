// lib/features/report_incident/bloc/report_event.dart

import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/models/incident_report.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

// Form Events
class InitializeReportForm extends ReportEvent {
  final IncidentReport? draftReport;

  const InitializeReportForm({this.draftReport});

  @override
  List<Object?> get props => [draftReport];
}

class UpdateReportTitle extends ReportEvent {
  final String title;

  const UpdateReportTitle(this.title);

  @override
  List<Object> get props => [title];
}

class UpdateReportDescription extends ReportEvent {
  final String description;

  const UpdateReportDescription(this.description);

  @override
  List<Object> get props => [description];
}

class UpdateReportCategory extends ReportEvent {
  final String category;

  const UpdateReportCategory(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateReportPriority extends ReportEvent {
  final ReportPriority priority;

  const UpdateReportPriority(this.priority);

  @override
  List<Object> get props => [priority];
}

class UpdateReportLocation extends ReportEvent {
  final LatLng location;
  final String address;

  const UpdateReportLocation(this.location, this.address);

  @override
  List<Object> get props => [location, address];
}

class AddReportPhotos extends ReportEvent {
  final List<File> photos;

  const AddReportPhotos(this.photos);

  @override
  List<Object> get props => [photos];
}

class RemoveReportPhoto extends ReportEvent {
  final File photo;

  const RemoveReportPhoto(this.photo);

  @override
  List<Object> get props => [photo];
}

class ValidateReportForm extends ReportEvent {
  const ValidateReportForm();
}

class SaveReportDraft extends ReportEvent {
  const SaveReportDraft();
}

class LoadReportDraft extends ReportEvent {
  final String draftId;

  const LoadReportDraft(this.draftId);

  @override
  List<Object> get props => [draftId];
}

class DeleteReportDraft extends ReportEvent {
  final String draftId;

  const DeleteReportDraft(this.draftId);

  @override
  List<Object> get props => [draftId];
}

// Submission Events
class SubmitIncidentReport extends ReportEvent {
  const SubmitIncidentReport();
}

class RetryReportSubmission extends ReportEvent {
  const RetryReportSubmission();
}

// History Events
class LoadReportHistory extends ReportEvent {
  const LoadReportHistory();
}

class RefreshReportHistory extends ReportEvent {
  const RefreshReportHistory();
}

class FilterReports extends ReportEvent {
  final String query;
  final ReportStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterReports({
    required this.query,
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [query, status, startDate, endDate];
}

class LoadReportDetails extends ReportEvent {
  final String reportId;

  const LoadReportDetails(this.reportId);

  @override
  List<Object> get props => [reportId];
}

class UpdateReportStatus extends ReportEvent {
  final String reportId;
  final ReportStatus status;

  const UpdateReportStatus(this.reportId, this.status);

  @override
  List<Object> get props => [reportId, status];
}

class DeleteReport extends ReportEvent {
  final String reportId;

  const DeleteReport(this.reportId);

  @override
  List<Object> get props => [reportId];
}

class ExportReportData extends ReportEvent {
  final List<String> reportIds;
  final String format; // 'pdf', 'csv', 'json'

  const ExportReportData({
    required this.reportIds,
    required this.format,
  });

  @override
  List<Object> get props => [reportIds, format];
}

// Offline Events
class QueueReportForSync extends ReportEvent {
  final IncidentReport report;

  const QueueReportForSync(this.report);

  @override
  List<Object> get props => [report];
}

class SyncPendingReports extends ReportEvent {
  const SyncPendingReports();
}

class LoadOfflineReports extends ReportEvent {
  const LoadOfflineReports();
}

// Categories Events
class LoadReportCategories extends ReportEvent {
  const LoadReportCategories();
}

class AddCustomCategory extends ReportEvent {
  final String category;
  final String description;
  final String iconPath;

  const AddCustomCategory({
    required this.category,
    required this.description,
    required this.iconPath,
  });

  @override
  List<Object> get props => [category, description, iconPath];
}

// Analytics Events
class LoadReportAnalytics extends ReportEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadReportAnalytics({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class GenerateReportSummary extends ReportEvent {
  final DateTime startDate;
  final DateTime endDate;
  final List<String>? categories;

  const GenerateReportSummary({
    required this.startDate,
    required this.endDate,
    this.categories,
  });

  @override
  List<Object?> get props => [startDate, endDate, categories];
}
