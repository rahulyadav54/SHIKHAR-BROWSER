import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/bookmarks_notifier.dart';
import '../../state/tabs_notifier.dart';

class BookmarksDialog extends ConsumerStatefulWidget {
  const BookmarksDialog({super.key});

  @override
  ConsumerState<BookmarksDialog> createState() => _BookmarksDialogState();
}

class _BookmarksDialogState extends ConsumerState<BookmarksDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarksState = ref.watch(bookmarksProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
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
                      Icon(Icons.star_rounded, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Bookmarks',
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
              const SizedBox(height: 12),

              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (q) => ref.read(bookmarksProvider.notifier).search(q),
                decoration: InputDecoration(
                  hintText: 'Search bookmarks...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(bookmarksProvider.notifier).search('');
                          },
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 12),

              // Bookmarks List
              Expanded(
                child: bookmarksState.items.isEmpty
                    ? const Center(
                        child: Text('No bookmarks saved yet'),
                      )
                    : ListView.separated(
                        itemCount: bookmarksState.items.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = bookmarksState.items[index];
                          return ListTile(
                            leading: item.favicon != null && item.favicon!.isNotEmpty
                                ? Image.network(
                                    item.favicon!,
                                    width: 20,
                                    height: 20,
                                    errorBuilder: (ctx, err, stack) => const Icon(Icons.public, size: 20),
                                  )
                                : const Icon(Icons.public, size: 20),
                            title: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              item.url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18),
                              onPressed: () {
                                ref.read(bookmarksProvider.notifier).deleteBookmark(item.id);
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
