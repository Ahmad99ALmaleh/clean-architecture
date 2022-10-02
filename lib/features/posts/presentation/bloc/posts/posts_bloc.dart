import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_archeticture_posts_app/core/error/failures.dart';
import 'package:clean_archeticture_posts_app/core/strings/failures.dart';
import 'package:clean_archeticture_posts_app/features/posts/domain/usecases/get_all_posts.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/posts.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUseCase getAllPosts;
  PostsBloc({required this.getAllPosts}) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if(event is GetAllPostsEvent){
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts();
        emit(_mapFailureOrPostsToState(failureOrPosts));
      }else if(event is RefreshPostsEvent){
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts();
        emit(_mapFailureOrPostsToState(failureOrPosts));
      }
    });
  }

  PostsState _mapFailureOrPostsToState(Either<Failure,List<Post>> either ){
   return either.fold(
         (failure) => ErrorPostsState(message: _mapFailureToMessage(failure)),
         (posts) => LoadedPostsState(
       posts: posts,
     ),
    );
  }

  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OffLineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
