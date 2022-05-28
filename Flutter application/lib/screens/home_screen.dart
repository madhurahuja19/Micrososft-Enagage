import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/providers/movies_provider.dart';
import 'package:flutter_movie_app/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_movie_app/search/search_delegate.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Provider
    final moviesProvider = Provider.of<MoviesProvider>(context);

    //print(moviesProvider.onDisplayCardMovies);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'NEXTFLIX',
            style: GoogleFonts.robotoCondensed(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 35.0,
                letterSpacing: 1.0),

            // style: TextStyle(
          ),
          elevation: 1,
          actions: [
            IconButton(
                onPressed: () => showSearch(
                    context: context, delegate: MovieSearchDelegate()),
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, 'signin');
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Swiper cards
              CardSwiper(movies: moviesProvider.onDisplayCardMovies),
              //Horizontal movies container
              moviesProvider.onDisplayCardRecommendedMovies.length != 0
                  ? MovieHorizontalSlider(
                      movies: moviesProvider.onDisplayCardRecommendedMovies,
                      title: 'Recommendations',
                      onNextPage: () => {},
                      //populars
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              MovieHorizontalSlider(
                movies: moviesProvider.onDisplayCardPopularMovies,
                title: 'Most Popular',
                onNextPage: () => {
                  print('Here: Execute another fetch'),
                  moviesProvider.getOnDisplayPopularMovies(),
                }, //populars
              ),
              MovieHorizontalSlider(
                movies: moviesProvider.onDisplayCardTopRatedMovies,
                title: 'Top Rated',
                onNextPage: () => {
                  //print('Here: Execute another fetch'),
                  moviesProvider.getOnDisplayTopRatedMovies(),
                }, //populars
              ),
            ],
          ),
        ));
  }
}
