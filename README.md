# loadCensusBlocks

*script for loading 2010 census block data into PostgreSQL/PostGIS*

- Census Block data contain population and housing counts and the 'spatial' definition of the polygon.
- PostgreSQL & PostGIS extension should already be installed.
- Script will need a username/password who can CRUD tables in the given DB.
- 11,078,297 Census Blocks (2010) records.
- <i>shplist.txt</i> is an input file that contains the zip file names of 50 states and D.C.

*Notes:*
- About half of the census blocks are where <i>(population = 0 AND housing = 0)</i>.
- There are blocks where <i>(housing > 0 AND population = 0)</i>.
- Depending on what one is doing, it may be possible to remove blocks from the table.
