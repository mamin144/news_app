import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:news_app/modules/home/model/news_model.dart';

class NewsCard extends StatelessWidget {
  final News article;
  final VoidCallback? onTap;


  const NewsCard({super.key, required this.article,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Card(

        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(12),
                child: Image.network(
                  article.urlToImage ??
                      "https://via.placeholder.com/300",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              /// TITLE (protected from overflow)
              Text(
                article.title ?? "No Title",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              /// DESCRIPTION (protected)
              // Text(
              //   article.description ?? "",
              //   maxLines: 3,
              //   overflow: TextOverflow.ellipsis,
              //   style: const TextStyle(
              //     color: Colors.grey,
              //   ),
              // ),

              const SizedBox(height: 8),

              /// AUTHOR
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'by ${article.author}' ?? "Unknown",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffA0A0A0),
                      ),
                    ),
                  ),
                  Text(
                    article.publishedAt.toString() ?? "Unknown",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffA0A0A0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
