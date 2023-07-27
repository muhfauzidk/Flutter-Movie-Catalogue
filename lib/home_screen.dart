import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_catalogue/data.dart';
import 'package:movie_catalogue/detail_movie_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie>? movies;
  bool isLoading = false;

  final int pageSize = 20;
  int totalMovies = 20;

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

  double titleFontSize = 20.0;
  Color homeScreenBackgroundColor = Colors.white;

  void increaseTitleFontSize() {
    setState(() {
      titleFontSize += 5;
    });
  }

  void decreaseFontSize() {
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

  void changeTotalMovies(int total) {
    setState(() {
      totalMovies = total;
    });
    fetchMovies();
  }

  String searchQuery = '';

  void searchMovies(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<Movie> getFilteredMovies() {
    if (searchQuery.isEmpty) {
      return movies ?? [];
    } else {
      return (movies ?? []).where((movie) {
        final lowerCaseTitle = movie.title?.toLowerCase() ?? '';
        final lowerCaseQuery = searchQuery.toLowerCase();
        return lowerCaseTitle.contains(lowerCaseQuery);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeScreenBackgroundColor,
      appBar: AppBar(
        title: const Text("Movie Catalogue"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? query = await showSearch<String?>(
                context: context,
                delegate: MovieSearchDelegate(movies: movies),
              );
              if (query != null) {
                searchMovies(query);
              }
            },
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Increase font size"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Decrease font size"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Change background color"),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("Change to default"),
                ),
                const PopupMenuItem<int>(
                  value: 4,
                  child: Text("Total data"),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                increaseTitleFontSize();
              } else if (value == 1) {
                decreaseFontSize();
              } else if (value == 2) {
                changeBackgroundColor();
              } else if (value == 3) {
                changeToDefault();
              } else if (value == 4) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Select Total Movies'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              changeTotalMovies(100);
                              Navigator.of(context).pop();
                            },
                            child: const Text('100 Movies'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              changeTotalMovies(500);
                              Navigator.of(context).pop();
                            },
                            child: const Text('500 Movies'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              changeTotalMovies(1000);
                              Navigator.of(context).pop();
                            },
                            child: const Text('1.000 Movies'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              changeTotalMovies(5000);
                              Navigator.of(context).pop();
                            },
                            child: const Text('5.000 Movies'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              changeTotalMovies(10000);
                              Navigator.of(context).pop();
                            },
                            child: const Text('10.000 Movies'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getFilteredMovies().isEmpty
              ? const Center(
                  child: Text('No movies found.'),
                )
              : ListView.separated(
                  itemCount: getFilteredMovies().length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    color: Colors.grey,
                  ),
                  itemBuilder: (context, index) {
                    final movie = getFilteredMovies()[index];
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate<String?> {
  final List<Movie>? movies; // Pass the list of movies to the delegate

  MovieSearchDelegate({this.movies});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Movie> searchResults = movies?.where((movie) {
          final title = movie.title ?? '';
          final lowerCaseTitle = title.toLowerCase();
          final lowerCaseQuery = query.toLowerCase();
          return lowerCaseTitle.contains(lowerCaseQuery);
        }).toList() ??
        [];

    return ListView.separated(
      itemCount: searchResults.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final Movie movie = searchResults[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: ListTile(
            title: Text(movie.title!),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Movie> suggestions = movies?.where((movie) {
          final title = movie.title ?? '';
          final lowerCaseTitle = title.toLowerCase();
          final lowerCaseQuery = query.toLowerCase();
          return lowerCaseTitle.contains(lowerCaseQuery);
        }).toList() ??
        [];

    return ListView.separated(
      itemCount: suggestions.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final Movie movie = suggestions[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: ListTile(
            title: Text(movie.title!),
          ),
        );
      },
    );
  }
}
