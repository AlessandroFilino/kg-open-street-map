/* OSM2KM4C
   Copyright (C) 2017 DISIT Lab http://www.disit.org - University of Florence

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU Affero General Public License as
   published by the Free Software Foundation, either version 3 of the
   License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Affero General Public License for more details.

   You should have received a copy of the GNU Affero General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>. */

drop table if exists extra_all_boundaries_dump;

create table extra_all_boundaries_dump as 
	select relation_id, 
	(ST_Dump(ST_GeomFromText(ST_AsText(ST_LineMerge(ST_Collect(linestring))),4326))).geom boundary 
	from ( 
		select relation_members.relation_id, ways.linestring
		from relation_members 
		join ways on ways.id = relation_members.member_id and relation_members.member_type='W' 
		join relation_tags tag_type on relation_members.relation_id = tag_type.relation_id and tag_type.k = 'type' and tag_type.v = 'boundary' 
		join relation_tags boundary on relation_members.relation_id = boundary.relation_id and boundary.k = 'boundary' and boundary.v = 'administrative' 
       ) com 
       group by relation_id;

drop table if exists extra_all_boundaries;

create table extra_all_boundaries as 
select 
	relation_id, 
	ST_GeomFromText(ST_AsText(ST_MakePolygon(ST_AddPoint(boundary, ST_PointN(boundary, 1)))),4326) boundary,
	ST_GeomFromText(ST_AsText(ST_Centroid(ST_MakePolygon(ST_AddPoint(boundary, ST_PointN(boundary, 1))))),4326) centroid,
	ST_GeomFromText(ST_AsText(ST_Envelope(ST_MakePolygon(ST_AddPoint(boundary, ST_PointN(boundary, 1))))),4326) bbox
 from extra_all_boundaries_dump
 where ST_NumPoints(boundary) >= 3;

create index extra_all_boundaries_index_1 on extra_all_boundaries using gist(boundary);

create index extra_all_boundaries_index_2 on extra_all_boundaries using gist(bbox);

create index extra_all_boundaries_index_3 on extra_all_boundaries using gist(centroid);

drop table if exists outer_boundary;

create table outer_boundary as select * from extra_all_boundaries where relation_id = 365331; 

create index outer_boundary_index_1 on outer_boundary using gist(boundary);

drop table if exists good_boundaries;

create table good_boundaries as select extra_all_boundaries.* from extra_all_boundaries join outer_boundary on ST_Covers(outer_boundary.boundary, extra_all_boundaries.boundary);

delete from extra_all_boundaries where relation_id not in (select relation_id from good_boundaries);

