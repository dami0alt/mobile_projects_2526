import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/review.dart';

class MoviesController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedMovies = <Movie>[].obs;
  var watchListMovies = <Movie>[].obs;

  var selectedMovie = Movie(
          id: 0,
          title: '',
          posterPath: '',
          backdropPath: '',
          overview: '',
          releaseDate: '',
          voteAverage: 0,
          genreIds: List.empty())
      .obs;

  var movieReviews = <Review>[].obs;
  @override
  void onInit() async {
    isLoading.value = true;
    mainTopRatedMovies.value = (await ApiService.getTopRatedMovies())!;
    isLoading.value = false;
    super.onInit();
  }

  Future<void> loadMovieDetails(Movie movie) async {
    isLoading.value = true;
    selectedMovie.value = movie;
    movieReviews.clear();

    var reviews = await ApiService.getMovieReviews(movie.id);

    if (reviews != null) {
      movieReviews.value = reviews;
    }

    isLoading.value = false;
  }

  bool isInWatchList(Movie movie) {
    return watchListMovies.any((m) => m.id == movie.id);
  }

  void addToWatchList(Movie movie) {
    if (isInWatchList(movie)) {
      watchListMovies.remove(movie);
      Get.snackbar('Success', 'removed from watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    } else {
      watchListMovies.add(movie);
      Get.snackbar('Success', 'added to watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
  }
}
