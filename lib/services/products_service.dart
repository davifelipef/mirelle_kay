import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

final productsBox = Hive.box("products_box");

Future<void> fetchProductDetails() async {
  const sitemapUrl = 'https://loja.marykay.com.br/sitemap/product-0.xml';

  final sitemapResponse = await http.get(Uri.parse(sitemapUrl));

  int productKey = 0;

  Set<int> fetchedProductKeys = {};

  if (sitemapResponse.statusCode == 200) {
    print("Response OK");

    var document = parse(sitemapResponse.body);
    var urls = document.getElementsByTagName('loc');

    for (var urlElement in urls) {
      var productUrl = urlElement.text;
      final response = await http.get(Uri.parse(productUrl));

      if (response.statusCode == 200) {
        var productDocument = parse(response.body);

        // Extract product name
        var titleElement =
            productDocument.querySelector('title[data-react-helmet="true"]');
        var productName = titleElement?.text ?? '';

        // Filter out "- Mary Kay" from product name
        productName = productName.replaceAll('- Mary Kay', '').trim();

        // Extract product image URL
        var imageElement =
            productDocument.querySelector('meta[property="og:image"]');
        var imageUrl = imageElement?.attributes['content'] ?? '';

        // Extract product price
        var priceElement = productDocument
            .querySelector('meta[property="product:price:amount"]');
        var price = priceElement?.attributes['content'] ?? '';

        // Extract product reference number
        var skuElement =
            productDocument.querySelector('meta[property="product:sku"]');
        var referenceNumber = skuElement?.attributes['content'] ?? '';

        // Extract product availability
        var availabilityElement = productDocument
            .querySelector('meta[property="product:availability"]');
        var availability = availabilityElement?.attributes['content'] ?? '';

        if (availability != 'oos') {
          productKey++;
          fetchedProductKeys.add(productKey);

          print('Produtos armazenados: ${fetchedProductKeys.length}');

          // Calls the helper function that saves the products to the hive box
          saveProducts(productKey, productName, imageUrl, price,
              referenceNumber, availability);

          /* Debug prints
          print('Product key assigned: $productKey');
          print('Key: $productKey');
          print('Name: $productName');
          print('Image URL: $imageUrl');
          print('Price: $price');
          print('Reference Number: $referenceNumber');
          print('Availability: $availability');
          print('---');*/
        } else {
          print('$productName está fora de estoque.');
          print('---');
        }
      } else {
        print('Failed to load product details');
      }
    }
  } else {
    print('Failed to load sitemap');
  }
}

void saveProducts(
    productKey, productName, imageUrl, price, referenceNumber, availability) {
  // Create a map for the product
  var productMap = {
    'key': productKey,
    'name': productName,
    'imageUrl': imageUrl,
    'price': price,
    'referenceNumber': referenceNumber,
    'availability': availability,
  };

  print('$productName saved to the hive box');

  // Store the product in Hive
  productsBox.put(productKey, productMap);
}

/*void main() async {
  print('Fetching product details...');
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Open the hive box
  Hive.openBox("products_box");
  await fetchProductDetails();
}*/
