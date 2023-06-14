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

  void increaseFontSize() {
    setState(() {
      titleFontSize += 5;
      descFontSize += 5;
    });
  }

  void decreaseFontSize() {
    setState(() {
      titleFontSize -= 5;
      descFontSize -= 5;
    });
  }

  void changeBackgroundColor() {
    setState(() {
      detailScreenBackgroundColor = Colors.cyan;
    });
  }

  void changeToDefault() {
    setState(() {
      titleFontSize = 20.0;
      descFontSize = 16.0;
      detailScreenBackgroundColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: detailScreenBackgroundColor,
      appBar: AppBar(
        title: Text(widget.movie.title!),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Increase title font size"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Decrease title font size"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Change background color"),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("Change to default"),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                increaseFontSize();
              } else if (value == 1) {
                decreaseFontSize();
              } else if (value == 2) {
                changeBackgroundColor();
              } else if (value == 3) {
                changeToDefault();
              }
            },
          ),
        ],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewScreen(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'),
                    ),
                  );
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
                    'Genres',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.genres != null
                        ? widget.movie.genres!.join(", ")
                        : '',
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
  const ImageViewScreen({super.key, required this.imageUrl});
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
