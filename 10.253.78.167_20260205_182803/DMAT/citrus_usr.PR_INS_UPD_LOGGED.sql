-- Object: PROCEDURE citrus_usr.PR_INS_UPD_LOGGED
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_LOGGED]
(
 @PA_LOGG_NAME VARCHAR(50)
,@PA_LOGG_IP VARCHAR(50)
,@PA_LOGG_SERVERIP VARCHAR(50)
,@PA_LOGG_CURRENTCNT NUMERIC
,@PA_LOGG_TOTALCNT NUMERIC
,@PA_PC_NAME varchar(100)
)
AS 
BEGIN
--declare @@pa_time_ind char(1)

--select top 1 @@pa_time_ind =  case when  abs(citrus_usr.fn_splitval_by(convert(varchar(5),getdate()-LOGG_DT,108),'2',':')) <= 20 then 'N' else 'Y' end from logged_mstr where LOGG_NAME=@PA_LOGG_NAME and LOGG_IP=@PA_LOGG_IP
--and convert(varchar(11),getdate())=convert(varchar(11),LOGG_DT) 
--order by 1 asc

--if ltrim(rtrim(isnull(@@pa_time_ind,'')))='' 
--set @@pa_time_ind='Y'

--if @@pa_time_ind='Y' 
--begin
INSERT INTO LOGGED_MSTR
(LOGG_NAME 
,LOGG_IP 
,LOGG_SERVERIP 
,LOGG_CURRENTCNT 
,LOGG_TOTALCNT 
,LOGG_DT 
,LOGG_CREATED_BY 
,LOGG_CREATED_DT 
,LOGG_LST_UPD_BY 
,LOGG_LST_UPD_DT 
,LOGG_DELETED_IND 
,LOGG_PC_NAME
)
VALUES
(
 @PA_LOGG_NAME 
,@PA_LOGG_IP 
,@PA_LOGG_SERVERIP 
,@PA_LOGG_CURRENTCNT 
,@PA_LOGG_TOTALCNT 
,getdate() 
,@PA_LOGG_NAME 
,GETDATE()
,@PA_LOGG_NAME 
,GETDATE()
,'1'
,@PA_PC_NAME
)
--end
END

GO
