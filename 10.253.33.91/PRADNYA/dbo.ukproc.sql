-- Object: PROCEDURE dbo.ukproc
-- Server: 10.253.33.91 | DB: PRADNYA
--------------------------------------------------

create proc ukproc as
UPDATE UK
SET MYFLAG = 
(
CASE WHEN 
1 = 1
AND NSE_B <> '-' 
AND BSE_B = '-' 
AND FO_B <> '-' 
AND MCX_B = '-' 
AND NCX_B = '-'
	THEN
		(
		CASE WHEN 
			1 = 1
			AND CM_B = NSE_B 
			AND CM_S = NSE_S 
--			AND CM_B = BSE_B 
--			AND CM_S = BSE_S 
			AND CM_B = FO_B 
			AND CM_S = FO_S 
--			AND CM_B = MCX_B 
--			AND CM_S = MCX_S 
--			AND CM_B = NCX_B
--			AND CM_S = NCX_S
		THEN 1
		ELSE 0
		END
		)
	ELSE 2
END
)
WHERE
MYFLAG = 2

	
SELECT MYFLAG, COUNT(1) FROM UK
GROUP BY MYFLAG

SELECT * FROM UK
WHERE MYFLAG = 2

DELETE FROM UK
WHERE MYFLAG = 1

GO
