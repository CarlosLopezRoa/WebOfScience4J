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
WHERE ar.article_id in range (1,1000)
WITH (ar.article_id) as article, collect(au.author_id) as authorlist
MATCH (au1:Authors),(au2:Authors)
WHERE au1.author_id in authorlist and au2.author_id in authorlist
MERGE (au1)-[r:isCoauthor]-(au2)
;


MATCH (a:Authors)-[r:isCoauthor]-(a:Authors)
RETURN count(r)
;

MATCH (a:Authors)-[r:isCoauthor]-(a:Authors)
DELETE r
;

MATCH (ar:Articles)-[:isArticle]-(s:Signatures)-[:isAuthor]-(au:Authors)
WHERE ar.article_id in range(0,1000)
WITH (ar.article_id) as article, collect(au.author_id) as authorlist
MATCH (ar:Articles),(au:Authors)
WHERE ar.article_id = article and au.author_id in authorlist
MERGE (ar)<-[r:isWritten]-(au)
;

MATCH p = (ar1:Articles)-[r1:isWritten]-(au1:Authors)-[r2:isCoauthor*0..5]-(au2:Authors)-[r3:isWritten]-(ar2:Articles)
WHERE ar1.article_id = 10 and ar2.article_id = 10
RETURN (ar1.article_id) as ar1,(ar2.article_id) as ar2 ,min(length(p)) as d
;

---

MATCH (n:Articles)-[r:isWritten]-(m:Authors)
WITH m.author_id as ntop, COUNT(r) as rank 
order by rank desc
RETURN rank, count(ntop)
order by rank desc
;

MATCH (n:Articles)-[r:isWritten]-(m:Authors)
WITH m.author_id as ntop, COUNT(r) as rank 
order by rank desc
RETURN rank
;

MATCH (n:Authors)-[r:isCoauthor]-(m:Authors)
WITH n.author_id as ntop, COUNT(r) as rank 
order by rank desc
RETURN rank, count(ntop)
order by rank desc
;

MATCH (n:Authors)-[r:isCoauthor]-(m:Authors)
WITH n.author_id as ntop, COUNT(r) as rank 
order by rank desc
RETURN rank
;

MATCH (n:Authors)-[r:isCoauthor]-(m:Authors)
RETURN n.author_id as ntop, COUNT(r) as rank 
order by rank desc
limit 10
;

MATCH p = (n:Authors)-[r:isCoauthor*0..5]-(m:Authors)
WHERE n.author_id = 271160
WITH  m.author_id as vicinity, length(p) as d 
order by rank desc
limit 10
;


---

MATCH (n:Authors)-[r:isCoauthor]-(m:Authors)
WITH n.author_id as ntop, COUNT(r) as rank 
order by rank desc
RETURN avg(rank)
;

MATCH (n:Authors)-[r:isCoauthor]-(m:Authors)
WITH n.author_id as ntop, COUNT(r) as rank 
order by rank desc
MATCH (ar:Articles)
WHERE 
RETURN n
;



RETURN collect(ntop) as autop
MATCH p = (au1:Authors)-[r:isCoauthor*0..5]-(au2:Authors)
WHERE au1.author_id in autop and au2.author_id in autop
RETURN (au1.author_id),(au2.author_id),min(length(p))
;



---

MATCH (n:Authors)-[r:isCoauthor]->(m:Authors)
WITH n as au, COUNT(r) as rank 
RETURN rank, count(au)
order by rank asc
;

MATCH (n:Authors)-[r:isCoauthor]->(m:Authors)
RETURN n as au, COUNT(r) as rank 
order by rank desc
limit 10
;

MATCH p = (s1:Signatures)-[r1:isAuthor]-(au1:Authors)-[r2:isCoauthor*]-(au2:Authors)-[r3:isAuthor]-(s2:Signatures)
RETURN (s1.signature_id),(s2.signature_id),length (p)
limit 100000
;

MATCH p = (s1:Signatures)-[r1:isAuthor]-(au1:Authors)-[r2:isCoauthor*]-(au2:Authors)-[r3:isAuthor]-(s2:Signatures)
WHERE s1.signature_id = 1 and s2.signature_id = 1
RETURN (s1.signature_id),(s2.signature_id),length (p)
limit 10
;

MATCH (s:Signatures)
WHERE s.signature_id = 1
RETURN *
;

MATCH (a:Authors)-[r:isCoauthor*..0]-(b:Authors)
WHERE a.author_id = 2
RETURN * 
;


MATCH p = (au1:Authors)-[r:isCoauthor*]-(au2:Authors)
WHERE au1.author_id in range (1000,1100) and au2.authorlist in range(1000,1100)
RETURN (au1.author_id),(au2.author_id),length(p)
;

MATCH p = (au1:Authors)-[r:isCoauthor*]-(au2:Authors)
RETURN max(length(p))
;

-- EOF

MATCH (a1)-[r:isCoauthor]-(a2) RETURN count(r);

MATCH (a1)-[r:isCoauthor]-(a2) DELETE r;


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
