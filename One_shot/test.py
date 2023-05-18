#!/usr/bin/env python3

import requests

def download_map(relation_id):
    response = requests.get(f"https://nominatim.openstreetmap.org/lookup?osm_ids=R{relation_id}&format=json").json()
    print(response)
    # polygon_coords = response["features"][0]["geometry"]["coordinates"][0]
    # polygon_coords_str = "poly: "
    # for (lat,long) in polygon_coords:
    #     polygon_coords_str += f"{lat} {long} " 
    # print(polygon_coords_str)


download_map(42621)

# (way(poly:");
# node();
# rel(););
# out meta;
