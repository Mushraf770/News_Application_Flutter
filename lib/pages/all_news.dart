import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsdash/models/article_model.dart';
import 'package:newsdash/models/slider_model.dart';
import 'package:newsdash/pages/article_view.dart';
import 'package:newsdash/services/news.dart';
import 'package:newsdash/services/slider_data.dart';

class AllNews extends StatefulWidget {
  final String news;
  const AllNews({super.key, required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<SliderModel> sliders = [];

  List<ArticleModel> articles = [];

  @override
  void initState() {
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {});
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.sliders;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.news} News",
          style: TextStyle(
              color: Colors.deepPurple.shade800, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount:
                widget.news == "Breaking" ? sliders.length : articles.length,
            itemBuilder: (context, index) {
              return AllNewsSection(
                  image: widget.news == "Breaking"
                      ? sliders[index].urlToImage!
                      : articles[index].urlToImage!,
                  desc: widget.news == "Breaking"
                      ? sliders[index].description!
                      : articles[index].description!,
                  title: widget.news == "Breaking"
                      ? sliders[index].title!
                      : articles[index].title!,
                  url: widget.news == "Breaking"
                      ? sliders[index].url!
                      : articles[index].url!);
            }),
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  final String image, desc, title, url;
  const AllNewsSection(
      {super.key,
      required this.image,
      required this.desc,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(
              blogUrl: url,
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
            Text(
              desc,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
