LOAD CSV WITH HEADERS FROM "file:///articles_201606211925.csv" AS csvLine
CREATE (:Articles { 
	article_id: toInt(csvLine.id), 
	title: csvLine.title,
	authors: csvLine.authors,
	journal: csvLine.journal,
	year: csvLine.year
	});

CREATE INDEX ON :Articles(article_id);

LOAD CSV WITH HEADERS FROM "file:///authors_201606212001.csv" AS csvLine
CREATE (:Authors { 
	author_id: toInt(csvLine.author_id),
	author: csvLine.author
	});

CREATE INDEX ON :Authors(author_id);


LOAD CSV WITH HEADERS FROM "file:///signature_201606212307.csv" AS csvLine
CREATE (:Signatures { 
	signature_id: toInt(csvLine.signature_id),
	article_id: toInt(csvLine.article_id),
	author_id: toInt(csvLine.author_id)
	});

CREATE INDEX ON :Signatures(signature_id);
CREATE INDEX ON :Signatures(article_id);
CREATE INDEX ON :Signatures(author_id);


MATCH (s:Signatures),(au:Authors)
WHERE s.author_id = au.author_id
CREATE (au)-[r:isAuthor]->(s)
;

MATCH (s:Signatures),(ar:Articles)
WHERE s.article_id = ar.article_id
CREATE (ar)-[r:isArticle]->(s)
;

MATCH (ar:Articles)-[:isArticle]-(s:Signatures)-[:isAuthor]-(au:Authors)
WHERE ar.article_id=1
RETURN collect(au.author_id) as aulist
limit 10
;


MATCH (au1:Authors),(au2:Authors)
WHERE au1.article_id = au2.article_id
CREATE (ar)-[r:isArticle]->(s)
RETURN r
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
