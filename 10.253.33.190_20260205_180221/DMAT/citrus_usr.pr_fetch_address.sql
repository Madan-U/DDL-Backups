-- Object: PROCEDURE citrus_usr.pr_fetch_address
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--[pr_fetch_address] '00000015'
create PROCEDURE [citrus_usr].[pr_fetch_address] (                                                     
                                    @pa_boid varchar(20)         
                                            
                                   )                                                    
AS                                                      
BEGIN    
		DECLARE @BOID VARCHAR(16)
		SET @BOID = @pa_boid                                              
                   
		select adr1 + ' ' + adr2 + ' ' + adr3 + ' ' + city + ' ' + pincode  from (select 
		CASE WHEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),1),'') = '' 
			THEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'PER_ADR1'),1),'')
			ELSE Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),1),'') END as adr1
		,CASE WHEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),2),'') = '' 
			THEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'PER_ADR1'),2),'')
			ELSE Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),2),'') END as adr2
		,CASE WHEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),3),'') = '' 
			THEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'PER_ADR1'),3),'')
			ELSE Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),3),'') END as adr3
		,CASE WHEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),4),'') = '' 
			THEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'PER_ADR1'),4),'')
			ELSE Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),4),'') END as CITY
		,CASE WHEN Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),5),'') = '' 
			THEN replace(Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'PER_ADR1'),5),''),',-','')
			ELSE replace(Isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_crn_no,'COR_ADR1'),5),''),',-','') END as [pincode]
		---- ,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]  
		----,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile] 
		from dp_acct_mstr
		where dpam_sba_no =  @pa_boid ) a  
END

GO
