-- QUESTION R1

select * from commande
where datepaiement IS NOT NULL; 

-- QUESTION R2 

SELECT codepostal, nombre_livraisons
FROM (
    SELECT
        codepostal,
        COUNT(*) AS nombre_livraisons
    FROM livraison
    GROUP BY codepostal
    ORDER BY COUNT(*) DESC
)
WHERE ROWNUM <= 3;

-- QUESTION R3 

SELECT e.nomfleur, SUM(e.nbrfleur) AS total_fleur
FROM est_compose_de e
JOIN commande c ON c.numcommande = e.numcommande
WHERE c.datecommande >= DATE '2021-01-01'
  AND c.datecommande <  DATE '2022-01-01'
GROUP BY e.nomfleur
HAVING SUM(e.nbrfleur) = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(e2.nbrfleur) AS total
        FROM est_compose_de e2
        JOIN commande c2 ON c2.numcommande = e2.numcommande
        WHERE c2.datecommande >= DATE '2021-01-01'
          AND c2.datecommande <  DATE '2022-01-01'
        GROUP BY e2.nomfleur
    )
);

-- QUESTION R4 

SELECT AVG(bouquets_par_client) AS moyenne_bouquets
FROM (
    SELECT commande.id, 
           COUNT(DISTINCT est_compose_de.numero_bouquet) AS bouquets_par_client
    FROM commande 
    JOIN est_compose_de ON commande.numcommande = est_compose_de.numcommande
    GROUP BY commande.id
);

-- QUESTION R5 
SELECT f.nomfleur
FROM fleur f
WHERE f.nomfleur NOT IN (
    SELECT DISTINCT e.nomfleur
    FROM est_compose_de e
);

-- QUESTION R6

SELECT c.NOM AS client_name,
       t.nomfleur,
       t.total_commandee FROM (
    SELECT commande.id AS client_id,
           est_compose_de.nomfleur,
           SUM(est_compose_de.nbrfleur) AS total_commandee
    FROM commande
    JOIN est_compose_de ON commande.numcommande = est_compose_de.numcommande
    GROUP BY commande.id, est_compose_de.nomfleur
) t
JOIN client c ON c.id = t.client_id
WHERE t.total_commandee = (
    SELECT MAX(SUM(e2.nbrfleur))
    FROM commande c2
    JOIN est_compose_de e2 ON c2.numcommande = e2.numcommande
    WHERE c2.id = t.client_id
    GROUP BY e2.nomfleur
);



-- QUESTION R7

SELECT
    c.numcommande,
    c.datecommande,
    cl.nom AS nom_client,
    SUM(e.nbrfleur * f.tariffleur) AS montant_commande
FROM commande c
JOIN client cl ON cl.id = c.id
JOIN est_compose_de e ON e.numcommande = c.numcommande
JOIN fleur f ON f.nomfleur = e.nomfleur
GROUP BY c.numcommande, c.datecommande, cl.nom
ORDER BY c.numcommande;


-- QUESTION R8

SELECT com1.nom
FROM commande com
JOIN client com1 ON com1.id = com.id
JOIN est_compose_de ecd ON ecd.numcommande = com.numcommande
JOIN fleur f ON f.nomfleur = ecd.nomfleur
WHERE com.datelivraisoneffective IS NULL
GROUP BY com.numcommande, com1.nom
HAVING SUM(ecd.nbrfleur * f.tariffleur) = (
    SELECT MAX(SUM(ecd2.nbrfleur * f2.tariffleur))
    FROM commande com2
    JOIN est_compose_de ecd2 ON ecd2.numcommande = com2.numcommande
    JOIN fleur f2 ON f2.nomfleur = ecd2.nomfleur
    WHERE com2.datelivraisoneffective IS NULL
    GROUP BY com2.numcommande
);		

-- QUESTION R9

SELECT com.numcommande,
       com1.nom,
       SUM(ecd.nbrfleur * f.tariffleur) AS montant_commande
FROM commande com
JOIN client com1 ON com1.id = com.id
JOIN est_compose_de ecd ON ecd.numcommande = com.numcommande
JOIN fleur f ON f.nomfleur = ecd.nomfleur
GROUP BY com.numcommande, com1.nom
HAVING SUM(ecd.nbrfleur * f.tariffleur) = (
    SELECT MAX(SUM(ecd2.nbrfleur * f2.tariffleur))
    FROM commande com2
    JOIN est_compose_de ecd2 ON ecd2.numcommande = com2.numcommande
    JOIN fleur f2 ON f2.nomfleur = ecd2.nomfleur
    GROUP BY com2.numcommande
);


