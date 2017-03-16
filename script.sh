eval "sudo aptitude purge ruby1.9.1”

sudo apt-get update
sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev -y
sudo apt-get install git -y

git clone https://github.com/rbenv/rbenv.git ~/.rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
echo 'eval "$(rbenv init -)"' >> ~/.profile

source ~/.profile

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
exit

rbenv install 2.4.0
rbenv global 2.4.0
rbenv rehash

echo "gem: --no-document" > ~/.gemrc
eval "gem install bundler”

eval "gem install rails”

eval "rbenv rehash”
sudo apt-get install default-jre -y

sudo apt-get install nodejs -y







#!/bin/bash 


#
# curl -o tl_2010_40_tabblock10.zip 
# ftp://ftp2.census.gov/geo/tiger/TIGER2010/TABBLOCK/2010/tl_2010_40_tabblock10.zip

declare -a myArray

loadArray() {
	n=0
	while read line
	do
		myArray[n]=$line
		n=$(($n + 1))
	done < $1
}


loadArray "shplist.txt"     # list of input files into array

n=0

echo "export PGPASSWORD=gisDB"

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

	eval "rm ${state}.dbf"
	eval "rm ${state}.prj"
	eval "rm ${state}.shp"
	eval "rm ${state}.shp.xml"
	eval "rm ${state}.shx"
	eval "rm ${state}.zip"

	# execute command that actually runs the sql insert commands
	eval "psql -h 192.168.1.72 -d gisdb -U gisdb -f shapeinsert.sql"
	#eval "psql -h giscensus.chxlrrsmaz1x.us-west-2.rds.amazonaws.com -U mastergis -d census -f shapeinsert.sql"

	eval "rm shapeinsert.sql"

	# if [ $n == 1 ]; then
	# 	eval "date +%Y%m%d%H%M%S"
	# 	exit
	# fi


	((n++))
	echo ""

done

eval "date +%Y%m%d%H%M%S"

echo "================= finihed ================="
