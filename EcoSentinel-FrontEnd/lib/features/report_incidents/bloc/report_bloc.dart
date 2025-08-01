// lib/features/report_incident/bloc/report_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/models/incident_report.dart';
import '../../../shared/repositories/report_repository.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/location_service.dart';
import 'dart:io';

// Events
abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class SubmitReport extends ReportEvent {
  final IncidentReport report;
  final List<File> photos;

  const SubmitReport({
    required this.report,
    required this.photos,
  });

  @override
  List<Object?> get props => [report, photos];
}

class LoadReportHistory extends ReportEvent {}

class FilterReports extends ReportEvent {
  final String query;
  final ReportStatus? status;

  const FilterReports({
    required this.query,
    this.status,
  });

  @override
  List<Object?> get props => [query, status];
}

class LoadReportDetail extends ReportEvent {
  final String reportId;

  const LoadReportDetail(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

class SaveDraftReport extends ReportEvent {
  final IncidentReport report;

  const SaveDraftReport(this.report);

  @override
  List<Object?> get props => [report];
}

class LoadDraftReports extends ReportEvent {}

class DeleteDraftReport extends ReportEvent {
  final String draftId;

  const DeleteDraftReport(this.draftId);

  @override
  List<Object?> get props => [draftId];
}

class UpdateReportStatus extends ReportEvent {
  final String reportId;
  final ReportStatus newStatus;

  const UpdateReportStatus({
    required this.reportId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [reportId, newStatus];
}

// States
abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSubmitting extends ReportState {}

class ReportSubmitted extends ReportState {
  final String reportId;
  final String message;

  const ReportSubmitted({
    required this.reportId,
    required this.message,
  });

  @override
  List<Object?> get props => [reportId, message];
}

class ReportHistoryLoaded extends ReportState {
  final List<IncidentReport> reports;
  final List<IncidentReport> filteredReports;

  const ReportHistoryLoaded({
    required this.reports,
    required this.filteredReports,
  });

  @override
  List<Object?> get props => [reports, filteredReports];
}

class ReportDetailLoaded extends ReportState {
  final IncidentReport report;

  const ReportDetailLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class DraftReportSaved extends ReportState {
  final String message;

  const DraftReportSaved(this.message);

  @override
  List<Object?> get props => [message];
}

class DraftReportsLoaded extends ReportState {
  final List<IncidentReport> drafts;

  const DraftReportsLoaded(this.drafts);

  @override
  List<Object?> get props => [drafts];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;
  final StorageService _storageService;
  final LocationService _locationService;

  List<IncidentReport> _allReports = [];
  List<IncidentReport> _filteredReports = [];

  ReportBloc({
    required ReportRepository reportRepository,
    required StorageService storageService,
    required LocationService locationService,
  })  : _reportRepository = reportRepository,
        _storageService = storageService,
        _locationService = locationService,
        super(ReportInitial()) {
    on<SubmitReport>(_onSubmitReport);
    on<LoadReportHistory>(_onLoadReportHistory);
    on<FilterReports>(_onFilterReports);
    on<LoadReportDetail>(_onLoadReportDetail);
    on<SaveDraftReport>(_onSaveDraftReport);
    on<LoadDraftReports>(_onLoadDraftReports);
    on<DeleteDraftReport>(_onDeleteDraftReport);
    on<UpdateReportStatus>(_onUpdateReportStatus);
  }

  Future<void> _onSubmitReport(
    SubmitReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportSubmitting());

    try {
      // Upload photos first
      List<String> photoUrls = [];
      for (File photo in event.photos) {
        final url = await _reportRepository.uploadPhoto(photo);
        photoUrls.add(url);
      }

      // Create report with photo URLs
      final reportWithPhotos = event.report.copyWith(
        photoUrls: photoUrls,
        submittedAt: DateTime.now(),
        status: ReportStatus.pending,
      );

      // Submit report
      final reportId = await _reportRepository.submitReport(reportWithPhotos);

      // Save to local storage for offline access
      await _storageService.saveReport(reportWithPhotos.copyWith(id: reportId));

      emit(ReportSubmitted(
        reportId: reportId,
        message: 'Report submitted successfully',
      ));
    } catch (e) {
      emit(ReportError('Failed to submit report: ${e.toString()}'));
    }
  }

  Future<void> _onLoadReportHistory(
    LoadReportHistory event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      // Try to load from API first
      final reports = await _reportRepository.getReportHistory();
      _allReports = reports;
      _filteredReports = List.from(reports);

      // Cache reports locally
      await _storageService.cacheReports(reports);

      emit(ReportHistoryLoaded(
        reports: _allReports,
        filteredReports: _filteredReports,
      ));
    } catch (e) {
      // Fallback to cached data if API fails
      try {
        final cachedReports = await _storageService.getCachedReports();
        _allReports = cachedReports;
        _filteredReports = List.from(cachedReports);

        emit(ReportHistoryLoaded(
          reports: _allReports,
          filteredReports: _filteredReports,
        ));
      } catch (cacheError) {
        emit(ReportError('Failed to load reports: ${e.toString()}'));
      }
    }
  }

  void _onFilterReports(
    FilterReports event,
    Emitter<ReportState> emit,
  ) {
    _filteredReports = _allReports.where((report) {
      final matchesQuery = event.query.isEmpty ||
          report.title.toLowerCase().contains(event.query.toLowerCase()) ||
          report.description
              .toLowerCase()
              .contains(event.query.toLowerCase()) ||
          report.category.toLowerCase().contains(event.query.toLowerCase());

      final matchesStatus =
          event.status == null || report.status == event.status;

      return matchesQuery && matchesStatus;
    }).toList();

    // Sort by date (newest first)
    _filteredReports.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));

    emit(ReportHistoryLoaded(
      reports: _allReports,
      filteredReports: _filteredReports,
    ));
  }

  Future<void> _onLoadReportDetail(
    LoadReportDetail event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      final report = await _reportRepository.getReportDetail(event.reportId);
      emit(ReportDetailLoaded(report));
    } catch (e) {
      // Try to find in cached reports
      try {
        final report = _allReports.firstWhere((r) => r.id == event.reportId);
        emit(ReportDetailLoaded(report));
      } catch (notFoundError) {
        emit(ReportError('Report not found'));
      }
    }
  }

  Future<void> _onSaveDraftReport(
    SaveDraftReport event,
    Emitter<ReportState> emit,
  ) async {
    try {
      final draftWithId = event.report.copyWith(
        id: event.report.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        isDraft: true,
        lastModified: DateTime.now(),
      );

      await _storageService.saveDraftReport(draftWithId);
      emit(DraftReportSaved('Draft saved successfully'));
    } catch (e) {
      emit(ReportError('Failed to save draft: ${e.toString()}'));
    }
  }

  Future<void> _onLoadDraftReports(
    LoadDraftReports event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      final drafts = await _storageService.getDraftReports();
      emit(DraftReportsLoaded(drafts));
    } catch (e) {
      emit(ReportError('Failed to load drafts: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteDraftReport(
    DeleteDraftReport event,
    Emitter<ReportState> emit,
  ) async {
    try {
      await _storageService.deleteDraftReport(event.draftId);
      // Reload drafts after deletion
      add(LoadDraftReports());
    } catch (e) {
      emit(ReportError('Failed to delete draft: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateReportStatus(
    UpdateReportStatus event,
    Emitter<ReportState> emit,
  ) async {
    try {
      await _reportRepository.updateReportStatus(
        event.reportId,
        event.newStatus,
      );

      // Update local cache
      final reportIndex = _allReports.indexWhere((r) => r.id == event.reportId);
      if (reportIndex != -1) {
        _allReports[reportIndex] = _allReports[reportIndex].copyWith(
          status: event.newStatus,
          lastModified: DateTime.now(),
        );

        // Update filtered reports as well
        final filteredIndex =
            _filteredReports.indexWhere((r) => r.id == event.reportId);
        if (filteredIndex != -1) {
          _filteredReports[filteredIndex] =
              _filteredReports[filteredIndex].copyWith(
            status: event.newStatus,
            lastModified: DateTime.now(),
          );
        }
      }

      emit(ReportHistoryLoaded(
        reports: _allReports,
        filteredReports: _filteredReports,
      ));
    } catch (e) {
      emit(ReportError('Failed to update report status: ${e.toString()}'));
    }
  }
}
