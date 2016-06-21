LOAD CSV WITH HEADERS FROM "file:///home/ubuntu/neo4jdata/articles_201606211925.csv" AS csvLine
CREATE (:Articles { 
	article_id: toInt(csvLine.id), 
	title: csvLine.title,
	authors: csvLine.authors,
	journal: csvLine.journal,
	year: csvLine.year
	});

CREATE INDEX ON :Articles(article_id);

LOAD CSV WITH HEADERS FROM "file:///home/ubuntu/neo4jdata/articles_authors.csv" AS csvLine
CREATE (:Authors { 
	article_id: toInt(csvLine.id),
	author: csvLine.author
	});

CREATE INDEX ON :Authors(article_id);


MATCH (s1:Signature),(s2:Signature)
WHERE s1.article_id = s2.article_id
RETURN s1.article_id,collect(s1.author)
;


MATCH (s1:Signature),(s2:Signature)
WHERE s1.article_id = s2.article_id
AND	  s1.author_id <> s2.author_id 
CREATE (s1)-[r:COAUTHOR {article_id : s1.author_id + '<->' + s2.author_id}] -> (s2)
RETURN r


MATCH (s1:Signature)-[r:COAUTHOR]-(s2:Signature)
RETURN r

MATCH (s1)
DETACH DELETE s1
