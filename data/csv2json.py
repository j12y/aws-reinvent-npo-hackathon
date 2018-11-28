#!/usr/bin/env python

import csv
import json

guide = {
    'accept': {},
    'reject': {}
}

with open('donation-guide.csv', 'r') as csvfile:
    with open('donation-guide.json', 'w') as jsonfile:
        reader = csv.reader(csvfile)
        next(reader, None) # skip headers
        for row in reader:
            decision = row[4]
            item = row[1].lower()
            aliases = row[3].lower()
            category = row[0].lower()
            details = {
                'price': row[2].strip(),
                'aliases': aliases,
                'category': category,
                }

            if not item: continue

            if decision == 'Accept':
                guide['accept'][item] = details
                for alias in aliases.split(','):
                    guide['accept'][alias.lower()] = details
                    guide['accept'][category] = {}
            else:
                guide['reject'][item] = details
                for alias in aliases.split(','):
                    guide['reject'][alias.lower()] = details

        json.dump(guide, jsonfile)


