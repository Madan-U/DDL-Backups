-- Object: PROCEDURE dbo.C_GetScripQtySp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_GetScripQtySp
@Exchange Varchar(3),
@Segment Varchar(20),
@Party_Code Varchar(10),
@Effdate Varchar(11)
AS
select BalQty = sum(Crqty) - sum(Drqty), scrip_cd, series, isin from C_CalculateSecView
where party_code = @Party_Code and effdate <=@Effdate + '  23:59:59'
and Exchange = @Exchange and Segment =  @Segment
group by scrip_cd,series, isin

GO
