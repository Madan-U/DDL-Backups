-- Object: PROCEDURE dbo.C_selectclosingsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_selectclosingsp 
@closingdate Varchar(11)
As
Select Distinct C.scrip_cd, C.series, C.cl_rate, C.sysdate  From Closing C, C_securitiesmst C1
Where Cl_rate = Isnull((select Cl_rate From Closing Where Sysdate Like @closingdate + '%' And 
	C.scrip_cd = Scrip_cd And C.series = Series And C.market = Market),
	(select Cl_rate From Closing Where Sysdate = (select Max(sysdate) From Closing Where Sysdate < @closingdate + ' 23:59:59'
	And C.scrip_cd = Scrip_cd And C.series = Series And C.market = Market)
	And C.scrip_cd = Scrip_cd And C.series = Series And C.market = Market))
And C.scrip_cd = C1.scrip_cd And C.series = C1.series
Group By C.scrip_cd, C.series, C.sysdate, C.cl_rate

GO
