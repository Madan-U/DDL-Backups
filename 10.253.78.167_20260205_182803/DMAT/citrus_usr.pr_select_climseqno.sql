-- Object: PROCEDURE citrus_usr.pr_select_climseqno
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_select_climseqno]( @pa_from_dt  VARCHAR(11)
                                    , @pa_to_dt    VARCHAR(11)
                                    , @pa_seq_no   NUMERIC
                                    )
AS
BEGIN
--
  IF @pa_from_dt = ''
  BEGIN 
  --
    set @pa_from_dt = null
  -- 
  END
  IF @pa_to_dt = ''
  BEGIN 
  --
    set @pa_to_dt = null
  -- 
  END

  SELECT clim.clim_crn_no           clim_crn_no
       , clim.clim_name1            clim_name1
       , ISNULL(clim.clim_name2,'') clim_name2
       , ISNULL(clim.clim_name3,'') clim_name3
       , climseqno.clim_seq_no      clim_seq_no

  FROM   client_mstr           clim
       , clim_seq_no           climseqno
  WHERE  clim.clim_crn_no    = climseqno.clim_crn_no 
  AND    clim.clim_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, ISNULL(@pa_from_dt,'01/01/1900'),103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,ISNULL(@pa_to_dt,'31/12/2100'),103),106)+' 23:59:59' 
  AND    ISNULL(clim_seq_no,0) > @pa_seq_no
       
--
END

GO
