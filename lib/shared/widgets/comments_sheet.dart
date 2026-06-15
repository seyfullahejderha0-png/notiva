import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../modules/workspaces/controllers/workspace_controller.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../controllers/comments_controller.dart';
import '../widgets/notiva_text_field.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  final String workspaceId;
  final String resourceType; // 'note' veya 'task'
  final String resourceId;

  const CommentsSheet({
    super.key,
    required this.workspaceId,
    required this.resourceType,
    required this.resourceId,
  });

  static void show(BuildContext context, {
    required String workspaceId,
    required String resourceType,
    required String resourceId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(
        workspaceId: workspaceId,
        resourceType: resourceType,
        resourceId: resourceId,
      ),
    );
  }

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    
    try {
      await ref.read(commentsControllerProvider).addComment(
        workspaceId: widget.workspaceId,
        resourceType: widget.resourceType,
        resourceId: widget.resourceId,
        content: text,
      );
      _controller.clear();
      // Yorum gönderdikten sonra en alta kaydır
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = CommentParams(
      workspaceId: widget.workspaceId,
      resourceType: widget.resourceType,
      resourceId: widget.resourceId,
    );
    
    final commentsAsync = ref.watch(commentsProvider(params));
    final currentUserId = ref.watch(authControllerProvider).user?.id;

    // Yorumlar yüklendiğinde en alta kaydır
    ref.listen(commentsProvider(params), (previous, next) {
      if (next.hasValue && previous?.value?.length != next.value?.length) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: context.bgBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.bgSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Yorumlar', style: AppTypography.headlineSmall),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Comments List
          Expanded(
            child: commentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (comments) {
                if (comments.isEmpty) {
                  return Center(
                    child: Text(
                      'Henüz yorum yok.\nİlk yorumu sen yap!',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(color: context.textTertiary),
                    ),
                  );
                }
                
                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24),
                  itemCount: comments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final isMe = comment.userId == currentUserId;
                    
                    return Consumer(
                      builder: (context, ref, child) {
                        final userAsync = ref.watch(userDetailsProvider(comment.userId));
                        
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isMe) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primaryLight,
                                child: userAsync.when(
                                  data: (u) => Text(
                                    (u?['name'] ?? '?')[0].toUpperCase(),
                                    style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  loading: () => const SizedBox(),
                                  error: (_, _) => const Icon(Icons.person, size: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isMe ? AppColors.primary : AppColors.secondaryLight,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                                    bottomRight: Radius.circular(isMe ? 4 : 16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    if (!isMe) ...[
                                      userAsync.whenData((u) => Text(
                                        u?['name'] ?? 'Bilinmeyen Kullanıcı',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: context.textSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )).value ?? const SizedBox(),
                                      const SizedBox(height: 4),
                                    ],
                                    Text(
                                      comment.content,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: isMe ? Colors.white : context.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('HH:mm').format(comment.createdAt),
                                      style: AppTypography.labelSmall.copyWith(
                                        color: isMe ? Colors.white70 : context.textTertiary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Input Area
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                left: 16, 
                right: 16, 
                top: 12, 
                bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: context.bgSurface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: NotivaTextField(
                      controller: _controller,
                      hint: 'Yorum yaz...',
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _isSending ? null : _sendComment,
                      icon: _isSending 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
