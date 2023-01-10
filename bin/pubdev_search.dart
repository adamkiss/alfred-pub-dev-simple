import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pubdev_search/alfred.dart';


void _exit(String message, {int exitCode = 1}) {
	print(message); exit(exitCode);
}

Future<String> pubdev_search(String query, {int page = 1}) async {
	String url = 'https://pub.dev/packages?q=${Uri.encodeQueryComponent(query)}${page > 1 ? '&page=$page' : ''}';
	final r = await (await HttpClient().getUrl(Uri.parse(url))).close();
	return r.transform(utf8.decoder).join();
}

Map<String, dynamic> el_to_alfred(Element el) {
	final title = el.querySelector('h3 > a')!.text;
	final path  = el.querySelector('h3 > a')!.attributes['href'];
	final desc  = el.querySelector('.packages-description')!.text;

	return alf_valid_item(
		title, desc,
		uid: title,
		arg: path!.contains('http') ? path : 'https://pub.dev/${path}'
	);
}

void main(List<String> arguments) async {
	if (arguments.isEmpty || arguments.length > 1) {_exit('Wrong argument count.');	}
	final String query = arguments[0].trim();
	if (query.isEmpty) {_exit('Bad argument.'); }

	Document document = parse(await pubdev_search(query));
	final total = int.parse(
		document.querySelector('.listing-info-count .count')?.text ?? '0',
		radix: 10
	);

	if (total == 0) {
		alf_exit([
			alf_invalid_item(
				'No results found.',
				'pub.dev contains no results for "$query"'
			)
		]);
	}

	List<Map> results = document.querySelectorAll('.packages-item')
		.map((el) => el_to_alfred(el))
		.toList();

	if (total > 12) {
		document = parse(await pubdev_search(query, page: 2));
		results.addAll(
			document.querySelectorAll('.packages-item')
				.map((el) => el_to_alfred(el))
				.toList(growable: false)
		);
	}

	alf_exit(results);
}
