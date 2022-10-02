import 'package:clean_archeticture_posts_app/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:clean_archeticture_posts_app/features/posts/presentation/pages/post_add_update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../widgets/posts_page/message_display_widget.dart';
import '../widgets/posts_page/post_list_widget.dart';




class PostsPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingBtn(context),
    );
  }
  AppBar _buildAppbar(){
   return AppBar(
      title: Text('Posts'),
    );
  }

  Widget _buildBody(){
    return Padding(
      padding: EdgeInsets.all(10),
      child: BlocBuilder<PostsBloc ,PostsState>(
        builder: (BuildContext context, state) {
          if(state is LoadingPostsState){
            return LoadingWidget();
          }else if(state is LoadedPostsState){
            return RefreshIndicator(
              onRefresh: ()=> _onRefresh(context),
              child: PostListWidget(
                posts : state.posts
              ),
            );
          }else if(state is ErrorPostsState){
            return MessageDisplayWidget(
              message : state.message
            );
          }
          return LoadingWidget();
        },) ,
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<PostsBloc>(context).add(RefreshPostsEvent());
  }

  Widget _buildFloatingBtn(BuildContext context){
    return FloatingActionButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> PostAddUpdatePage(isUpdatePost: false)));
      },
      child: const Icon(Icons.add),
    );
  }
}