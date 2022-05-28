import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/providers/movies_provider.dart';
import 'package:flutter_movie_app/widgets/widgets.dart';
import 'package:flutter_movie_app/models/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // @override
  // void initState() async {
  //   super.initState();
  //   // Obtain shared preferences.
  //   instanciate();
  // }

  @override
  Widget build(BuildContext context) {
    //Receive args
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    List<Movie> recommendations = [];
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      // backgroundColor: Colors.black54,
      body: CustomScrollView(
        //Widgets that have specific actitude when scrooll is active
        slivers: [
          _CustomAppBar(
            movie: movie,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie: movie, recommendations: recommendations),
              _Overview(
                movie: movie,
              ),
              Column(
                children: [
                  Container(color: Colors.black54, height: 30),
                  CastingCards(
                    movieId: movie.id,
                  ),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
            color: Colors.black12,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(bottom: 15),
              child: Text(
                movie.title,
                style: GoogleFonts.robotoCondensed(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0),
              ),
            )),
        background: FadeInImage(
            placeholder: AssetImage('assets/loading.gif'),
            image: NetworkImage(movie.fullBackdropPath),
            fit: BoxFit.cover),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  final List<Movie> recommendations;
  const _PosterAndTitle({required this.movie, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.black54,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterPath),
                height: 150,
                width: 100,
              ),
            ),
          ),
          SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.originalTitle,
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
                Text(movie.originalLanguage.toUpperCase(),
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
                Row(
                  children: [
                    Icon(Icons.star_border_outlined,
                        size: 25, color: Colors.amber),
                    SizedBox(width: 5),
                    Text(
                      movie.voteAverage,
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: 15.0,
                          letterSpacing: 1.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        (movie.adult) ? 'Adult' : 'All public',
                        style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontSize: 15.0,
                            letterSpacing: 1.0),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.arrowtriangle_right_circle_fill,
                  color: Colors.white,
                  size: 65.0,
                ),
                onPressed: () async {
                  print(movie.id);
                  List<String> recommendationid = [];
                  try {
                    recommendationid = await Provider.of<MoviesProvider>(
                            context,
                            listen: false)
                        .getData(movie.title, movie.id.toString());
                  } catch (e) {
                    recommendationid = await Provider.of<MoviesProvider>(
                            context,
                            listen: false)
                        .getData1(movie.title, movie.id.toString());
                  }

                  // print(recommendationid);
                  Provider.of<MoviesProvider>(context, listen: false)
                      .getonDisplayCardRecommendedMovies(recommendationid);

                  // for (int i = 0; i < recommendationid.length; i++) {
                  //   Movie data = await MoviesProvider()
                  //       .getRecommendedMovies(recommendationid[i]);
                  //   recommendations.add(data);
                  // }
                  // print(recommendations);
                },
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'Synopsis',
                textAlign: TextAlign.left,
                style: GoogleFonts.robotoCondensed(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0),
              ),
            ),
            Text(movie.overview,
                textAlign: TextAlign.left,
                style: GoogleFonts.robotoCondensed(
                    color: Colors.white, fontSize: 15.0, letterSpacing: 1.0)),
          ],
        ));
  }
}
