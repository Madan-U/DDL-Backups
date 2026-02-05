-- Object: TABLE citrus_usr.temppr_reconsile_dis
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[temppr_reconsile_dis]
(
    [id] NUMERIC(18, 0) NOT NULL,
    [entm_name1] VARCHAR(203) NULL,
    [dpam_sba_name] VARCHAR(150) NULL,
    [dpam_sba_no] VARCHAR(20) NOT NULL,
    [created_by] VARCHAR(100) NULL,
    [remarks] VARCHAR(500) NULL,
    [req_slip_no] VARCHAR(100) NOT NULL,
    [slip_yn] CHAR(1) NOT NULL,
    [reco_yn] VARCHAR(10) NOT NULL,
    [reco_datetime] VARCHAR(8000) NULL,
    [code_1200] VARCHAR(1000) NULL,
    [name_1200] VARCHAR(8000) NULL,
    [contact_no_1200_code] VARCHAR(8000) NULL,
    [email_1200_code] VARCHAR(8000) NULL,
    [num_days_date_execution] VARCHAR(8000) NULL
);

GO
