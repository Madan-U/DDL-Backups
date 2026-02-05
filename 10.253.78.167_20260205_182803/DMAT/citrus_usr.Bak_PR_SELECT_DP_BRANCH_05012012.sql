-- Object: PROCEDURE citrus_usr.Bak_PR_SELECT_DP_BRANCH_05012012
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--PR_SELECT_DP_BRANCH 'BR','',''
CREATE PROCEDURE [citrus_usr].[Bak_PR_SELECT_DP_BRANCH_05012012]
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
--and entm_id in (140283
--,140274
--,140282
--,140270
--,140286) 
--order by 5
END

GO
