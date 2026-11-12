import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../state/history_notifier.dart';
import '../../state/tabs_notifier.dart';

class HistoryDialog extends ConsumerStatefulWidget {
  const HistoryDialog({super.key});

  @override
  ConsumerState<HistoryDialog> createState() => _HistoryDialogState();
}

class _HistoryDialogState extends ConsumerState<HistoryDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showClearRangeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Browsing Data'),
        content: const Text('Choose what history to remove from your local database:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              final now = DateTime.now();
              final startOfDay = DateTime(now.year, now.month, now.day);
              ref.read(historyProvider.notifier).clearDateRange(startOfDay, now);
            },
            child: const Text('Today Only'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(historyProvider.notifier).clearAll();
            },
            child: const Text('Clear All Time'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 650),
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
                      Icon(Icons.history_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Browsing History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.delete_sweep, size: 18, color: Colors.red),
                        label: const Text('Clear', style: TextStyle(color: Colors.red, fontSize: 13)),
                        onPressed: _showClearRangeDialog,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (q) => ref.read(historyProvider.notifier).search(q),
                decoration: InputDecoration(
                  hintText: 'Search history...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(historyProvider.notifier).search('');
                          },
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 12),

              // History List
              Expanded(
                child: historyState.items.isEmpty
                    ? const Center(
                        child: Text('No browsing history recorded'),
                      )
                    : ListView.separated(
                        itemCount: historyState.items.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = historyState.items[index];
                          final formattedTime = DateFormat('MMM d, h:mm a').format(item.visitedAt);

                          return ListTile(
                            leading: const Icon(Icons.public, size: 20),
                            title: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              '${item.url}  •  $formattedTime',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18),
                              onPressed: () {
                                ref.read(historyProvider.notifier).deleteItem(item.id);
                              },
                            ),
                            onTap: () {
                              ref.read(tabsProvider.notifier).navigateActiveTab(item.url);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
