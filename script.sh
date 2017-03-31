#!/bin/bash 

declare -a myArray

# function to read in input file (shplist.txt)
loadArray() {
	n=0
	while read line
	do
		myArray[n]=$line
		n=$(($n + 1))
	done < $1
}


loadArray "shplist.txt"     # read into an array 50 states and D.C.

n=0

# PG password; shp2pgsql will look for environment variable PGPASSWORD when executed
echo "export PGPASSWORD=gisPassword"

for state in "${myArray[@]}"
do
	echo "$state"	# print the file name for a given state

	# download the file from the Census Bureau
	eval "curl -o ${state}.zip http://www2.census.gov/geo/tiger/TIGER2010BLKPOPHU/${state}.zip"
	eval "unzip ${state}.zip"

	# create shapefile.sql which contains insert statements
	if [ $n == 0 ]; then
		# first time, delete existing table if it exists == > -d means delete table
		eval "shp2pgsql  -d -s 4269 ${state} tabblock_2010_pophu > shapeinsert.sql"
	else
		# subsequently, add data to table ==> -a means add to the table
		eval "shp2pgsql  -a -s 4269 ${state} tabblock_2010_pophu > shapeinsert.sql"
	fi

	# the following 'rm' command are optional but consider that the files
	# for 50 states can be quite large to retain
	eval "rm ${state}.dbf"
	eval "rm ${state}.prj"
	eval "rm ${state}.shp"
	eval "rm ${state}.shp.xml"
	eval "rm ${state}.shx"
	eval "rm ${state}.zip"

	# execute command that actually runs the sql insert commands
	# i.e in this case db server=192.168.1.72 user=gisdb
	eval "psql -h 192.168.1.72 -d gisdb -U gisdb -f shapeinsert.sql"
	
	# an example if PG resided on AWS
	# eval "psql -h giscensus.chxlrrsmaz1x.us-west-2.rds.amazonaws.com -U mastergis -d census -f shapeinsert.sql"

	# optional 'rm' but consider the file could be quite large to retain
	eval "rm shapeinsert.sql"

	((n++))
	echo ""

done

echo "==========================================="
eval "date +%Y%m%d%H%M%S"
echo "================= finihed ================="
