import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../models/download_item.dart';
import '../../state/downloads_notifier.dart';

class DownloadsDialog extends ConsumerWidget {
  const DownloadsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsState = ref.watch(downloadsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.download_rounded, color: ShikharColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Downloads',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // Downloads list
              Expanded(
                child: downloadsState.items.isEmpty
                    ? const Center(
                        child: Text('No active or previous downloads'),
                      )
                    : ListView.separated(
                        itemCount: downloadsState.items.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = downloadsState.items[index];
                          return _buildDownloadTile(context, ref, item);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadTile(BuildContext context, WidgetRef ref, DownloadItem item) {
    IconData statusIcon = Icons.insert_drive_file_outlined;
    Color statusColor = Colors.grey;

    switch (item.status) {
      case DownloadStatus.completed:
        statusIcon = Icons.check_circle_outline;
        statusColor = ShikharColors.secureGreen;
        break;
      case DownloadStatus.downloading:
        statusIcon = Icons.downloading;
        statusColor = ShikharColors.accent;
        break;
      case DownloadStatus.failed:
        statusIcon = Icons.error_outline;
        statusColor = Colors.red;
        break;
      case DownloadStatus.cancelled:
        statusIcon = Icons.cancel_outlined;
        statusColor = Colors.orange;
        break;
      default:
        break;
    }

    return ListTile(
      leading: Icon(statusIcon, color: statusColor, size: 28),
      title: Text(
        item.filename,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          if (item.status == DownloadStatus.downloading) ...[
            LinearProgressIndicator(
              value: item.progress > 0 ? item.progress : null,
              backgroundColor: Colors.grey.shade200,
              color: ShikharColors.primary,
            ),
            const SizedBox(height: 4),
            Text(
              'Downloading... ${(item.progress * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 11),
            ),
          ] else ...[
            Text(
              '${item.status.name.toUpperCase()}  •  ${item.filePath}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.status == DownloadStatus.completed)
            IconButton(
              icon: const Icon(Icons.open_in_new, size: 18),
              tooltip: 'Open file',
              onPressed: () => ref.read(downloadsProvider.notifier).openFile(item.filePath),
            ),
          if (item.status == DownloadStatus.failed || item.status == DownloadStatus.cancelled)
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              tooltip: 'Retry',
              onPressed: () => ref.read(downloadsProvider.notifier).retry(item),
            ),
          if (item.status == DownloadStatus.downloading)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              tooltip: 'Cancel',
              onPressed: () => ref.read(downloadsProvider.notifier).cancel(item.id),
            ),
          IconButton(
            icon: const Icon(Icons.folder_open, size: 18),
            tooltip: 'Show in folder',
            onPressed: () => ref.read(downloadsProvider.notifier).openFolder(item.filePath),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            tooltip: 'Delete record',
            onPressed: () => ref.read(downloadsProvider.notifier).deleteRecord(item.id),
          ),
        ],
      ),
    );
  }
}
