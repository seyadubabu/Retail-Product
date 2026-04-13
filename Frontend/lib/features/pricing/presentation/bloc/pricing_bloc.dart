// EVENTS
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/pricing_repository_impl.dart';

abstract class PricingEvent {}

class LoadPricing extends PricingEvent {}
class LoadMorePricing extends PricingEvent {}
class RefreshPricing extends PricingEvent {}
class SearchPricing extends PricingEvent {
  final String query;
  SearchPricing(this.query);
}
class UploadCSVEvent extends PricingEvent {}
class UploadCSVFromAssetsEvent extends PricingEvent {}

class UpdatePricingEvent extends PricingEvent {
  final String id;
  final Map body;

  UpdatePricingEvent(this.id, this.body);
}


// STATES
abstract class PricingState {}

class PricingInitial extends PricingState {}
class PricingLoading extends PricingState {}
class PricingLoaded extends PricingState {
  final List data;
  PricingLoaded(this.data);
}

class PricingUploading extends PricingState {}

class PricingError extends PricingState {
  final String message;
  PricingError(this.message);
}

// BLOC
class PricingBloc extends Bloc<PricingEvent, PricingState> {
  final PricingRepositoryImpl repo;

  int page = 1;
  bool isLoadingMore = false;
  List allData = [];
  String searchQuery = '';

  PricingBloc(this.repo) : super(PricingInitial()) {
    on<LoadPricing>(_onLoad);
    on<LoadMorePricing>(_onLoadMore);
    on<RefreshPricing>(_onRefresh);
    on<SearchPricing>(_onSearch);
    on<UploadCSVEvent>(_onUploadCSV);
    on<UploadCSVFromAssetsEvent>(_onUploadCSVFromAssets);
    on<UpdatePricingEvent>(_onUpdate);
  }

  Future<void> _onLoad(LoadPricing event, Emitter emit) async {
    emit(PricingLoading());
    page = 1;
    final data = await repo.getPricing(page: page, query: searchQuery);
    allData = data;
    emit(PricingLoaded(allData));
  }

  Future<void> _onLoadMore(LoadMorePricing event, Emitter emit) async {
    if (isLoadingMore) return;
    isLoadingMore = true;

    page++;
    final data = await repo.getPricing(page: page, query: searchQuery);
    allData.addAll(data);

    emit(PricingLoaded(allData));
    isLoadingMore = false;
  }

  Future<void> _onRefresh(RefreshPricing event, Emitter emit) async {
    page = 1;
    final data = await repo.getPricing(page: page, query: searchQuery);
    allData = data;
    emit(PricingLoaded(allData));
  }

  Future<void> _onSearch(SearchPricing event, Emitter emit) async {
    searchQuery = event.query;
    page = 1;
    emit(PricingLoading());
    final data = await repo.getPricing(page: page, query: searchQuery);
    allData = data;
    emit(PricingLoaded(allData));
  }

  Future<void> _onUploadCSV(
      UploadCSVEvent event, Emitter<PricingState> emit) async {
    emit(PricingUploading());
    try {
      await repo.uploadCSV();
      final data = await repo.getPricing();
      emit(PricingLoaded(data));
    } catch (e) {
      emit(PricingError(e.toString()));
    }
  }

  Future<void> _onUploadCSVFromAssets(
      UploadCSVFromAssetsEvent event, Emitter<PricingState> emit) async {
    emit(PricingUploading());
    try {
      await repo.uploadCSVFromAssets();
      final data = await repo.getPricing();
      emit(PricingLoaded(data));
    } catch (e) {
      emit(PricingError(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdatePricingEvent event, Emitter<PricingState> emit) async {
    try {
      await repo.updatePricing(event.id, event.body);
      add(LoadPricing());
    } catch (e) {
      emit(PricingError(e.toString()));
    }
  }
}