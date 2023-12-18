import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dio_interceptor/interceptor/dio_connectivity_request_retrier.dart';
import 'package:flutter_dio_interceptor/interceptor/retry_interceptor.dart';
import 'package:flutter_dio_interceptor/quotes_dto.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dio? dio;
  bool isLoading = false;
  QuotesDto? _quotesDto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _quotesDto?.quotes?.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(15),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                _quotesDto?.quotes?[index].quote ?? "Nulll"),
                          ),
                        );
                      },
                    ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => fetchDataFromServer(),
                  child: const Text("Request Data"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  fetchDataFromServer() async {
    setState(() => isLoading = true);
    final response = await dio
        ?.get("https://dummyjson.com/quotes")
        .onError((error, stackTrace) {
      print(error);
      setState(() => isLoading = false);
      return Response(requestOptions: RequestOptions());
    });

    setState(() {
      _quotesDto = QuotesDto.fromJson(response?.data);
    });

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    dio = Dio();
    isLoading = false;
    dio?.interceptors.add(
      RetryOnConnectionChangeInterceptor(
          requestRetrier: DioConnectivityRequestRetrier(
        dio: Dio(),
        connectivity: Connectivity(),
      )),
    );
    super.initState();
  }
}
