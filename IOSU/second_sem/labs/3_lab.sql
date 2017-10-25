-----1--------------------

CREATE OR REPLACE VIEW info_brest AS
SELECT *
FROM Branch
WHERE city='Брест';

-----2--------------------

CREATE OR REPLACE VIEW info_min_coast AS
SELECT *
FROM property_for_rent
WHERE rent IN
(
	SELECT min(rent)
	FROM Property_for_rent
);

-----3--------------------

CREATE OR REPLACE VIEW info_comments AS
SELECT COUNT (comment_o) COUNT_COMMENTS
FROM Viewing;

-----4--------------------
SELECT renter.*, city
FROM renter
JOIN branch ON renter.bno = branch.bno
WHERE (renter.bno,branch.city)
IN
(
	SELECT bno, city
	FROM Property_for_rent
	WHERE  rooms='3'
);

SELECT * FROM
(
	SELECT renter.*, city
	FROM renter
	JOIN branch ON renter.bno = branch.bno
) renter_with_city
LEFT JOIN
(
	SELECT bno, city
	FROM Property_for_rent
	WHERE  rooms='3'
) rooms_3
ON rooms_3.bno = renter_with_city.bno AND renter_with_city.city = rooms_3.city
WHERE rooms_3.bno IS NOT NULL


-----5--------------------

CREATE OR REPLACE VIEW info_biggest_branch AS
SELECT *
FROM Branch
WHERE bno IN
(
	SELECT bno
	FROM Staff
	GROUP BY bno
	HAVING COUNT(*)>= ALL(SELECT COUNT(*) FROM staff GROUP BY bno)
);

-----6--------------------

CREATE OR REPLACE VIEW info_view_6 AS
SELECT S.*, PFR.street, PFR.city, PFR.type, PFR.rooms
FROM Staff S
JOIN property_for_rent PFR ON S.sno=PFR.sno;

-----7-------------------

SELECT owner.fname, owner.lname, PFR.street,PFR.city, PFR.type, PFR.rooms, PFR.rent
FROM property_for_rent PFR
JOIN owner ON owner.ono = PFR.ono
JOIN
(
	SELECT *
	FROM viewing
	WHERE TO_CHAR(date_o,'Q') IN
	(
		SELECT TO_CHAR(sysdate,'Q') FROM dual
	)
)v ON v.pno = PFR.pno;

-----8-------------------

CREATE OR REPLACE VIEW info_view_7 AS
SELECT *
FROM owner
WHERE ono IN
(
	SELECT DISTINCT ono
	FROM property_for_rent
	WHERE pno IN
		(
			SELECT pno
			FROM viewing
			GROUP BY pno
			HAVING COUNT(*)>2
		)
);