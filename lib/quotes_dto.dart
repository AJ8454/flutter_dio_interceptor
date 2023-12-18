// To parse this JSON data, do
//
//     final quotesDto = quotesDtoFromJson(jsonString);

import 'dart:convert';

QuotesDto quotesDtoFromJson(String str) => QuotesDto.fromJson(json.decode(str));

String quotesDtoToJson(QuotesDto data) => json.encode(data.toJson());

class QuotesDto {
  final List<Quote>? quotes;
  final int? total;
  final int? skip;
  final int? limit;

  QuotesDto({
    this.quotes,
    this.total,
    this.skip,
    this.limit,
  });

  factory QuotesDto.fromJson(Map<String, dynamic> json) => QuotesDto(
        quotes: json["quotes"] == null
            ? []
            : List<Quote>.from(json["quotes"]!.map((x) => Quote.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "quotes": quotes == null
            ? []
            : List<dynamic>.from(quotes!.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class Quote {
  final int? id;
  final String? quote;
  final String? author;

  Quote({
    this.id,
    this.quote,
    this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json["id"],
        quote: json["quote"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quote": quote,
        "author": author,
      };
}
