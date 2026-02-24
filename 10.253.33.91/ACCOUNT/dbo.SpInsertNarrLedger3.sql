-- Object: PROCEDURE dbo.SpInsertNarrLedger3
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpInsertNarrLedger3    Script Date: 20-Mar-01 11:43:36 PM ******/

/*   This Inserts  A Narration into ledger3 table for each voucher   in ledger    22/03/2000 */
CREATE PROCEDURE   SpInsertNarrLedger3  
 AS
declare   @@trefno varchar(12) ,
@@tnarr  integer,
@@tcur cursor    
 
 select @@tnarr =isnull( max(naratno),0)  from ledger3
 
                 set @@tcur = cursor for 
 select    distinct   substring( refno,1,7)    from ledger where substring(refno,1,7)
                    not in
                   (select   distinct  left(refno,7)   from ledger3 )
                 open @@tcur
 
   fetch next  from @@tcur into    @@trefno
         
 
while   @@fetch_status =0
begin
                
  select  @@tnarr =   @@tnarr  +1                   
                insert into ledger3 values ( @@tnarr  ,''  , @@trefno,'','')
             
               fetch next  from  @@tcur into     @@trefno
         
              
end
close @@tcur
deallocate @@tcur

GO
