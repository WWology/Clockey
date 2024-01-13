import 'dart:io';

import 'package:intl/intl.dart';

import '../data/events/events.dart';
import 'style.dart';

String dateInput(DateTime date) {
  return '''<div>
	<p class="c10 c15"><span class="c11"></span></p>
</div>
<p class="c15 c43"><span class="c36 c45"></span></p>
<a id="t.daf410bc928add9f130f7cac79689536f5d92f45"></a><a id="t.0"></a>
<table class="c31">
	<tr class="c32">
		<td class="c16" colspan="1" rowspan="1">
			<ol class="c6 lst-kix_list_1-1 start" start="1">
				<li class="c40">
					<h2 style="display: inline"><span>Name</span></h2>
				</li>
			</ol>
		</td>
		<td class="c24" colspan="1" rowspan="1">
			<ol class="c6 lst-kix_list_1-0 start" start="1">
				<li class="c5">
					<h1 style="display: inline">
						<span class="c9 c26">Monthly invoice</span>
					</h1>
				</li>
			</ol>
		</td>
	</tr>
	<tr class="c42">
		<td class="c16" colspan="1" rowspan="1">
			<p class="c10"><span class="c7">Address Line 1</span></p>
			<p class="c10"><span class="c7">Address Line 2</span></p>
			<p class="c10"><span class="c7">Postcode</span></p>
			<p class="c10"><span class="c7">Phone</span></p>
			<p class="c10"><span class="c7">Email</span></p>
			<p class="c10 c15"><span class="c7"></span></p>
		</td>
		<td class="c24" colspan="1" rowspan="1">
			<p class="c0"><span class="c11"></span></p>
			<p class="c21">
				<span class="c9 c23">&nbsp;</span
				><span class="c23 c9">${DateFormat('dd/MM/yyyy').format(date)}</span>
			</p>
		</td>
	</tr>
	<tr class="c35">
		<td class="c16" colspan="1" rowspan="1">
			<p class="c10"><span class="c23 c9">FAO</span></p>
			<p class="c10"><span class="c7">OG ESPORTS A/S</span></p>
			<p class="c10"><span class="c7">c/o Christen Kjaerulff,</span></p>
			<p class="c10"><span class="c7">Fredericiagade 15B, st. th.</span></p>
			<p class="c10"><span class="c7">1310 Copenhagen</span></p>
			<p class="c10">
				<span class="c36">CVR : 40035885</span><span class="c7"><br /></span>
			</p>
		</td>
		<td class="c24" colspan="1" rowspan="1">
			<p class="c21"><span class="c23 c9">&nbsp;</span></p>
		</td>
	</tr>
</table>
<p class="c43 c15"><span class="c11"></span></p>
<a id="t.e5f704be30229aaf152d81650015f0606b60c6b5"></a><a id="t.1"></a>''';
}

const String tableColumnName = '''<table class="c31">
	<thead>
		<tr class="c8">
			<td class="c41" colspan="1" rowspan="1">
				<ol class="c6 lst-kix_list_1-4 start" start="1">
					<li class="c13 c33">
						<h5 style="display: inline">
							<span class="c9 c30">Description</span>
						</h5>
					</li>
				</ol>
			</td>
			<td class="c28" colspan="1" rowspan="1">
				<ol class="c6 lst-kix_list_1-4" start="2">
					<li class="c5 c37">
						<h5 style="display: inline"><span class="c9 c30">Amount</span></h5>
					</li>
				</ol>
			</td>
			<tbody></tbody>
		</tr>
		<tr class="c8">
			<td class="c25" colspan="1" rowspan="1">
				<p class="c13"><span class="c2 c39"></span></p>
			</td>
			<td class="c44" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>''';

String dotaEventsRows(List<Event> dotaEvents) {
  String dotaSections = '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<p class="c4"><span class="c9">Dota</span></p>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c7"></span></p>
			</td>
		</tr>''';

  for (final dotaEvent in dotaEvents) {
    dotaSections += '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<ul class="c6 lst-kix_87mbg6thn9c7-0 start">
					<li class="c4 c12 li-bullet-0">
						<span class="c11">${dotaEvent.name} - ${DateFormat('dd/MM/yyyy').format(dotaEvent.time)}</span>
					</li>
				</ul>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c11">${dotaEvent.hours}hrs/${dotaEvent.hours * 12}€</span></p>
			</td>
		</tr>''';
  }

  dotaSections += '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<p class="c4 c15"><span class="c17 c9"></span></p>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>''';

  return dotaSections;
}

String csEventRows(List<Event> csEvents) {
  String csSections = '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<p class="c4"><span class="c9">CS</span></p>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>''';

  for (final csEvent in csEvents) {
    csSections += '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<ul class="c6 lst-kix_87mbg6thn9c7-0 start">
          <li class="c4 c12 li-bullet-0">
            <span class="c11">${csEvent.name} - ${DateFormat('dd/MM/yyyy').format(csEvent.time)}</span>
          </li>
        </ul>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0">${csEvent.hours}hrs/${csEvent.hours * 12}€<span class="c11"></span></p>
			</td>
		</tr>''';
  }

  csSections += '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<p class="c4 c15"><span class="c17 c9"></span></p>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>''';

  return csSections;
}

String rlEventRows(List<Event> rlEvents) {
  String rlSections = '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<p class="c4"><span class="c9">Rocket League</span></p>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>''';

  for (final rlEvent in rlEvents) {
    rlSections += '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<ul class="c6 lst-kix_87mbg6thn9c7-0 start">
          <li class="c4 c12 li-bullet-0">
            <span class="c11">${rlEvent.name} - ${DateFormat('dd/MM/yyyy').format(rlEvent.time)}</span>
          </li>
        </ul>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0">${rlEvent.hours}hrs/${rlEvent.hours * 12}€<span class="c11"></span></p>
			</td>
		</tr>''';
  }

  rlSections += '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<p class="c4 c15"><span class="c17 c9"></span></p>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>''';

  return rlSections;
}

String otherEventRows(List<Event> otherEvents) {
  String otherSections = '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<p class="c4"><span class="c9">Other</span></p>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>''';

  for (final otherEvent in otherEvents) {
    otherSections += '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<ul class="c6 lst-kix_87mbg6thn9c7-0 start">
          <li class="c4 c12 li-bullet-0">
            <span class="c11">${otherEvent.name} - ${DateFormat('dd/MM/yyyy').format(otherEvent.time)}</span>
          </li>
        </ul>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0">${otherEvent.hours}hrs/${otherEvent.hours * 12}€<span class="c11"></span></p>
			</td>
		</tr>''';
  }

  otherSections += '''<tr class="c8">
			<td class="c3" colspan="1" rowspan="1">
				<p class="c4 c15"><span class="c17 c9"></span></p>
			</td>
			<td class="c1" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>''';

  return otherSections;
}

String totalHoursRow(int hours) {
  return '''<tr class="c8">
			<td class="c27" colspan="1" rowspan="1">
				<p class="c4 c15"><span class="c17 c9"></span></p>
			</td>
			<td class="c14" colspan="1" rowspan="1">
				<p class="c0"><span class="c11"></span></p>
			</td>
		</tr>
		<tr class="c8">
			<td class="c22" colspan="1" rowspan="1">
				<p class="c13"><span class="c23 c9">Total</span></p>
			</td>
			<td class="c38" colspan="1" rowspan="1">
				<p class="c21"><span class="c17 c9">${hours}hrs/${hours * 12}€</span></p>
			</td>
		</tr>
	</thead>
</table>
<p class="c18">
	<span class="c11">IBAN for payment - </span><span class="c17 c9"></span>
</p>
<p class="c18">
	<span class="c11">SWIFT/BIC - </span><span class="c17 c9"></span>
</p>
<p class="c18"><span class="c11">Payment is due within 7 days.</span></p>
<p class="c18">
	<span class="c11"
		>If you have any questions concerning this invoice, contact Name | Mobile|
		Email</span
	>
</p>
<ol class="c6 lst-kix_list_1-3 start" start="1">
	<li class="c19">
		<h4 style="display: inline">
			<span class="c2">Thank you for your business!</span>
		</h4>
	</li>
</ol>''';
}

Future<File> createHtml(
  Map<String, List<Event>> eventsWorked,
  int gardenerID,
) async {
  final filename = 'invoice.html';
  int totalHours = 0;
  List<Event> dotaEventsWorked = [],
      csEventsWorked = [],
      rlEventsWorked = [],
      otherEventsWorked = [];

  for (final dotaEvent in eventsWorked['Dota']!) {
    if (dotaEvent.deductions != null) {
      final int hours = dotaEvent.hours - dotaEvent.deductions![gardenerID]!;
      if (hours > 0) {
        dotaEventsWorked.add(dotaEvent.copyWith(hours: hours));
        totalHours += hours;
      }
    } else {
      dotaEventsWorked.add(dotaEvent);
      totalHours += dotaEvent.hours;
    }
  }

  for (final csEvent in eventsWorked['CS']!) {
    if (csEvent.deductions != null) {
      final int hours = csEvent.hours - csEvent.deductions![gardenerID]!;
      if (hours > 0) {
        csEventsWorked.add(csEvent.copyWith(hours: hours));
        totalHours += hours;
      }
    } else {
      csEventsWorked.add(csEvent);
      totalHours += csEvent.hours;
    }
  }

  for (final rlEvent in eventsWorked['RL']!) {
    if (rlEvent.deductions != null) {
      final int hours = rlEvent.hours - rlEvent.deductions![gardenerID]!;
      if (hours > 0) {
        rlEventsWorked.add(rlEvent.copyWith(hours: hours));
        totalHours += hours;
      }
    } else {
      rlEventsWorked.add(rlEvent);
      totalHours += rlEvent.hours;
    }
  }

  for (final otherEvent in eventsWorked['Other']!) {
    if (otherEvent.deductions != null) {
      final int hours = otherEvent.hours - otherEvent.deductions![gardenerID]!;
      if (hours > 0) {
        otherEventsWorked.add(otherEvent.copyWith(hours: hours));
        totalHours += hours;
      }
    } else {
      otherEventsWorked.add(otherEvent);
      totalHours += otherEvent.hours;
    }
  }

  String htmlString = style +
      dateInput(DateTime.now()) +
      tableColumnName +
      dotaEventsRows(dotaEventsWorked) +
      csEventRows(csEventsWorked) +
      rlEventRows(rlEventsWorked) +
      otherEventRows(otherEventsWorked) +
      totalHoursRow(totalHours);

  final invoiceFile =
      File(filename).create().then((file) => file.writeAsString(htmlString));
  return invoiceFile;
}
