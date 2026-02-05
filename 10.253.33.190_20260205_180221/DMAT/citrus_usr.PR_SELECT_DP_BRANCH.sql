-- Object: PROCEDURE citrus_usr.PR_SELECT_DP_BRANCH
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--PR_SELECT_DP_BRANCH 'BR','',''
CREATE PROCEDURE [citrus_usr].[PR_SELECT_DP_BRANCH]
(
	@PA_CD VARCHAR(20),                                                
	@PA_DESC VARCHAR(20),                                           
	@PA_REF_CUR VARCHAR(20) OUTPUT          
)   
AS
BEGIN
	SELECT DISTINCT ENTM_ID,ENTM_SHORT_NAME  ENTITY_SHORT_NAME                                            
	,ENTM_PARENT_ID   ENTITY_PARENT_ID                                            
	,ENTTM_PARENT_CD  ENTITY_TYPE_PARENT_CD                                             
	,ENTM_NAME1       ENTITY_NAME1                                            
	,ENTTM_ID         ENTTM_ID                                            
	,ENTM_ID          ENTITY_ID                         
	FROM   ENTITY_MSTR,ENTITY_TYPE_MSTR                                            
	WHERE  ENTITY_MSTR.ENTM_ENTTM_CD =ENTITY_TYPE_MSTR.ENTTM_CD                                            
	AND    ENTM_ENTTM_CD LIKE @PA_CD +'%'                 
	AND    ENTM_SHORT_NAME LIKE @PA_DESC +'%'                 
	AND    ENTM_DELETED_IND=1
END

GO
