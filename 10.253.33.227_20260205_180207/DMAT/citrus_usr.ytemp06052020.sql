-- Object: TABLE citrus_usr.ytemp06052020
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[ytemp06052020]
(
    [inst_id] VARCHAR(101) NULL,
    [REQUESTDATE] VARCHAR(11) NULL,
    [EXECUTIONDATE] VARCHAR(11) NULL,
    [trans_descp] VARCHAR(8000) NULL,
    [SLIPNO] VARCHAR(20) NULL,
    [ACCOUNTNO] VARCHAR(16) NULL,
    [ACCOUNTNAME] VARCHAR(150) NULL,
    [QUANTITY] NUMERIC(18, 3) NULL,
    [DUAL CHECKER] VARCHAR(25) NOT NULL,
    [mkr] VARCHAR(20) NULL,
    [mkr_dt] VARCHAR(20) NULL,
    [ORDBY] INT NOT NULL,
    [ISIN_NAME] VARCHAR(282) NULL,
    [ISIN] VARCHAR(20) NULL,
    [dptdc_request_dt] DATETIME NULL,
    [Amt_charged] NUMERIC(18, 2) NOT NULL,
    [outstand_amt] NUMERIC(18, 2) NOT NULL,
    [mkt_type] VARCHAR(200) NOT NULL,
    [other_mkt_type] VARCHAR(200) NOT NULL,
    [settlementno] VARCHAR(20) NOT NULL,
    [othersettmno] VARCHAR(20) NOT NULL,
    [cmbp] VARCHAR(20) NOT NULL,
    [counter_account] VARCHAR(20) NOT NULL,
    [counter_dpid] VARCHAR(20) NOT NULL,
    [Status1] VARCHAR(1019) NULL,
    [auth_rmks] VARCHAR(1202) NOT NULL,
    [checker1] VARCHAR(25) NOT NULL,
    [checker1_dt] VARCHAR(20) NULL,
    [checker2] VARCHAR(20) NOT NULL,
    [checker2_dt] VARCHAR(20) NULL,
    [slip_reco] VARCHAR(3) NOT NULL,
    [image_scan] VARCHAR(3) NOT NULL,
    [scan_dt] VARCHAR(20) NULL,
    [dptdc_rmks] VARCHAR(250) NOT NULL,
    [backoffice_code] VARCHAR(50) NOT NULL,
    [reason] VARCHAR(77) NOT NULL,
    [recon_datetime] VARCHAR(20) NULL,
    [batchno] VARCHAR(20) NOT NULL,
    [RejectionDate] VARCHAR(1000) NULL,
    [courier] VARCHAR(250) NOT NULL,
    [podno] VARCHAR(25) NOT NULL,
    [dispdate] VARCHAR(11) NULL,
    [Rate] VARCHAR(8000) NULL,
    [Valuation] FLOAT NULL
);

GO
