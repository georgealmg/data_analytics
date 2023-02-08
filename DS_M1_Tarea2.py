import csv, statistics
from pprint import pprint

arabicaDict = {}
robustaDict = {}

with open("arabica_data_cleaned.csv") as file:
    data = csv.DictReader(file ,dialect="excel")
    for row in data:
        country = row["Country.of.Origin"]
        if country not in arabicaDict:
            arabicaDict[country] = {}
            arabicaDict[country]["Flavor"] = []
            arabicaDict[country]["Flavor"].append(float(row["Flavor"]))
        elif country in arabicaDict:
            arabicaDict[country]["Flavor"].append(float(row["Flavor"]))

for country in arabicaDict.keys():
    values = arabicaDict[country]["Flavor"]
    arabicaDict[country]["mean"] = statistics.mean(values)
    arabicaDict[country]["median"] = statistics.median(values)
    arabicaDict[country]["mode"] = statistics.multimode(values)
    arabicaDict[country]["deviance"] = statistics.pstdev(values)
    arabicaDict[country]["variance"] = statistics.pvariance(values)

with open("robusta_data_cleaned.csv") as file:
    data = csv.DictReader(file ,dialect="excel")
    for row in data:
        country = row["Country.of.Origin"]
        if country not in robustaDict:
            robustaDict[country] = {}
            robustaDict[country]["Flavor"] = []
            robustaDict[country]["Flavor"].append(float(row["Flavor"]))
        elif country in robustaDict:
            robustaDict[country]["Flavor"].append(float(row["Flavor"]))

for country in robustaDict.keys():
    values = robustaDict[country]["Flavor"]
    robustaDict[country]["mean"] = statistics.mean(values)
    robustaDict[country]["median"] = statistics.median(values)
    robustaDict[country]["mode"] = statistics.multimode(values)
    robustaDict[country]["deviance"] = statistics.pstdev(values)
    robustaDict[country]["variance"] = statistics.pvariance(values)

pprint(arabicaDict)
print("#"*100)
pprint(robustaDict)