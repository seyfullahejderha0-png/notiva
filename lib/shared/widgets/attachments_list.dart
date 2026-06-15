import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/attachment_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class AttachmentsList extends StatelessWidget {
  final List<AttachmentModel> attachments;
  final Function(AttachmentModel) onDelete;
  final bool canEdit;

  const AttachmentsList({
    super.key,
    required this.attachments,
    required this.onDelete,
    this.canEdit = true,
  });

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ekler', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: attachments.map((attachment) {
            IconData iconData = Icons.insert_drive_file;
            if (attachment.type == AttachmentType.image) {
              iconData = Icons.image;
            } else if (attachment.type == AttachmentType.pdf) {
              iconData = Icons.picture_as_pdf;
            }

            return InkWell(
              onTap: () => _openUrl(attachment.url),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: context.bgSurface,
                  border: Border.all(color: context.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(iconData, size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        attachment.fileName,
                        style: AppTypography.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (canEdit) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => onDelete(attachment),
                        child: const Icon(Icons.close, size: 18, color: AppColors.error),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
