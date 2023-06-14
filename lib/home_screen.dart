import 'package:movie_catalogue/data.dart';
import 'package:movie_catalogue/detail_movie_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie>? movies;
  bool isLoading = false;

  int currentPage = 1;
  final int pageSize = 20;
  final int totalMovies = 10000;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
    });

    const apiKey = '2fe3e094d05ea48ef1cd132381a4708b';

    // Calculate the total number of pages required based on the total movies and page size
    final int totalPages = (totalMovies / pageSize).ceil();

    // Create an empty list to store all the fetched movies
    List<Movie> allMovies = [];

    for (int page = 1; page <= totalPages; page++) {
      final url = Uri.https(
        'api.themoviedb.org',
        '/3/movie/popular',
        {'api_key': apiKey, 'page': '$page'},
      );

      try {
        final response = await http.get(url);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final movieListResponse = MovieListResponse.fromJson(jsonData);
          allMovies.addAll(movieListResponse.results!);

          // // Fetch the genre names for each movie
          // await fetchGenresForMovies(allMovies);

          // Update the current page to the next page
          currentPage = page;

          // Check if we have fetched the desired number of movies
          if (allMovies.length >= totalMovies) {
            break;
          }
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    setState(() {
      isLoading = false;
      movies = allMovies;
    });
  }

  // Future<void> fetchGenresForMovies(List<Movie> movies) async {
  //   const apiKey = '2fe3e094d05ea48ef1cd132381a4708b';
  //   for (var movie in movies) {
  //     final genreUrl = Uri.https(
  //       'api.themoviedb.org',
  //       '/3/movie/${movie.id}',
  //       {'api_key': apiKey},
  //     );

  //     try {
  //       final genreResponse = await http.get(genreUrl);
  //       print('Genre Response status: ${genreResponse.statusCode}');
  //       print('Genre Response body: ${genreResponse.body}');

  //       if (genreResponse.statusCode == 200) {
  //         final genreData = jsonDecode(genreResponse.body);
  //         final genreIds = genreData['genres'];

  //         if (genreIds != null) {
  //           movie.genres = genreIds
  //               .map<String>((genre) => genre['name'].toString())
  //               .toList();
  //         }
  //       } else {
  //         print('Error: ${genreResponse.statusCode}');
  //       }
  //     } catch (e) {
  //       print('Error: $e');
  //     }
  //   }
  // }

  double titleFontSize = 20.0;
  double descFontSize = 14.0;
  Color homeScreenBackgroundColor = Colors.white;

  void increaseTitleFontSize() {
    setState(() {
      titleFontSize += 5;
    });
  }

  void decreaseTitleFontSize() {
    setState(() {
      titleFontSize -= 5;
    });
  }

  void changeBackgroundColor() {
    setState(() {
      homeScreenBackgroundColor = Colors.cyan;
    });
  }

  void changeToDefault() {
    setState(() {
      titleFontSize = 20.0;
      homeScreenBackgroundColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeScreenBackgroundColor,
      appBar: AppBar(
        title: const Text("Movie Catalogue"),
        centerTitle: true,
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
                increaseTitleFontSize();
              } else if (value == 1) {
                decreaseTitleFontSize();
              } else if (value == 2) {
                changeBackgroundColor();
              } else if (value == 3) {
                changeToDefault();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : movies != null && movies!.isNotEmpty
              ? ListView.separated(
                  itemCount: movies!.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    color: Colors.grey,
                  ),
                  itemBuilder: (context, index) {
                    final movie = movies![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movie: movie),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                movie.getPosterUrl(),
                                height: 150,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title ?? '',
                                      style: TextStyle(
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 15),
                                    // Text(
                                    //   movie.genres != null
                                    //       ? movie.genres!.join(", ")
                                    //       : '',
                                    //   style: TextStyle(fontSize: descFontSize),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No movies found.'),
                ),
    );
  }
}
