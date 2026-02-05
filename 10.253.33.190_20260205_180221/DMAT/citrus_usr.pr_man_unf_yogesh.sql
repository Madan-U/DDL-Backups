-- Object: PROCEDURE citrus_usr.pr_man_unf_yogesh
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--exec pr_man_unf_yogesh '1203320011361120'
CREATE  proc [citrus_usr].[pr_man_unf_yogesh] (@pa_boid varchar (16))
as 

Declare @pa_errmsg varchar (8000)

 IF not exists (SELECT 1   FROM DPS8_PC4 WHERE BOID  = @pa_boid)    
 BEGIN  
       
  SET @pa_errmsg =  'BOID NOT FOUND'+' : '+ @pa_boid
   select @pa_errmsg       
  RETURN          
 END 


begin
 INSERT INTO DPS8_PC4_BAK_DND
 SELECT *,'UNFREEZE AS PER MAIL FROM SANJAY MORE' TYPE  , GETDATE () DT     FROM DPS8_PC4 WHERE BOID  = @pa_boid
  
 UPDATE  DPS8_PC4 SET  TypeOfTrans = '3', FreezeStatus = 'U'  WHERE BOID  = @pa_boid
 AND  TypeOfTrans <>  '3' 
 BEGIN  
       
  SET @pa_errmsg =  'ACTION SUCCESSFULLY PERFORM'
   select @pa_errmsg       
         
 END 

 
end

GO
