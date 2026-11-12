enum DownloadStatus {
  pending,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}

class DownloadItem {
  final String id;
  final String filename;
  final String url;
  final String filePath;
  final DownloadStatus status;
  final double progress;
  final int totalBytes;
  final int receivedBytes;
  final DateTime createdAt;

  DownloadItem({
    required this.id,
    required this.filename,
    required this.url,
    required this.filePath,
    this.status = DownloadStatus.pending,
    this.progress = 0.0,
    this.totalBytes = 0,
    this.receivedBytes = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filename': filename,
      'url': url,
      'file_path': filePath,
      'status': status.name,
      'progress': progress,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory DownloadItem.fromMap(Map<String, dynamic> map) {
    return DownloadItem(
      id: map['id'] as String,
      filename: map['filename'] as String,
      url: map['url'] as String,
      filePath: map['file_path'] as String,
      status: DownloadStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => DownloadStatus.failed,
      ),
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  DownloadItem copyWith({
    String? id,
    String? filename,
    String? url,
    String? filePath,
    DownloadStatus? status,
    double? progress,
    int? totalBytes,
    int? receivedBytes,
    DateTime? createdAt,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      url: url ?? this.url,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      totalBytes: totalBytes ?? this.totalBytes,
      receivedBytes: receivedBytes ?? this.receivedBytes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

