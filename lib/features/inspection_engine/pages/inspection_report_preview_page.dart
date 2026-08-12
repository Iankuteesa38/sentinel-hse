import 'package:flutter/material.dart';

import '../models/inspection_report_data.dart';
import 'inspection_pdf_preview_page.dart';

class InspectionReportPreviewPage extends StatelessWidget {
  final InspectionReportData reportData;

  const InspectionReportPreviewPage({super.key, required this.reportData});

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} $hour:$minute';
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Color _getAnswerColor(String answer) {
    switch (answer) {
      case 'Yes':
        return Colors.green;
      case 'No':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection Report Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Generate PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InspectionPdfPreviewPage(reportData: reportData),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reportData.inspectionTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reference: ${reportData.reportReference}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Submitted: '
                    '${_formatDateTime(reportData.submittedAt)}',
                  ),
                  const SizedBox(height: 8),
                  if (reportData.campName.isNotEmpty) ...[
                    Text(
                      'Weighted Audit Score: '
                      '${reportData.welfareAuditPercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'RAG Rating: ${reportData.welfareRagRating}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ] else if (reportData.liftingGroupCompany.isNotEmpty) ...[
                    Text('Group Company: ${reportData.liftingGroupCompany}'),
                    Text(
                      'Contractor Location: '
                      '${reportData.liftingContractorLocation.isEmpty ? 'N/A' : reportData.liftingContractorLocation}',
                    ),
                  ] else ...[
                    Text(
                      'Compliance: '
                      '${reportData.compliancePercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inspection Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text('Location: ${reportData.inspectionLocation}'),
                  const Divider(height: 20),
                  Text('Inspector: ${reportData.inspectorName}'),
                  Text('Inspector ID: ${reportData.inspectorEmployeeId}'),
                  const Divider(height: 20),

                  if (reportData.campName.isNotEmpty) ...[
                    Text('Camp Name: ${reportData.campName}'),
                    Text('Contractor Name: ${reportData.contractorName}'),
                    Text(
                      'Contract Administrator: ${reportData.contractAdministrator}',
                    ),
                    Text('Group Company: ${reportData.groupCompany}'),
                    Text('Asset / Function: ${reportData.assetFunction}'),
                    Text(
                      'Camp Representative: ${reportData.campRepresentative}',
                    ),
                  ] else if (reportData.liftingGroupCompany.isNotEmpty) ...[
                    Text('Group Company: ${reportData.liftingGroupCompany}'),
                    Text(
                      'Contractor Location: ${reportData.liftingContractorLocation}',
                    ),
                  ] else ...[
                    Text('Driver: ${reportData.driverName}'),
                    Text('Driver ID: ${reportData.driverEmployeeId}'),
                    const Divider(height: 20),
                    Text('Vehicle plate: ${reportData.vehiclePlateNumber}'),
                    Text('Fleet number: ${reportData.vehicleFleetNumber}'),
                    Text('Make / model: ${reportData.vehicleMakeModel}'),
                    Text('Odometer: ${reportData.odometerReading}'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (reportData.campName.isNotEmpty) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SummaryTile(
                  label: 'Very Good',
                  value: reportData.items
                      .where((item) => item.performanceRating == 'Very Good')
                      .length
                      .toString(),
                  icon: Icons.verified_outlined,
                ),
                _SummaryTile(
                  label: 'Good',
                  value: reportData.items
                      .where((item) => item.performanceRating == 'Good')
                      .length
                      .toString(),
                  icon: Icons.thumb_up_alt_outlined,
                ),
                _SummaryTile(
                  label: 'Fair',
                  value: reportData.items
                      .where((item) => item.performanceRating == 'Fair')
                      .length
                      .toString(),
                  icon: Icons.horizontal_rule,
                ),
                _SummaryTile(
                  label: 'Needs Improvement',
                  value: reportData.items
                      .where(
                        (item) => item.performanceRating == 'Needs Improvement',
                      )
                      .length
                      .toString(),
                  icon: Icons.warning_amber_outlined,
                ),
                _SummaryTile(
                  label: 'Unacceptable',
                  value: reportData.items
                      .where((item) => item.performanceRating == 'Unacceptable')
                      .length
                      .toString(),
                  icon: Icons.cancel_outlined,
                ),
                _SummaryTile(
                  label: 'N/A',
                  value: reportData.items
                      .where((item) => item.performanceRating == 'N/A')
                      .length
                      .toString(),
                  icon: Icons.remove_circle_outline,
                ),
                _SummaryTile(
                  label: 'CAPAs',
                  value: reportData.findings.length.toString(),
                  icon: Icons.assignment_outlined,
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Section Scores',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...reportData.welfareSectionScores.entries.map(
              (entry) => Card(
                child: ListTile(
                  title: Text(entry.key),
                  trailing: Text(
                    '${entry.value.toStringAsFixed(1)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ] else ...[
            if (reportData.campName.isNotEmpty) ...[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _SummaryTile(
                    label: 'Very Good',
                    value: reportData.items
                        .where((item) => item.performanceRating == 'Very Good')
                        .length
                        .toString(),
                    icon: Icons.verified_outlined,
                  ),
                  _SummaryTile(
                    label: 'Good',
                    value: reportData.items
                        .where((item) => item.performanceRating == 'Good')
                        .length
                        .toString(),
                    icon: Icons.thumb_up_alt_outlined,
                  ),
                  _SummaryTile(
                    label: 'Fair',
                    value: reportData.items
                        .where((item) => item.performanceRating == 'Fair')
                        .length
                        .toString(),
                    icon: Icons.horizontal_rule,
                  ),
                  _SummaryTile(
                    label: 'Needs Improvement',
                    value: reportData.items
                        .where(
                          (item) =>
                              item.performanceRating == 'Needs Improvement',
                        )
                        .length
                        .toString(),
                    icon: Icons.warning_amber_outlined,
                  ),
                  _SummaryTile(
                    label: 'Unacceptable',
                    value: reportData.items
                        .where(
                          (item) => item.performanceRating == 'Unacceptable',
                        )
                        .length
                        .toString(),
                    icon: Icons.cancel_outlined,
                  ),
                  _SummaryTile(
                    label: 'N/A',
                    value: reportData.items
                        .where((item) => item.performanceRating == 'N/A')
                        .length
                        .toString(),
                    icon: Icons.remove_circle_outline,
                  ),
                  _SummaryTile(
                    label: 'CAPAs',
                    value: reportData.findings.length.toString(),
                    icon: Icons.assignment_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Section Scores',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ...reportData.welfareSectionScores.entries.map(
                (entry) => Card(
                  child: ListTile(
                    title: Text(entry.key),
                    trailing: Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _SummaryTile(
                    label: 'Yes',
                    value: reportData.yesCount.toString(),
                    icon: Icons.check_circle_outline,
                  ),
                  _SummaryTile(
                    label: 'No',
                    value: reportData.noCount.toString(),
                    icon: Icons.cancel_outlined,
                  ),
                  _SummaryTile(
                    label: 'N/A',
                    value: reportData.naCount.toString(),
                    icon: Icons.remove_circle_outline,
                  ),
                  _SummaryTile(
                    label: 'CAPAs',
                    value: reportData.findings.length.toString(),
                    icon: Icons.assignment_outlined,
                  ),
                ],
              ),
            ],
          ],
          const SizedBox(height: 24),
          const Text(
            'CAPA Findings',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (reportData.findings.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('No non-compliances were identified.'),
              ),
            )
          else
            ...reportData.findings.map((finding) {
              final riskColor = _getRiskColor(finding.riskLevel);
              final photos = reportData.findingPhotos[finding.itemNumber] ?? [];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: riskColor,
                            child: Text(
                              finding.itemNumber.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              finding.requirement,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Risk: ${finding.riskLevel}'),
                      const SizedBox(height: 5),
                      Text('Finding: ${finding.finding}'),
                      const SizedBox(height: 5),
                      Text('CAPA: ${finding.correctiveAction}'),
                      const SizedBox(height: 5),
                      Text('Responsible: ${finding.responsiblePerson}'),
                      const SizedBox(height: 5),
                      Text('Status: ${finding.status}'),

                      if (finding.status == 'Closed') ...[
                        const SizedBox(height: 10),
                        const Divider(),
                        const Text(
                          'Closure Details',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),

                        Text('Closed by: ${finding.closedBy}'),

                        if (finding.closedAt != null)
                          Text(
                            'Closed date: '
                            '${finding.closedAt!.day.toString().padLeft(2, '0')}/'
                            '${finding.closedAt!.month.toString().padLeft(2, '0')}/'
                            '${finding.closedAt!.year}',
                          ),

                        Text('Closure comment: ${finding.closureComment}'),

                        if (finding.closureEvidence.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          const Text(
                            'Close-out Evidence',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(
                              finding.closureEvidence.length,
                              (index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    finding.closureEvidence[index],
                                    width: 120,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],

                      if (photos.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Finding Photos',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: photos.map((photoBytes) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                photoBytes,
                                width: 120,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          const Text(
            'Checklist Results',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...reportData.items.map((item) {
            final answerColor = _getAnswerColor(item.answer);

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(child: Text(item.itemNumber.toString())),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.requirement,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(item.section),
                          if (item.comment.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text('Comment: ${item.comment}'),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: answerColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.answer,
                        style: TextStyle(
                          color: answerColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
