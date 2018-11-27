#!/usr/bin/env python

import csv
import json

guide = {
    'accept': [],
    'reject': [],
}

with open('donation-guide.csv', 'r') as csvfile:
    with open('donation-guide.json', 'w') as jsonfile:
        reader = csv.reader(csvfile)
        for row in reader:
            decision = row[4]
            item = row[1]

            if decision == 'Accept':
                guide['accept'].append(item)
            else:
                guide['reject'].append(item)

        json.dump(guide, jsonfile)


