-- Object: PROCEDURE dbo.ABC
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC ABC AS

INSERT INTO LEDGER (Vtyp,Vno,Edt,Lno,Acname,Drcr,Vamt,Vdt,Cltcode,Booktype, BALAMT)
VALUES (6, '1', 'JUL  7 2006', 1, 'YATIN', 'C', 2, 'JUL  7 2006', 'ZZZZZZZZ', '01', 0)

INSERT INTO LEDGER (Vtyp,Vno,Edt,Lno,Acname,Drcr,Vamt,Vdt,Cltcode,Booktype, BALAMT)
VALUES (6, '1', 'JUL  7 2006', 1, 'YATIN', 'D', 2, 'JUL  7 2006', '0A141', '01', 0)

GO
