-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dpb9_bak_22092018
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




--EXEC PR_BULK_INS_DPB9  @PA_EXCH     = 'CDSL'  
--            ,@PA_LOGIN_NAME    ='HO'  
--            ,@PA_MODE          ='BULK'
--            ,@PA_DB_SOURCE     ='c:\BulkInsDbfolder_test\CLIENT MASTER IMPORT-DPB9DPS8-CDSL-12010900\08DPS8UINCREMENTAL.010900'
--            ,@ROWDELIMITER     ='*|~*'     
--            ,@COLDELIMITER     ='|*~|'      
--            ,@PA_ERRMSG        =''   

  
create proc [citrus_usr].[pr_bulk_ins_dpb9_bak_22092018]    
 (    
    @pa_exch          VARCHAR(20)        
            ,@pa_login_name    VARCHAR(20)        
            ,@pa_mode          VARCHAR(10)                                        
            ,@pa_db_source     VARCHAR(250)        
            ,@rowdelimiter     CHAR(4) =     '*|~*'          
            ,@coldelimiter     CHAR(4) =     '|*~|'          
            ,@pa_errmsg        VARCHAR(8000) output        
            )          
AS        
begin     
truncate table DPB9_PC0    
truncate table DPB9_PC1    
truncate table DPB9_PC2    
truncate table DPB9_PC3    
truncate table DPB9_PC4    
truncate table DPB9_PC5    
truncate table DPB9_PC6    
truncate table DPB9_PC7    
truncate table DPB9_PC8    
truncate table DPB9_PC12    
truncate table DPB9_PC16    
truncate table DPB9_PC17  
truncate table DPB9_PC18  
truncate table DPB9_PC19  
DROP TABLE dpb9_source1  
truncate table dpb9_source   
  
declare @@SSQL varchar(5000)    
  
   truncate table dpb9_source_main
    
  SET @@SSQL = 'BULK INSERT vw_dpb9 FROM ''' + @pa_db_source +  ''' WITH    
(    
    
FIELDTERMINATOR=''\n'',    
ROWTERMINATOR = ''\n''      
)'    
    
    
--PRINT @@SSQL    
EXEC (@@SSQL)    

insert into  dpb9_source --1201090002948563
select value from dpb9_source_main order by id 

--

--    
--  SET @@SSQL = 'BULK INSERT dpb9_source FROM ''' + @pa_db_source +  ''' WITH    
--(    
--    
--FIELDTERMINATOR=''\n'',    
--ROWTERMINATOR = ''\n''      
--)'    
--    
--    
--PRINT @@SSQL    
--EXEC (@@SSQL)    
--
  
--SELECT IDENTITY(NUMERIC,1,1) ID , * INTO dpb9_source1 FROM dpb9_source  

SELECT * INTO dpb9_source1 from dpb9_source_main order by id 
  
   create index ix_1 on dpb9_source1 (value)  
    
create table #dpb9_source(ID             numeric, value varchar(700),boid varchar(16),TransSystemDate varchar(50))    
    
    
    
    
  
       
   create index ix_1 on #dpb9_source (ID,value)    
    -- select * from #dpb9_source  
--  UPDATE #dpb9_source         
--  SET    #dpb9_source.value = #dpb9_source.value +  '~' + T.BOID  + '~' + t.TransSystemDate       
--  FROM   (SELECT ID,         
--     BOID   ,TransSystemDate     
--     FROM   #dpb9_source        
--     WHERE  BOID <> '') T         
--  WHERE  T.ID = (SELECT TOP 1 ID        
--      FROM   #dpb9_source S        
--      WHERE  S.ID < #dpb9_source.ID        
--      AND S.BOID <> ''        
--      ORDER BY 1 DESC)        
--     AND (left(#dpb9_source.value,2) in ('01','02','03','04','05','06','07','08','12','16','17','18','19'))      
--         




DECLARE @c     CURSOR   

declare  @id numeric, @value varchar(1500), @BOID varchar(16), @TransSystemDate varchar(100)


SET    @c =  CURSOR fast_forward FOR      
    SELECT id,value--,        
--    BOID = (CASE WHEN value LIKE '00%' THEN citrus_usr.fn_splitval_by(value,2,'~') ELSE '' END)  
--   ,TransSystemDate =   (CASE WHEN value LIKE '00%' THEN citrus_usr.fn_splitval_by(value,7,'~') ELSE '' END)      
   FROM   dpb9_source1     ORDER BY  id  
   
 OPEN @c      
    FETCH NEXT FROM @c INTO @id, @value 
  
    WHILE @@fetch_status = 0      
    BEGIN      
    --      
	if left(@value,2)='00'
	begin 
    select  @BOID =  citrus_usr.fn_splitval_by(value,2,'~')  , @TransSystemDate 
	= citrus_usr.fn_splitval_by(value,7,'~') from dpb9_source1 where id = @id 
	end 
	if left(@value,2)<>'00'
	begin 
    update dpb9_source1 set value =  value + '~'+ @BOID + '~'   +  @TransSystemDate where id = @id 
    
	

	end 

FETCH NEXT FROM @c INTO @id, @value 

    --      
    END      
  
  
    CLOSE      @c      
    DEALLOCATE @c 

      

 INSERT INTO #dpb9_source       
   SELECT id,value,        
    BOID = (CASE WHEN value LIKE '00%' THEN citrus_usr.fn_splitval_by(value,2,'~') ELSE '' END)  
   ,TransSystemDate =   (CASE WHEN value LIKE '00%' THEN citrus_usr.fn_splitval_by(value,7,'~') ELSE '' END)      
   FROM   dpb9_source1     ORDER BY  id   

    
DECLARE @@SSQL1 VARCHAR(5000)       
,@L_COUNTER NUMERIC    
,@L_COUNT NUMERIC   
  
SELECT IDENTITY (NUMERIC, 1,1) ID , VALUE INTO #dpb9_pc0 from #dpb9_source     
where left(#dpb9_source.value ,2) = '00'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc0     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC0 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc0     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
    
    
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0      
    
SELECT IDENTITY (NUMERIC, 1,1) ID , VALUE INTO #dpb9_pc1 from #dpb9_source     
where left(#dpb9_source.value ,2) = '01'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc1     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC1 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc1     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
    
    
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc2 from #dpb9_source     
where left(#dpb9_source.value ,2) = '02'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc2     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC2 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc2     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
    
    
    
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc3 from #dpb9_source     
where left(#dpb9_source.value ,2) = '03'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc3     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC3 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc3     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc4 from #dpb9_source     
where left(#dpb9_source.value ,2) = '04'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc4     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC4 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc4     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
       
    
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc5 from #dpb9_source     
where left(#dpb9_source.value ,2) = '05'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc5     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC5 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc5     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
     
    
    
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc6 from #dpb9_source     
where left(#dpb9_source.value ,2) = '06'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc6     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC6(PurposeCode6
,TypeOfTrans
,Title
,Name
,MiddleName
,SearchName
,Suffix
,FthName
,Addr1
,Addr2
,Addr3
,City
,State
,Country
,PinCode
,PriPhInd
,PriPhNum
,AltPhInd
,AltPhNum
,AddPhones
,Fax
,PANGIR
,ItCircle
,EMailid
,DateOfSetup
,DateOfBirth
,UsrTxt1
,UsrTxt2
,UsrFld3
,Email
,UnqIdNum
,Filler1
,Filler2
,Filler3
,Filler4
,Filler5
,Filler6
,Filler7
,Filler8
,Filler9
,Filler10
,RES_SEC_FLg
,NOM_Sr_No
,rel_WITH_BO
,perc_OF_SHARES
,BOId
,TransSystemDate
)  VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc6     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
       
     
    
    
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc7 from #dpb9_source     
where left(#dpb9_source.value ,2) = '07'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc7     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC7(PurposeCode7
,TypeOfTrans
,Title
,Name
,MiddleName
,SearchName
,Suffix
,FthName
,Addr1
,Addr2
,Addr3
,City
,State
,Country
,PinCode
,PriPhInd
,PriPhNum
,AltPhInd
,AltPhNum
,AddPhones
,Fax
,PANGIR
,ItCircle
,EMailid
,DateOfSetup
,DateOfBirth
,UsrTxt1
,UsrTxt2
,UsrFld3
,Email
,UnqIdNum
,Filler1
,Filler2
,Filler3
,Filler4
,Filler5
,Filler6
,Filler7
,Filler8
,Filler9
,Filler10
,RES_SEC_FLg
,NOM_Sr_No
,rel_WITH_BO
,perc_OF_SHARES
,BOId
,TransSystemDate
) VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc7     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
       
    
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc8 from #dpb9_source     
where left(#dpb9_source.value ,2) = '08'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc8     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC8(PurposeCode8
,TypeOfTrans
,Title
,Name
,MiddleName
,SearchName
,Suffix
,FthName
,Addr1
,Addr2
,Addr3
,City
,State
,Country
,PinCode
,PriPhInd
,PriPhNum
,AltPhInd
,AltPhNum
,AddPhones
,Fax
,PANGIR
,ItCircle
,EMailid
,DateOfSetup
,DateOfBirth
,UsrTxt1
,UsrTxt2
,UsrFld3
,Email
,UnqIdNum
,Filler1
,Filler2
,Filler3
,Filler4
,Filler5
,Filler6
,Filler7
,Filler8
,Filler9
,Filler10
,RES_SEC_FLg
,NOM_Sr_No
,rel_WITH_BO
,perc_OF_SHARES
,BOId
,TransSystemDate
)  VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc8     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
       
    
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc12 from #dpb9_source     
where left(#dpb9_source.value ,2) = '12'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc12     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC12 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc12     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
    
    
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc16 from #dpb9_source     
where left(#dpb9_source.value ,2) = '16'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc16     
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC16 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc16     
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
    
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc17 from #dpb9_source     
where left(#dpb9_source.value ,2) = '17'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc17    
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC17 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc17    
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc18 from #dpb9_source     
where left(#dpb9_source.value ,2) = '18'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc18    
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC18(PurposeCode18
,TypeOfTrans
,NaSeqNum
,BOName
,Remarks
,Namechange
,BOId
,TransSystemDate
) VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc18    
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
END     
       
       
set @@SSQL1  =''    
set @L_COUNTER = 0     
set @L_COUNT = 0     
    
    
SELECT IDENTITY (NUMERIC, 1,1) ID , value value INTO #dpb9_pc19 from #dpb9_source     
where left(#dpb9_source.value ,2) = '19'    
    
    
    
SET @L_COUNTER =  1    
SELECT @L_COUNT = MAX(ID)  FROM #dpb9_pc19    
    
    
WHILE @L_COUNTER < = @L_COUNT     
BEGIN     
    
SET @@SSQL1 = ''    
SELECT @@SSQL1 = 'INSERT INTO DPB9_PC19 VALUES(''' +replace( REPLACE(value,'''',''''''),'~',''',''') + ''') '     
from #dpb9_pc19    
where ID = @L_COUNTER    
    
    
SET @L_COUNTER = @L_COUNTER + 1     
    
--PRINT @@SSQL1    
EXEC (@@SSQL1)    
  
  
  
    
    
END     
  
  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC1_ORG from DPB9_PC1  group by boid  
  
delete a from DPB9_PC1 a  
where not exists(select * from #DPB9_PC1_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC2_ORG from DPB9_PC2  group by boid  
  
delete a from DPB9_PC2 a  
where not exists(select * from #DPB9_PC2_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC3_ORG from DPB9_PC3  group by boid  
  
delete a from DPB9_PC3 a  
where not exists(select * from #DPB9_PC3_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC4_ORG from DPB9_PC4  group by boid  
  
delete a from DPB9_PC4 a  
where not exists(select * from #DPB9_PC4_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC5_ORG from DPB9_PC5  group by boid  
  
delete a from DPB9_PC5 a  
where not exists(select * from #DPB9_PC5_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC6_ORG from DPB9_PC6  group by boid  
  
delete a from DPB9_PC6 a  
where not exists(select * from #DPB9_PC6_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC7_ORG from DPB9_PC7  group by boid  
  
delete a from DPB9_PC7 a  
where not exists(select * from #DPB9_PC7_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC8_ORG from DPB9_PC8  group by boid  
  
delete a from DPB9_PC8 a  
where not exists(select * from #DPB9_PC8_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC12_ORG from DPB9_PC12  group by boid  
  
delete a from DPB9_PC12 a  
where not exists(select * from #DPB9_PC12_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC16_ORG from DPB9_PC16  group by boid  
  
delete a from DPB9_PC16 a  
where not exists(select * from #DPB9_PC16_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC17_ORG from DPB9_PC17  group by boid  
  
delete a from DPB9_PC17 a  
where not exists(select * from #DPB9_PC17_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC18_ORG from DPB9_PC18  group by boid  
  
delete a from DPB9_PC18 a  
where not exists(select * from #DPB9_PC18_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
select boid , max(TransSystemDate) TransSystemDate into  #DPB9_PC19_ORG from DPB9_PC19  group by boid  
  
delete a from DPB9_PC19 a  
where not exists(select * from #DPB9_PC19_ORG b where a.boid = b.boid and a.TransSystemDate = b.TransSystemDate)  
  
  
  
  
DROP TABLE #dpb9_pc0   
DROP TABLE #dpb9_pc1    
DROP TABLE #dpb9_pc2    
DROP TABLE #dpb9_source    
drop table #dpb9_pc3    
drop table #dpb9_pc4    
drop table #dpb9_pc5    
drop table #dpb9_pc6    
drop table #dpb9_pc7    
drop table #dpb9_pc8    
drop table #dpb9_pc12    
drop table #dpb9_pc16    
drop table #dpb9_pc17    
drop table #dpb9_pc18    
drop table #dpb9_pc19   
  
  
DROP TABLE #DPB9_PC1_ORG  
DROP TABLE #DPB9_PC2_ORG  
DROP TABLE #DPB9_PC3_ORG  
DROP TABLE #DPB9_PC4_ORG  
DROP TABLE #DPB9_PC5_ORG  
DROP TABLE #DPB9_PC6_ORG  
DROP TABLE #DPB9_PC7_ORG  
DROP TABLE #DPB9_PC8_ORG  
DROP TABLE #DPB9_PC12_ORG  
DROP TABLE #DPB9_PC16_ORG  
DROP TABLE #DPB9_PC17_ORG  
DROP TABLE #DPB9_PC18_ORG  
DROP TABLE #DPB9_PC19_ORG  
   
end

GO
