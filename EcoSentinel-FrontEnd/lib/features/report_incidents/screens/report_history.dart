// // lib/features/report_incidents/screens/report_history.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/report_bloc.dart';
// import '../bloc/report_event.dart';
// import '../bloc/report_state.dart' as state;
// import '../../../core/theme/colors.dart';
// import '../../../core/theme/text_styles.dart';
// import '../../../shared/widgets/custom_card.dart';
// import '../../../shared/widgets/loading_indicator.dart';
// import '../../../shared/widgets/empty_state.dart';
// import '../../../shared/widgets/error_widget.dart';
// import '../../../shared/models/incident_report.dart';
// import '../widgets/report_status_chip.dart';
// import 'report_detail_screen.dart';
// import '../bloc/report_state.dart';
// // Removed duplicate import of custom_card.dart

// class ReportHistoryScreen extends StatefulWidget {
//   const ReportHistoryScreen({Key? key}) : super(key: key);

//   @override
//   State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
// }

// class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
//   ReportStatus? _selectedStatus;
//   String _searchQuery = '';
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadReports();
//   }

//   void _loadReports() {
//     context.read<ReportBloc>().add(LoadReportHistory());
//   }

//   void _filterReports(String query, ReportStatus? status) {
//     setState(() {
//       _searchQuery = query;
//       _selectedStatus = status;
//     });

//     context.read<ReportBloc>().add(FilterReports(
//           query: query,
//           status: status,
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report History'),
//         backgroundColor: AppColors.unBlue,
//         foregroundColor: AppColors.unWhite,
//         actions: [
//           IconButton(
//             onPressed: _loadReports,
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search and Filter Section
//           _buildSearchAndFilter(),

//           // Reports List
//           Expanded(
//             child: BlocBuilder<ReportBloc, ReportState>(
//               builder: (context, state) {
//                 if (state is ReportLoading) {
//                   return const LoadingIndicator();
//                 }

//                 if (state is ReportError) {
//                   return CustomErrorWidget(
//                     message: state.message,
//                     onRetry: _loadReports,
//                   );
//                 }

//                 if (state is ReportHistoryLoaded) {
//                   if (state.reports.isEmpty) {
//                     return const EmptyState(
//                       title: 'No Reports Found',
//                       message:
//                           'You haven\'t submitted any incident reports yet.',
//                       icon: Icons.report_outlined,
//                     );
//                   }

//                   return _buildReportsList(state.reports);
//                 }

//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchAndFilter() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.unWhite,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.unGray.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Search Bar
//           TextField(
//             controller: _searchController,
//             onChanged: (value) => _filterReports(value, _selectedStatus),
//             decoration: InputDecoration(
//               hintText: 'Search reports...',
//               prefixIcon: const Icon(Icons.search),
//               suffixIcon: _searchQuery.isNotEmpty
//                   ? IconButton(
//                       onPressed: () {
//                         _searchController.clear();
//                         _filterReports('', _selectedStatus);
//                       },
//                       icon: const Icon(Icons.clear),
//                     )
//                   : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: AppColors.unLightGray),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: AppColors.unBlue),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           // Status Filter Chips
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 _buildFilterChip('All', null),
//                 const SizedBox(width: 8),
//                 _buildFilterChip('Pending', ReportStatus.pending),
//                 const SizedBox(width: 8),
//                 _buildFilterChip('In Progress', ReportStatus.inProgress),
//                 const SizedBox(width: 8),
//                 _buildFilterChip('Resolved', ReportStatus.resolved),
//                 const SizedBox(width: 8),
//                 _buildFilterChip('Rejected', ReportStatus.rejected),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label, ReportStatus? status) {
//     final isSelected = _selectedStatus == status;

//     return FilterChip(
//       label: Text(label),
//       selected: isSelected,
//       onSelected: (selected) {
//         _filterReports(_searchQuery, selected ? status : null);
//       },
//       backgroundColor: AppColors.unWhite,
//       selectedColor: AppColors.unBlue.withOpacity(0.2),
//       checkmarkColor: AppColors.unBlue,
//       labelStyle: TextStyle(
//         color: isSelected ? AppColors.unBlue : AppColors.unDarkGray,
//         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//       ),
//     );
//   }

//   Widget _buildReportsList(List<IncidentReport> reports) {
//     return RefreshIndicator(
//       onRefresh: () async => _loadReports(),
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: reports.length,
//         itemBuilder: (context, index) {
//           final report = reports[index];
//           return _buildReportCard(report);
//         },
//       ),
//     );
//   }

//   Widget _buildReportCard(IncidentReport report) {
//     return CustomCard(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: CircleAvatar(
//           backgroundColor: _getStatusColor(report.status).withOpacity(0.2),
//           child: Icon(
//             _getCategoryIcon(report.category),
//             color: _getStatusColor(report.status),
//           ),
//         ),
//         title: Text(
//           report.title,
//           style: AppTextStyles.bodyMedium.copyWith(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             Text(
//               report.description,
//               style: AppTextStyles.bodySmall,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 ReportStatusChip(status: report.status),
//                 const SizedBox(width: 8),
//                 Text(
//                   _formatDate(report.submittedAt),
//                   style: AppTextStyles.caption,
//                 ),
//               ],
//             ),
//             if (report.location.isNotEmpty) ...[
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     size: 12,
//                     color: AppColors.unGray,
//                   ),
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: Text(
//                       report.location,
//                       style: AppTextStyles.caption,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               '#${report.id}',
//               style: AppTextStyles.caption.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 16,
//               color: AppColors.unGray,
//             ),
//           ],
//         ),
//         onTap: () => _navigateToReportDetail(report),
//       ),
//     );
//   }

//   Color _getStatusColor(ReportStatus status) {
//     switch (status) {
//       case ReportStatus.pending:
//         return AppColors.unOrange;
//       case ReportStatus.inProgress:
//         return AppColors.unBlue;
//       case ReportStatus.resolved:
//         return AppColors.unGreen;
//       case ReportStatus.rejected:
//         return AppColors.unRed;
//       // Add a default case for safety
//       default:
//         return AppColors.unGray;
//     }
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'air pollution':
//         return Icons.air;
//       case 'water pollution':
//         return Icons.water_drop;
//       case 'waste management':
//         return Icons.delete;
//       case 'noise pollution':
//         return Icons.volume_up;
//       case 'illegal dumping':
//         return Icons.warning;
//       case 'deforestation':
//         return Icons.forest;
//       case 'wildlife':
//         return Icons.pets;
//       case 'chemical spill':
//         return Icons.science;
//       case 'construction':
//         return Icons.construction;
//       case 'traffic':
//         return Icons.traffic;
//       default:
//         return Icons.report_problem;
//     }
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);

//     if (difference.inDays > 7) {
//       return '${date.day}/${date.month}/${date.year}';
//     } else if (difference.inDays > 0) {
//       return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
//     } else {
//       return 'Just now';
//     }
//   }

//   void _navigateToReportDetail(IncidentReport report) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ReportDetailScreen(report: report),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }
