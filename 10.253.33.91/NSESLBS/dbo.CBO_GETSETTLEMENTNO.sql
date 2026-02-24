-- Object: PROCEDURE dbo.CBO_GETSETTLEMENTNO
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------














CREATE                  PROCEDURE [dbo].[CBO_GETSETTLEMENTNO]
--(
--@ASP VARCHAR(20) 
--)
AS
DECLARE
		@SQL Varchar(2000)
		
            BEGIN
                                        
                                      Select Distinct Sett_Type from DematTrans where sett_no = '2005536'  And RefNo = '110' And TrType <> 906 Order By Sett_Type
                                        
              
                   --Select Distinct Sett_Type from DematTrans where sett_no ='2005535' and RefNo = '110' And TrType <> 906 Order By Sett_Type
                   
             END
	
--select * from DematTrans 

--insert into DematTrans (Sett_No,Sett_Type,Refno,Tcode,Trtype, Party_Code,Scrip_Cd,Qty,Series,Trdate,Cltaccno,Dpid,Dpname,Isin,Branch_Cd,Partipantcode,Dptype,Transno,Drcr,Bdptype,Bdpid,Bcltaccno,Filler1,Filler2,Filler3,Filler4,Filler5 )
--values('2005535','N','110','241593','904','0A143','ALBK','300','EQ','2005-03-24','241593','IN300853','PPP','88','222','222',' Demat','23','3','23','1','55','NSDL','1127','15615750','1900-01-01','0')                            
--select * from deltrans
--Select Distinct Sett_Type from DematTrans where sett_no = '2005535' and RefNo = '110' And TrType <> 906 Order By Sett_Type

GO
