# loadCensusBlocks
script for loading 2010 census block data (polygons) into PostgreSQL/PostGIS

Census Block data also contain population and housing counts.

PostgreSQL & PostGIS extension should already be installed.
A DB should be prepared and "create extension postgis" executed.
Script will need a username/password who can CRUD tables in the given DB.

11,078,297 Census Blocks (2010)

Note that about half of the census blocks are where (population = 0 AND housing = 0)
Also note that there are blocks where (housing > 0 AND population = 0)

Depending on what one is doing, it may be possible to remove blocks from the table.
