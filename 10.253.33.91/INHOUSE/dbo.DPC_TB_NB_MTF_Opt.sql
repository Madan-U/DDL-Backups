-- Object: PROCEDURE dbo.DPC_TB_NB_MTF_Opt
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

Create Procedure  [dbo].[DPC_TB_NB_MTF_Opt](@aCdate varchar(11),@TBDATE varchar(11),@segment varchar(10))                 
 
AS             
BEGIN  

 Create Table #TB
 (            
cltcode varchar(10),            
DrCr char(1),            
vamt money            
)            
         
		 
		 Create Index #t on #TB (Cltcode) 
       Create Index #t1 on #TB (Vamt) 
            
 if @aCdate=@TBDATE      
 BEGIN      
 insert into #TB         
 select cltcode,'D',sum(-vamt)       
 from MTFTRADE.dbo.LEDGER with (nolock) where vdt < @aCdate and edt >=@aCdate and drcr='D'      
 group by  cltcode      
 END      
 ELSE      
 BEGIN      
 insert into #TB          
 select cltcode,'D',sum(case when drcr='D' then vamt else -vamt end) from MTFTRADE.dbo.LEDGER with (nolock)             
 where vdt>= @aCdate and      
 /* (Case when vtyp=15 and drcr='D' then edt else vdt end) < @TBDATE  */          
 edt < @TBDATE
 group by cltcode            
 END      
       
 update #TB set Drcr='C' where vamt < 0            
            
      
	  
 Select @segment,* from #TB With(nolock) where isnumeric(left(cltcode,1))=0  
	      
END

GO
