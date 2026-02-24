-- Object: PROCEDURE dbo.GET_SEND_PWD_DETAILS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


  
            
            
CREATE PROC [dbo].[GET_SEND_PWD_DETAILS]            
(            
 @UNAME VARCHAR(50)            
)            
/*            
 GET_SEND_PWD_DETAILS 'VIN'            
            
 9 * * * * * * * 1 9            
 9 * * * * * * * 1 9            
 9 * * * 5 * * * 1 9            
 B * * * * * * * * * * * * * v            
 B * * * * * * * * * * * * * v            
 Bharat.vaishnav@mkttech.in            
*/            
AS            
 DECLARE             
  @Mobile_hide as varchar(10),            
  @email_hide as varchar(100),            
  @email_b4_at as varchar(100),            
  @email_aft_at as varchar(100),            
  @email_b4_dot as varchar(100),            
  @email_b4_pos int,            
  @email_aft_pos int            
            
CREATE TABLE #TEMP            
(            
 MOBILE VARCHAR(10),            
 EMAIL VARCHAR(100),            
 MOBILE_HIDE VARCHAR(10),            
 EMAIL_HIDE VARCHAR(100)            
)            
            
            
insert into #TEMP            
--select phone2 as mobile, email,'',''   from subbrokers where sub_broker = @UNAME            
SELECT REGMOBILE AS MOBILE ,REGEMAILID ,'','' FROM [MIS].SB_COMP.DBO.SB_EMAIL_MOBILE  WHERE REGTAG = @UNAME            
            
select @Mobile_hide = MOBILE, @email_hide = EMAIL from #TEMP            
            
SET @Mobile_hide = STUFF(@Mobile_hide, 2, 3, '***')            
SET @Mobile_hide = STUFF(@Mobile_hide, 6, 3, '***')            
            
SET @email_b4_at  =  .dbo.piece(@email_hide,'@',1)            
SET @email_aft_at  =  .dbo.piece(@email_hide,'@',2)            
            
set @email_b4_pos = len(@email_b4_at)            
set @email_aft_pos = len(@email_aft_at)            
            
set @email_hide = stuff(@email_b4_at,(@email_b4_pos) - (@email_b4_pos -2),(@email_b4_pos -2), REPLICATE('*', (@email_b4_pos -2)) ) + '@' + @email_aft_at            
            
update #TEMP set MOBILE_HIDE = @Mobile_hide, EMAIL_HIDE = @email_hide            
            
select * from #TEMP

GO
