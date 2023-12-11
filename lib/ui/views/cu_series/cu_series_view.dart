import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/dtos/series_dto.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/cu_series/bloc/cu_series_bloc.dart';
import 'package:cay_khe/ui/views/cu_series/widgets/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../models/series.dart';
import '../../../repositories/post_repository.dart';
import '/ui/widgets/notification.dart';

const double contentHeight = 448 - bodyVerticalSpace;
const int _left = 4;
const int _right = 1;

class CuSeries extends StatefulWidget {
  final String? id;

  const CuSeries({super.key, this.id});

  @override
  State<CuSeries> createState() => _CuSeriesState();
}

class _CuSeriesState extends State<CuSeries> {
  final CuSeriesBloc _bloc = CuSeriesBloc(
      postRepository: PostRepository(), seriesRepository: SeriesRepository());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get isCreateMode => widget.id == null;

  String get operation => isCreateMode ? 'Tạo' : 'Sửa';

  @override
  void initState() {
    super.initState();

    if (isCreateMode) {
      _bloc.add(InitEmptySeriesEvent());
    } else {
      _bloc.add(LoadSeriesEvent(id: widget.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _bloc,
        child: BlocListener<CuSeriesBloc, CuSeriesState>(
          listener: (context, state) {
            if (state is SeriesCreatedState) {
              appRouter.go('/series/${state.series.id}/edit');
            } else if (state is SeriesUpdatedState) {
              appRouter.go('/series/${state.series.id}');
            } else if (state is AddedPostState) {
              appRouter.pop();
            } else if (state is RemovedPostState) {
            } else if (state is SeriesNotFoundState) {
              showTopRightSnackBar(context, state.message, NotifyType.error);
              appRouter.go('/not-found');
            } else if (state is UnAuthorizedState) {
              showTopRightSnackBar(context, state.message, NotifyType.warning);
              appRouter.go('/forbidden');
            } else if (state is CuSeriesLoadErrorState) {
              showTopRightSnackBar(context, state.message, NotifyType.error);
              appRouter.go('/');
            } else if (state is CuOperationErrorState) {
              showTopRightSnackBar(context, state.message, NotifyType.error);
            }
          },
          child: Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            constraints:
                BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: BlocBuilder<CuSeriesBloc, CuSeriesState>(
              builder: (context, state) {
                if (state is CuSeriesSubState) {
                  _titleController.text = state.series?.title ?? '';
                  _contentController.text = state.series?.content ?? '';
                  return buildBodyContainer(child: buildForm(context, state));
                }

                return buildBodyContainer(
                  child: const CircularProgressIndicator(),
                );
              },
            ),
          ),
        ));
  }

  Container buildBodyContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: horizontalSpace, vertical: bodyVerticalSpace),
      constraints: const BoxConstraints(maxWidth: maxContent),
      child: child,
    );
  }

  Form buildForm(BuildContext context, CuSeriesSubState state) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildTopBarRow(state),
          Row(
            children: [
              Expanded(
                  flex: _left,
                  child: state.isEditMode
                      ? _buildSeriesEditingTab(context, state)
                      : _buildSeriesPreviewTab(context, state)),
              Expanded(
                flex: _right,
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 40,
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row buildTopBarRow(CuSeriesSubState state) {
    return Row(
      children: [
        Expanded(
          flex: _left,
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Text(
                    '$operation series',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    buildSwitchModeButton(
                        'Chỉnh sửa', true, state.isEditMode, state),
                    buildSwitchModeButton(
                        'Xem trước', false, state.isEditMode, state)
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: _right,
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            height: 40,
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                appRouter.go('/');
              },
            ),
          ),
        ),
      ],
    );
  }

  TextButton buildSwitchModeButton(
      String text, bool origin, bool active, CuSeriesSubState state) {
    return TextButton(
      onPressed: () {
        if (origin == active) {
          return;
        }

        Series newSeries;
        if (state.series == null) {
          newSeries = Series(
              title: _titleController.text,
              content: _contentController.text,
              postIds: [],
              isPrivate: false,
              createdBy: '',
              updatedAt: DateTime.now(),
              score: 0,
              commentCount: 0,
              id: '');
        } else {
          newSeries = state.series!.copyWith(
              title: _titleController.text, content: _contentController.text);
        }

        _bloc.add(SwitchModeEvent(
            isEditMode: origin,
            series: newSeries,
            selectedPostUsers: state.selectedPostUsers,
            postUsers: state.postUsers));
      },
      child: Text(text, style: getTextStyle(origin == active)),
    );
  }

  Column _buildSeriesPreviewTab(BuildContext context, state) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 128 + contentHeight),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          child: Markdown(
            data: getMarkdown(state),
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              textScaleFactor: 1.4,
              h1: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 32),
              h2: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 28),
              h3: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20),
              h6: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 13),
              p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
              blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
              listBullet: const TextStyle(fontSize: 16),
            ),
            softLineBreak: true,
          ),
        ),
        _buildActionContainer(state)
      ],
    );
  }

  TextStyle getTextStyle(bool active) {
    if (active) {
      return const TextStyle(
          color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500);
    }

    return const TextStyle(
        color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400);
  }

  Column _buildSeriesEditingTab(BuildContext context, CuSeriesSubState state) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          child: TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tiêu đề';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Viết tiêu đề ở đây...',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1),
        ),
        Container(
          height: contentHeight,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: isCreateMode
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))
                : null,
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          child: TextFormField(
              controller: _contentController,
              onChanged: (value) {
                state.series?.content = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                return null;
              },
              maxLines: null,
              decoration: const InputDecoration.collapsed(
                hintText: 'Viết nội dung ở đây...',
              )),
        ),
        if (widget.id != null)
          Container(
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            padding: const EdgeInsets.only(
              left: 48,
              right: 0,
              top: 8,
              bottom: 12,
            ),
            child: Column(
              children: [
                Column(children: [
                  for (var postUser in state.selectedPostUsers)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: PostItem(postUser: postUser)),
                        TextButton(
                          onPressed: () => _removeSelectedPost(postUser, state),
                          child: const Icon(Icons.close,
                              size: 20, color: Colors.black54, opticalSize: 20),
                        ),
                        Container(
                          width: 48,
                        )
                      ],
                    ),
                ]),
                if (state.selectedPostUsers.isEmpty)
                  Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.only(top: 4, bottom: 4, right: 48),
                    child: const Text(
                        'Chưa có bài viết nào. Vui lòng thêm tối thiểu 1 bài viết để chia sẻ với mọi người!'),
                  ),
                if (state.selectedPostUsers.isNotEmpty)
                  Divider(
                    endIndent: 48,
                    thickness: 1,
                    color: Colors.black12.withOpacity(0.05),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 48 + 4, 4),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () => buildShowModalBottomSheet(context, state),
                    child: const Text('Thêm bài viết'),
                  ),
                )
              ],
            ),
          ),
        _buildActionContainer(state)
      ],
    );
  }

  Container _buildActionContainer(CuSeriesSubState state) {
    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () {
                saveSeries(false, state);
              },
              child: const Text('Đăng lên', style: TextStyle(fontSize: 16)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              child: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  saveSeries(true, state);
                },
                child: const Text('Lưu tạm', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ));
  }

  Future<dynamic> buildShowModalBottomSheet(
      BuildContext context, CuSeriesSubState state) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 500,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: const Text(
                    'Thêm bài viết',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: openModal(state),
                ),
              ],
            ),
          );
        });
  }

  ListView _buildPostListView(CuSeriesSubState state) {
    return ListView.builder(
      itemCount: state.postUsers.length,
      itemBuilder: (context, index) {
        return PostItem(
            postUser: state.postUsers[index],
            onTap: () {
              _addSelectedPost(state.postUsers[index], state);
            });
      },
    );
  }

  getMarkdown(CuSeriesSubState state) {
    String titleRaw = state.series?.title ?? '';
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String posts = '';
    String content = state.series?.content ?? '';
    return '$title  \n###### $posts\n  # \n  $content';
  }

  saveSeries(bool isPrivate, CuSeriesSubState state) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (operation == 'Sửa' && state.selectedPostUsers.isEmpty) {
      showTopRightSnackBar(
          context, 'Vui lòng thêm ít nhất 1 bài viết', NotifyType.warning);
      return;
    }

    if (isCreateMode) {
      _bloc.add(CreateSeriesEvent(
          seriesDTO: createDTO(isPrivate, state),
          isEditMode: state.isEditMode,
          series: state.series,
          selectedPostUsers: state.selectedPostUsers,
          postUsers: state.postUsers));
    } else {
      _bloc.add(UpdateSeriesEvent(
          seriesDTO: createDTO(isPrivate, state),
          isEditMode: state.isEditMode,
          series: state.series,
          selectedPostUsers: state.selectedPostUsers,
          postUsers: state.postUsers));
    }
  }

  SeriesDTO createDTO(bool isPrivate, CuSeriesSubState state) {
    return SeriesDTO(
        title: _titleController.text,
        content: _titleController.text,
        isPrivate: isPrivate,
        postIds: state.selectedPostUsers.map((e) => e.id!).toList());
  }

  Series _getNewSeries(CuSeriesSubState state) {
    if (state.series == null) {
      return Series(
          title: _titleController.text,
          content: _contentController.text,
          postIds: [],
          isPrivate: false,
          createdBy: '',
          updatedAt: DateTime.now(),
          score: 0,
          commentCount: 0,
          id: '');
    } else {
      return state.series!.copyWith(
          title: _titleController.text, content: _contentController.text);
    }
  }

  void _removeSelectedPost(post, CuSeriesSubState state) {
    Series newSeries = _getNewSeries(state);

    _bloc.add(RemovePostEvent(
        postUser: post,
        isEditMode: state.isEditMode,
        series: newSeries,
        selectedPostUsers: state.selectedPostUsers,
        postUsers: state.postUsers));
  }

  void _addSelectedPost(post, CuSeriesSubState state) {
    Series newSeries = _getNewSeries(state);

    _bloc.add(AddPostEvent(
        postUser: post,
        isEditMode: state.isEditMode,
        series: newSeries,
        selectedPostUsers: state.selectedPostUsers,
        postUsers: state.postUsers));
  }

  openModal(CuSeriesSubState state) {
    if (state.postUsers.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Không còn bài viết nào. Thêm bài viết mới'),
            TextButton(
              onPressed: () {
                appRouter.go('/publish/post');
              },
              child: const Text('tại đây'),
            ),
          ],
        ),
      );
    }

    return _buildPostListView(state);
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _bloc.close();
  }
}
