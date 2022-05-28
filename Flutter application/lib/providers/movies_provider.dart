import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_movie_app/models/models.dart';
import 'package:flutter_movie_app/helpers/debouncer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = 'd9dc33dedfaefa4dba796f9bfe349400';
  String _language = 'en-US';
  String _myapi = 'http://recommendation19.herokuapp.com/?movie_name=avatar';

  List<Movie> onDisplayCardMovies = [];
  List<Movie> onDisplayCardPopularMovies = [];
  List<Movie> onDisplayCardRecommendedMovies = [];
  List<Movie> onDisplayCardTopRatedMovies = [];
  List<String> recommendations = [];
  Map<int, List<Cast>> moviesCasting = {};

  //To increment pagination for Popular movies
  int _popularPage = 0;
  int _topRatedPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

  Future<void> getlistdata() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? listids = prefs.getStringList('items');
    print(listids);
    if (listids == null) {
      recommendations = [];
    } else {
      recommendations = listids;
    }
    print(recommendations);
  }

  Future<void> adddata(List<String> userdata) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', userdata);
    print('saved');
  }

  // Future<void> incrementStartup() async{
  //   final prefs= await SharedPreferences.getInstance();
  //   List<String>? lastupdate= await getlistdata();
  //   List<String>? current=
  // }

  //Streams
  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;

  MoviesProvider() {
    print('MoviesProvider Running');
    loaddata();
    //_suggestionStreamController.close();
  }
  loaddata() async {
    this.getOnDisplayNowPlayingMovies();
    this.getOnDisplayPopularMovies();

    this.getOnDisplayTopRatedMovies();
    await this.getlistdata();
    this.getonDisplayCardRecommendedMovies(recommendations);
  }

  Future<List<String>> getData(String movie, String id) async {
    http.Response response = await http.post(Uri.parse(
      'http://recommendation19.herokuapp.com/?movie_name=$movie',
    ));
    // print(response.statusCode);
    var body = jsonDecode(response.body);
    // print(body);
    // print(body.length);
    for (int i = 0; i < body.length; i++) {
      recommendations.add(body[i]);
    }
    adddata(recommendations);

    // print(recommendations[5]);
    return recommendations;
  }

  Future<List<String>> getData1(String movie, String id) async {
    http.Response response = await http.get(Uri.parse(
      'http://api.themoviedb.org/3/movie/$id/recommendations?api_key=$_apiKey&language=en-US&page=1',
    ));
    // print(response.statusCode);
    var body = jsonDecode(response.body);
    // print(body);
    // print(body.length);
    var results = body['results'];
    for (int i = 0; i < 10; i++) {
      recommendations.add(results[i]['id'].toString());
    }

    // print(recommendations[5]);
    return recommendations;
  }

  Future<String> _getJsonData(String segmentUrl, [int page = 1]) async {
    final url = Uri.http(this._baseUrl, segmentUrl, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getRecommendedMovies(String id) async {
    http.Response response = await http.get(Uri.parse(
        "http://api.themoviedb.org/3/movie/$id?api_key=8a1227b5735a7322c4a43a461953d4ff&language=en-US"));
    // print(response.body);
    // print(Movie.fromrecommendJson(response.body));
    return Movie.fromrecommendJson(response.body);
  }

  getonDisplayCardRecommendedMovies(List<String> recommendationid) async {
    for (int i = 0; i < recommendationid.length; i++) {
      Movie data = await getRecommendedMovies(recommendationid[i]);
      this.onDisplayCardRecommendedMovies.add(data);
    }
    onDisplayCardRecommendedMovies =
        onDisplayCardRecommendedMovies.reversed.toList();
    notifyListeners();
    print(onDisplayCardRecommendedMovies);
  }

  getOnDisplayNowPlayingMovies() async {
    final jsonData = await this._getJsonData('3/movie/now_playing');

    //Call movie instance (Model)
    try {
      final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
      this.onDisplayCardMovies = nowPlayingResponse.results;
    } catch (e) {
      print(e);
    }
    //final Map<String, dynamic> decodedData = json.decode(response.body);
    //print(nowPlayingResponse.results[2].title);

    //Notify widgets when data are changing
    notifyListeners();
  }

  getOnDisplayPopularMovies() async {
    _popularPage++;

    final jsonData = await this._getJsonData('3/movie/popular', _popularPage);

    //Call movie instance (Model)
    final popularResponse = PopularResponse.fromJson(jsonData);

    this.onDisplayCardPopularMovies = [
      ...onDisplayCardMovies,
      ...popularResponse.results
    ];

    //Notify widgets when data are changing
    notifyListeners();
  }

  getOnDisplayTopRatedMovies() async {
    _topRatedPage++;

    final jsonData =
        await this._getJsonData('3/movie/top_rated', _topRatedPage);
    //Call model
    final topRatedResponse = TopRatedResponse.fromJson(jsonData);
    this.onDisplayCardTopRatedMovies = topRatedResponse.results;

    //Notify widgets when data are changing
    notifyListeners();
  }

  Future<List<Cast>> getMovieCasting(int movieId) async {
    //Check map to load info without another request
    if (moviesCasting.containsKey(movieId)) return moviesCasting[movieId]!;

    print('Requesting casting info');

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCasting[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  //To seach movies via query param
  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.http(this._baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final searchResponse = SearchMovieResponse.fromJson(response.body);

    return searchResponse.results;
  }

  //To debouncer query
  void getSuggestionsByQuery(String searchWord) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      //When deboucer emit a value
      //print('Have a value to search: $value');
      final results = await this.searchMovie(value);
      //Add event with results for stream
      this._suggestionStreamController.add(results);
    };

    //When stop debouncer typing
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchWord;
    });

    //Cancel timer periodic execution
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
