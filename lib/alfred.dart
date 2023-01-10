/*
 * Helper functions for Alfred
 *
 * - alf_to_results
 * - alf_exit
 * - alf_invalid_item
 * - alf_valid_item
 */

import 'dart:convert';
import 'dart:io';

String alf_to_results (List<Map> results) {
	return jsonEncode({'items': results});
}

void alf_exit(List<Map> results) {
	print(alf_to_results(results));
	exit(0);
}

Map<String, dynamic> alf_valid_item (
	String title,
	String subtitle,
	{
		String? uid,
		Map? icon,
		String? arg,
		Map? mods,
		Map? variables,
		Map? text,
		String? quicklookurl
	}
) {
	final Map<String, dynamic> result = {
		'title': title,
		'subtitle': subtitle,
		'valid': true
	};
	if (icon != null) { result['icon'] = icon; }
	if (arg != null)  { result['arg']  = arg;}
	if (mods != null) { result['mods'] = mods; }
	if (text != null) { result['text'] = text; }
	if (variables != null) { result['variables'] = variables; }
	if (quicklookurl != null) { result['quicklookurl'] = quicklookurl; }
	return result;
}

Map<String, dynamic> alf_invalid_item (
	String title,
	String subtitle,
	{
		String? uid,
		Map? icon,
		String? arg,
		Map? mods,
		Map? variables,
		Map? text,
		String? quicklookurl
	}
) {
	final Map<String, dynamic> result = {
		'title': title,
		'subtitle': subtitle,
		'valid': false
	};
	if (icon != null) { result['icon'] = icon; }
	if (arg != null)  { result['arg']  = arg;}
	if (mods != null) { result['mods'] = mods; }
	if (text != null) { result['text'] = text; }
	if (variables != null) { result['variables'] = variables; }
	if (quicklookurl != null) { result['quicklookurl'] = quicklookurl; }
	return result;
}