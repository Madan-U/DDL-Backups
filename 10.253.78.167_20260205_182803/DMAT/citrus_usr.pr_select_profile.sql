-- Object: PROCEDURE citrus_usr.pr_select_profile
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_select_profile 3,0,'vb'
--SELECT * FROM BROKERAGE_MSTR
CREATE procedure [citrus_usr].[pr_select_profile]
(
	@pa_id	VARCHAR(20),
	@pa_profile_id varchar(100),
    @pa_profile_name varchar(100)
    

) 
AS
BEGIN

IF NOT EXISTS(SELECT BROM_ID FROM BROKERAGE_MSTR WHERE CASE WHEN @pa_profile_id = '0' THEN '0' ELSE BROM_ID END = CASE WHEN @pa_profile_id = '0' THEN '0' ELSE @pa_profile_id END AND CASE WHEN @pa_profile_name = '' THEN '' ELSE BROM_DESC END = CASE WHEN @pa_profile_name = '' THEN '' ELSE @pa_profile_name END AND BROM_DELETED_IND = 1)
BEGIN 
SELECT 'NO DATA FOUND' MSG

RETURN
END 
	declare @l_excsm_exch_cd varchar(20) 
                          
    select @l_excsm_exch_cd = excsm_Exch_cd from exch_seg_mstr    where excsm_id = @pa_id  
            
 PRINT @l_excsm_exch_cd      
       
    if @l_excsm_exch_cd  = 'CDSL'              
    begin              
		select isnull(brom_id,'0') brom_id , isnull(brom_desc ,'') brom_desc ,citrus_usr.fn_charge_ctgry_list(CHAM_SLAB_NO) ctgrylist,TRASTM_ID   
			,TRASTM_CD  CODE                  
			,TRASTM_DESC  DESCRIPTION  
			,isnull(CHAM_SLAB_NO,'0') as CHAM_SLAB_NO
			,replace(isnull(CHAM_SLAB_NAME,''),isnull(BROM_DESC,'')+'_','') as CHAM_SLAB_NAME
			,isnull(CHAM_CHARGE_TYPE,'') as CHAM_CHARGE_TYPE
			,isnull(CHAM_CHARGE_BASE,'') as CHAM_CHARGE_BASE
			,isnull(CHAM_BILL_PERIOD,'') as CHAM_BILL_PERIOD
			,isnull(CHAM_BILL_INTERVAL,'') as CHAM_BILL_INTERVAL
			,isnull(CHAM_CHARGE_BASEON,'') as CHAM_CHARGE_BASEON
			,isnull(CHAM_FROM_FACTOR,'0') as CHAM_FROM_FACTOR
			,isnull(CHAM_TO_FACTOR,'0') as CHAM_TO_FACTOR
			,isnull(CHAM_VAL_PERS,'') as CHAM_VAL_PERS
			,isnull(CHAM_CHARGE_VALUE,'0') as CHAM_CHARGE_VALUE
			,isnull(CHAM_CHARGE_MINVAL,'0') as CHAM_CHARGE_MINVAL
			,isnull(CHAM_CHARGE_GRADED,'0') as CHAM_CHARGE_GRADED
			,isnull(CHAM_CHARGEBITFOR,'0') as CHAM_CHARGEBITFOR  
			,isnull(CHAM_DTLS_ID,'0') as CHAM_DTLS_ID
			,isnull(CHAM_POST_TOACCT,'0') as CHAM_POST_TOACCT
			,isnull(CHAM_ACTIVE_YN,'') as CHAM_ACTIVE_YN
			,isnull(CHAM_PER_MIN,'0') as CHAM_PER_MIN
			,isnull(CHAM_PER_MAX,'0') as CHAM_PER_MAX  
			,isnull(CHAM_REMARKS,'') as CHAM_REMARKS            
		into #temp from   (SELECT TRASTM_ID,trastm_cd,TRASTM_DESC,trastm_tratm_id FROM transaction_sub_type_mstr    
							UNION
							Select 0,'O', 'ONE TIME CHARGE',0
							UNION
							Select 0,'F', 'FIXED CHARGE',0
							--Union
							--Select 0,'A', 'ACCOUNT CLOSURE',0
							Union
							Select 0,'H', 'HOLDING CHARGES',0
							Union
							Select 0,'AMT', 'BASED ON CHARGE AMOUNT',0
							 Union 
							select 0,'DISBOOK' , 'DISBOOK'  , 0 
							Union
							Select 0,'AMCPRO', 'AMC PRO RATA',0) TRASTM
                              
		left OUTER join (SELECT * FROM charge_mstr 
		, profile_charges,brokerage_mstr WHERE  PROC_SLAB_NO = CHAM_SLAB_NO AND BROM_ID = PROC_PROFILE_ID AND (CASE WHEN @pa_profile_id = '0' THEN '0' ELSE PROC_PROFILE_ID END = CASE WHEN @pa_profile_id = '0' THEN '0' ELSE @pa_profile_id END AND CASE WHEN @pa_profile_name = '' THEN '' ELSE BROM_DESC END = CASE WHEN @pa_profile_name = '' THEN '' ELSE @pa_profile_name END ) AND PROC_DELETED_IND = 1 AND CHAM_DELETED_IND = 1 AND BROM_DELETED_IND = 1) A ON  trastm_cd = CHAM_CHARGE_TYPE
		 , transaction_type_mstr                   
		where  (trastm_tratm_id          = trantm_id                   OR trastm_tratm_id = 0)
		and    trantm_code              = 'INT_TRANS_TYPE_CDSL'               
		and    trantm_deleted_ind       = 1              
  
		select distinct  * from #temp 
		order by CODE     
    end              
    else  if @l_excsm_exch_cd  = 'NSDL'              
    begin              
		select isnull(brom_id,'0') brom_id , isnull(brom_desc ,'') brom_desc,citrus_usr.fn_charge_ctgry_list(CHAM_SLAB_NO) ctgrylist,TRASTM_ID                     
			,TRASTM_CD  CODE                  
			,TRASTM_DESC  DESCRIPTION 
			,isnull(CHAM_SLAB_NO,'0') as CHAM_SLAB_NO
			,replace(isnull(CHAM_SLAB_NAME,''),isnull(BROM_DESC,'')+'_','') as CHAM_SLAB_NAME
			,isnull(CHAM_CHARGE_TYPE,'') as CHAM_CHARGE_TYPE
			,isnull(CHAM_CHARGE_BASE,'') as CHAM_CHARGE_BASE
			,isnull(CHAM_BILL_PERIOD,'') as CHAM_BILL_PERIOD
			,isnull(CHAM_BILL_INTERVAL,'') as CHAM_BILL_INTERVAL
			,isnull(CHAM_CHARGE_BASEON,'') as CHAM_CHARGE_BASEON
			,isnull(CHAM_FROM_FACTOR,'0') as CHAM_FROM_FACTOR
			,isnull(CHAM_TO_FACTOR,'0') as CHAM_TO_FACTOR
			,isnull(CHAM_VAL_PERS,'') as CHAM_VAL_PERS
			,isnull(CHAM_CHARGE_VALUE,'0') as CHAM_CHARGE_VALUE
			,isnull(CHAM_CHARGE_MINVAL,'0') as CHAM_CHARGE_MINVAL
			,isnull(CHAM_CHARGE_GRADED,'0') as CHAM_CHARGE_GRADED
			,isnull(CHAM_CHARGEBITFOR,'0') as CHAM_CHARGEBITFOR  
			,isnull(CHAM_DTLS_ID,'0') as CHAM_DTLS_ID
			,isnull(CHAM_POST_TOACCT,'0') as CHAM_POST_TOACCT
			,isnull(CHAM_ACTIVE_YN,'') as CHAM_ACTIVE_YN
			,isnull(CHAM_PER_MIN,'0') as CHAM_PER_MIN
			,isnull(CHAM_PER_MAX,'0') as CHAM_PER_MAX   
			,isnull(CHAM_REMARKS,'') as CHAM_REMARKS                   
		INTO #TEMP1 from   (SELECT TRASTM_ID,trastm_cd,TRASTM_DESC,trastm_tratm_id FROM transaction_sub_type_mstr    
							UNION
							Select 0,'O', 'ONE TIME CHARGE',0
							UNION
							Select 0,'F', 'FIXED CHARGE',0
							--Union
							--Select 0,'A', 'ACCOUNT CLOSURE',0
							Union
							Select 0,'H', 'HOLDING CHARGES',0
							Union
							Select 0,'AMT', 'BASED ON CHARGE AMOUNT',0
							Union
							Select 0,'AMCPRO', 'AMC PRO RATA',0) TRASTM 
		left OUTER join (SELECT * FROM charge_mstr 
		, profile_charges,brokerage_mstr WHERE  PROC_SLAB_NO = CHAM_SLAB_NO AND BROM_ID = PROC_PROFILE_ID AND (CASE WHEN @pa_profile_id = '0' THEN '0' ELSE PROC_PROFILE_ID END = CASE WHEN @pa_profile_id = '0' THEN '0' ELSE @pa_profile_id END AND CASE WHEN @pa_profile_name = '' THEN '' ELSE BROM_DESC END = CASE WHEN @pa_profile_name = '' THEN '' ELSE @pa_profile_name END ) AND PROC_DELETED_IND = 1 AND CHAM_DELETED_IND = 1 AND BROM_DELETED_IND = 1) A ON  trastm_cd = CHAM_CHARGE_TYPE
		 , transaction_type_mstr                   
		where  (trastm_tratm_id          = trantm_id  OR trastm_tratm_id = 0)                
		and    trantm_code              = 'INT_TRANS_TYPE_NSDL'               
		and    trantm_deleted_ind       = 1              
		and    TRASTM_CD     in ('202','042','033','011','012','021','022','052','071','212','091','092','093','062')              
	  
		SELECT distinct * FROM #TEMP1
		order by CODE             
    end    

END

GO
