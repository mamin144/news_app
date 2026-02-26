import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Api/api_manger.dart';
import '../model/sources_model.dart';

part 'sources_state.dart';

class SourcesCubit extends Cubit<SourcesState> {

  SourcesCubit() : super(SourcesInitial());


  Future<SourcesResponse> getSources(String category) async {
   try{
     emit(SourcesLoading());
     var sources = await ApiManger().getSources(category);
     emit(SourcesLoaded(
       sources
     ));
     return sources;
   }catch(e){
     emit(SourcesError(
         e.toString()
     ));
     rethrow;
   }


  }




}
