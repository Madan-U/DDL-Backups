-- Object: PROCEDURE dbo.CBO_GetGoDeliveryClosing
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--  CBO_GetGoDeliveryClosing 'Oct 19 2007','72',1,'2004046','N','0A146','reliance','broker','broker'


CREATE procedure CBO_GetGoDeliveryClosing
(
  @transdate  VARCHAR(11),    
  @batchno    VARCHAR(10),    
  @slipno     int,     
  @settno     VARCHAR(7),    
  @setttype   VARCHAR(2),    
  @partycode   VARCHAR(10), 
  @scripcd    VARCHAR(12), 
  @STATUSID   VARCHAR(25) = 'BROKER',    
  @STATUSNAME VARCHAR(25) = 'BROKER'    
)
AS
   IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
   DECLARE
		  @SQL Varchar(2000)

   set @SQL = "select sno,sett_no,sett_type,party_code,DpId,CltDpId,HolderName,deltrans.scrip_cd,qty,isin=certno from  deltranstemp deltrans "
   set @SQL = @SQL + " where transdate like Convert(varchar(11), Convert(DateTime, '" + @transdate + "',103), 109)+ '%' and filler2= 1 and party_code <> 'BROKER' "
 
   If @batchno <> ''
        set @SQL = @SQL + " And Convert(Int,BatchNo) = '" + @batchno + "'"

    If @slipno <> '' 
     set @SQL = @SQL + " And Slipno = " + RTrim(Convert(CHAR, @slipno)) 
        
    If @settno <> '' 
       set @SQL = @SQL + " and sett_no= '"+@settno+"'"

    If @setttype <> '' 
       set @SQL = @SQL + " and sett_type = '"+@setttype+"'"
       
    If @partycode <> '' 
       set @SQL = @SQL + " and party_code = '"+@partycode+"'"
     
    If @scripcd  <> '' 
     set  @SQL = @SQL + " and scrip_cd = '"+@scripcd + "'"
   
    If @settno = '' Or @setttype = ''
     set  @SQL = @SQL + " order by sett_no,sett_type,party_code,scrip_cd"

     --exec(@SQL)
    Else
    BEGIN
    If @partycode = '' And @scripcd = '' 
      set @SQL = @SQL + " order by sett_no,sett_type,party_code,scrip_cd"
      
    If @partycode <> '' And @scripcd <> ''
      set @SQL = @SQL + " order by sett_no,sett_type,scrip_cd,party_code"
     
    If @partycode <> '' And @scripcd = '' 
     set  @SQL = @SQL + " order by sett_no,sett_type,scrip_cd,party_code"
              
    If @scripcd <> '' And @partycode = '' 
     set  @SQL = @SQL + " order by sett_no,sett_type,party_code,scrip_cd"
     END

    EXEC(@SQL)

GO
