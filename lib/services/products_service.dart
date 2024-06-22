import 'package:mirelle_kay/utils/config.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

// Captures the products from the internet
Future<void> getProducts(int? itemKey) async {
  if (itemKey != null) {
    // Check if dividends for the itemKey have already been fetched
    if (fetchedProductKeys.contains(itemKey)) {
      print("Product for key $itemKey have already been fetched. Skipping...");
      return;
    }
    fetchedProductKeys.add(itemKey);
    final existingProduct =
        products.firstWhere((element) => element["key"] == itemKey);
    final product = existingProduct["product"];
    print("O product recebido para pesquisa é $product");
    final headers = {
      "User-Agent":
          "Mozilla/5.0 (Linux; Android 12; Pixel 6 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Mobile Safari/537.36"
    };

    // Check if product already exists in productsList before making requests
    if (productsList.contains(product)) {
      print(
          "O produto $product já foi pesquisado anteriormente. Pulando a pesquisa.");
      return;
    } else {
      if (product) {
        // First tries the FII url
        var url = "https://loja.marykay.com.br/cuidados-Faciais";
        print("fetching the url $url");

        // Wait 5 seconds before making the request
        await Future.delayed(const Duration(seconds: 5));
        print("5 seconds pause between requests");

        try {
          final response =
              await dio.get(url, options: Options(headers: headers));
          print("$url está sendo aberta");
          var document = parse(response.data);
          // Try to access the page
          if (response.statusCode == 200) {
            productsList.add(product);
            print("$product added to the productsList");
            print("Current product list is: $productsList");
            // Gets the current stock value
            var stockValue = document.querySelector(
                'div[title="Valor atual do ativo"] > strong[class="value"]');
            var tableRows =
                document.querySelectorAll('table tbody tr:first-child');
            print("The tableRows are $tableRows");
            var currentMonth =
                formattedDate.split('/')[1]; // Extract target month
            var totalDividend = 0.00;
            if (tableRows.isNotEmpty) {
              var row = tableRows[0];
              print("Children of row $row");
              var children = row.children;
              if (children.length >= 4) {
                var paymentDate = children[2].text;
                var paymentMonth = paymentDate.split('/')[1];
                print("Date fetched is $paymentDate");
                print("Month fetched is $paymentMonth");
                if (paymentMonth == currentMonth) {
                  var dividendValue = children[3].text;
                  print("Dividend value fetched is $dividendValue");
                  totalDividend +=
                      double.parse(dividendValue.replaceAll(',', '.'));
                  print(
                      "Total dividends fetched for this item is $totalDividend");
                }
              } else {
                print("Row $row does not have enough elements.");
              }
            }

            var lastProduct = totalDividend;
            print(stockValue?.text);
            print("Last dividend payed is: $lastProduct");

            try {
              print("Updating products map");
              productsMap[itemKey] = lastProduct.toString();
              print("Current dividends map is: $productsMap");
              //_refreshItems();
            } catch (e) {
              print("Error setting dividend: $e");
            }
          } else {
            // #TODO FII-infra logic enters here
            print("StatusCode: ${response.statusCode}");
            print("Response body: $response");
          }
        } catch (e) {
          print("Erro ao fazer a requisição: $e");
        }
      } else {
        // #TODO Ações logic enters here

        // Wait 5 seconds before making the request
        await Future.delayed(const Duration(seconds: 5));
        print("5 seconds pause between requests");

        // Tries the acoes url
        var url = "https://statusinvest.com.br/acoes/$product";

        try {
          final response =
              await dio.get(url, options: Options(headers: headers));
          print("$url está sendo aberta");
          var document = parse(response.data);
          // Try to access the page
          if (response.statusCode == 200) {
            var stockValue = document.querySelector(
                'div[title="Valor atual do ativo"] > strong[class="value"]');
            var lastProduct = document.querySelector(
                'div[class="d-flex align-items-center"] > strong[class="value d-inline-block fs-5 fw-900"]');
            print(stockValue?.text);
            print(lastProduct?.text);

            if (stockValue != null) {
              print("O product $product é uma ação.");
              productsList.add(product);
              print("products já pesquisados: $productsList");
            } else {
              // do nothing
            }
          } else {
            print("StatusCode: ${response.statusCode}");
            print("Response body: $response");
          }
        } catch (e) {
          print("Erro ao fazer a requisição: $e");
        }
      }
    }
  }
}
