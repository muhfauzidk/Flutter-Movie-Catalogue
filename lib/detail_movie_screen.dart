import 'package:flutter/material.dart';

import 'data.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  double titleFontSize = 20.0;
  double descFontSize = 16.0;
  Color detailScreenBackgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: detailScreenBackgroundColor,
      appBar: AppBar(
        title: Text(widget.movie.title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              alignment: Alignment.center, // Center the image
              child: GestureDetector(
                onTap: () {
                  Stopwatch stopwatch = Stopwatch()
                    ..start(); // Start the stopwatch

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewScreen(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                      ),
                    ),
                  );

                  stopwatch.stop(); // Stop the stopwatch
                  print(
                      'onTap execution time: ${stopwatch.elapsed.inMilliseconds} milliseconds');
                },
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  height: 400,
                  width: 250,
                  fit: BoxFit.cover,
                ),
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
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.overview!,
                    style: TextStyle(fontSize: descFontSize),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Release Date',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.releaseDate!,
                    style: TextStyle(fontSize: descFontSize),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Vote Average',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.movie.voteAverage} (${widget.movie.voteCount} user)',
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

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              height: double.infinity,
              width: double.infinity,
            ),
            const BackButton(),
          ],
        ),
      ),
    );
  }
}
