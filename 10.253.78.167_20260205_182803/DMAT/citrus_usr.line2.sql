-- Object: TABLE citrus_usr.line2
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[line2]
(
    [ln_no] CHAR(2) NULL,
    [crn_no] NUMERIC(18, 0) NULL,
    [acct_no] VARCHAR(20) NULL,
    [product_number] VARCHAR(4) NULL,
    [bo_name] CHAR(100) NULL,
    [bo_middle_name] CHAR(20) NULL,
    [cust_search_name] CHAR(20) NULL,
    [bo_title] CHAR(10) NULL,
    [bo_suffix] CHAR(10) NULL,
    [hldr_fth_hsd_nm] CHAR(50) NULL,
    [cust_addr1] CHAR(300) NULL,
    [cust_addr2] CHAR(300) NULL,
    [cust_addr3] CHAR(300) NULL,
    [cust_addr_city] CHAR(300) NULL,
    [cust_addr_state] CHAR(300) NULL,
    [cust_addr_cntry] CHAR(300) NULL,
    [cust_addr_zip] CHAR(10) NULL,
    [cust_ph1_ind] CHAR(1) NULL,
    [cust_ph1] CHAR(17) NULL,
    [cust_ph2_ind] CHAR(1) NULL,
    [cust_ph2] CHAR(17) NULL,
    [cust_addl_ph] CHAR(100) NULL,
    [cust_fax] CHAR(17) NULL,
    [hldr_pan] CHAR(25) NULL,
    [it_crl] CHAR(15) NULL,
    [cust_email] CHAR(50) NULL,
    [bo_usr_txt1] CHAR(50) NULL,
    [bo_usr_txt2] CHAR(50) NULL,
    [bo_user_fld3] VARCHAR(20) NULL,
    [bo_user_fld4] CHAR(4) NULL,
    [bo_user_fld5] VARCHAR(20) NULL,
    [sign_bo] VARCHAR(8000) NULL,
    [sign_fl_flag] CHAR(1) NULL
);

GO
