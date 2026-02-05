-- Object: FUNCTION citrus_usr.LastMonthDay
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create FUNCTION [citrus_usr].[LastMonthDay]
  ( @Date datetime )
RETURNS datetime
AS
BEGIN
RETURN (CASE WHEN MONTH(@Date)= 12
THEN DATEADD(day, -1, CAST('01/01/' + STR(YEAR(@Date)+1) AS DateTime))
ELSE DATEADD(day, -1, CAST(STR(MONTH(@Date)+1) + '/01/' + STR(YEAR(@Date)) AS DateTime))
END)
END

GO
