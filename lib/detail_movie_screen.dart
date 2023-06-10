import 'package:flutter/material.dart';

import 'data.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  double titleFontSize = 20.0;
  double descFontSize = 16.0;
  Color homeScreenBackgroundColor = Colors.white;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              alignment: Alignment.center, // Center the image
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 400,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movie.overview!,
                    style: TextStyle(fontSize: descFontSize),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Release Date',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movie.releaseDate!,
                    style: TextStyle(fontSize: descFontSize),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Genres',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movie.genres != null ? movie.genres!.join(", ") : '',
                    style: TextStyle(fontSize: descFontSize),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Vote Average',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movie.voteAverage.toString() +
                        ' (' +
                        movie.voteCount.toString() +
                        ' user)',
                    style: TextStyle(fontSize: descFontSize),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
