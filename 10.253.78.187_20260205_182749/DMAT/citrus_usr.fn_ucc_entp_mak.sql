-- Object: FUNCTION citrus_usr.fn_ucc_entp_mak
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_ucc_entp_mak](@pa_crn_no     NUMERIC
                          ,@pa_entp_cd    VARCHAR(20)
                          ,@pa_exch       CHAR(4)  
                          )
RETURNS VARCHAR(50)
AS
BEGIN
--
  DECLARE @l_entp_entpm_cd      VARCHAR(22)
        , @l_entp_value         VARCHAR(25)
        , @l_lst_upd_dt         datetime
  --   
if Right(@pa_entp_cd,4)='_HST'
  BEGIN 
	SELECT @l_entp_entpm_cd  =T.entp_entpm_cd,@l_entp_value         =T.entp_value FROM 
	(
	  SELECT  TOP 2  entp_entpm_cd
		   ,  entp_value 
		   , entp_lst_upd_dt
	  FROM   entp_hst   
	  WHERE  entp_entpm_cd         = LEFT(@pa_entp_cd,LEN(@pa_entp_cd)-LEN(RIGHT(@pa_entp_cd,4)))--Left(@pa_entp_cd,10)
	  AND    entp_ent_id           = @pa_crn_no
	  AND    entp_deleted_ind      = 1
	  and    entp_action           ='E'
	  order by entp_lst_upd_dt desc
	) T
	ORDER BY t.entp_lst_upd_dt desc

  END
  ELSE
  BEGIN   
  SELECT @l_entp_entpm_cd      = entp_entpm_cd
       , @l_entp_value         = entp_value 
  FROM   entity_properties_mak      
  WHERE  entp_entpm_cd         = @pa_entp_cd
  AND    entp_ent_id           = @pa_crn_no
  AND    entp_deleted_ind      = 0
  --
  END
  /*RETURN CASE WHEN @pa_exch    = 'NSE' THEN 
                ISNULL(CONVERT(VARCHAR(30), @l_entp_value),'')
              WHEN @pa_exch    = 'BSE' THEN
                ISNULL(CONVERT(VARCHAR(50), @l_entp_value),'')
              WHEN @pa_exch    = 'MCX' THEN
                ISNULL(CONVERT(VARCHAR(25), @l_entp_value),'')
              END
 */
 RETURN ISNULL(CONVERT(VARCHAR(50), @l_entp_value),'')  
--
END

GO
