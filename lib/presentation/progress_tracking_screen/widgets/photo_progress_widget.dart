import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PhotoProgressWidget extends StatefulWidget {
  final bool isLoading;

  const PhotoProgressWidget({
    super.key,
    required this.isLoading,
  });

  @override
  State<PhotoProgressWidget> createState() => _PhotoProgressWidgetState();
}

class _PhotoProgressWidgetState extends State<PhotoProgressWidget> {
  // Mock photo data
  final List<Map<String, dynamic>> photoData = [
    {
      "id": 1,
      "date": "2024-01-01",
      "imageUrl":
          "https://images.pexels.com/photos/6975474/pexels-photo-6975474.jpeg?auto=compress&cs=tinysrgb&w=400",
      "weight": 75.5,
      "notes": "Starting my fitness journey!",
      "type": "front"
    },
    {
      "id": 2,
      "date": "2024-01-15",
      "imageUrl":
          "https://images.pexels.com/photos/6975475/pexels-photo-6975475.jpeg?auto=compress&cs=tinysrgb&w=400",
      "weight": 74.2,
      "notes": "Two weeks in, feeling stronger",
      "type": "front"
    },
    {
      "id": 3,
      "date": "2024-02-01",
      "imageUrl":
          "https://images.pexels.com/photos/6975476/pexels-photo-6975476.jpeg?auto=compress&cs=tinysrgb&w=400",
      "weight": 73.1,
      "notes": "One month progress - visible changes!",
      "type": "front"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        widget.isLoading
            ? _buildLoadingState()
            : photoData.isEmpty
                ? _buildEmptyState()
                : _buildPhotoGrid(),
        const SizedBox(height: 16),
        _buildComparisonSection(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'photo_camera',
          color: AppTheme.lightTheme.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Photo Progress',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: _showAddPhotoDialog,
          icon: CustomIconWidget(
            iconName: 'add',
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
          label: const Text('Add Photo'),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'add_a_photo',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No Progress Photos Yet',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start documenting your transformation by adding your first progress photo.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showAddPhotoDialog,
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Take First Photo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: photoData.length,
      itemBuilder: (context, index) {
        final photo = photoData[index];
        return _buildPhotoCard(photo);
      },
    );
  }

  Widget _buildPhotoCard(Map<String, dynamic> photo) {
    final date = DateTime.parse(photo["date"] as String);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                CustomImageWidget(
                  imageUrl: photo["imageUrl"] as String,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${photo["weight"]} kg',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (photo["notes"] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    photo["notes"] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection() {
    if (photoData.length < 2) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'compare',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Before & After Comparison',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildComparisonPhoto(
                    photoData.first,
                    'Before',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildComparisonPhoto(
                    photoData.last,
                    'Latest',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildComparisonStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonPhoto(Map<String, dynamic> photo, String label) {
    final date = DateTime.parse(photo["date"] as String);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomImageWidget(
            imageUrl: photo["imageUrl"] as String,
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          '${date.day}/${date.month}/${date.year}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          '${photo["weight"]} kg',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildComparisonStats() {
    final firstWeight = photoData.first["weight"] as double;
    final lastWeight = photoData.last["weight"] as double;
    final weightDiff = lastWeight - firstWeight;
    final daysDiff = DateTime.parse(photoData.last["date"] as String)
        .difference(DateTime.parse(photoData.first["date"] as String))
        .inDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '${weightDiff.abs().toStringAsFixed(1)} kg',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: weightDiff < 0
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.getErrorColor(true),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                weightDiff < 0 ? 'Lost' : 'Gained',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          Column(
            children: [
              Text(
                '$daysDiff',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddPhotoDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Progress Photo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Take Photo'),
              subtitle: const Text('Capture a new progress photo'),
              onTap: () {
                Navigator.pop(context);
                // Implement camera functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select an existing photo'),
              onTap: () {
                Navigator.pop(context);
                // Implement gallery selection
              },
            ),
          ],
        ),
      ),
    );
  }
}
