-- Object: TABLE citrus_usr.Vendor_Response
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Vendor_Response]
(
    [VR_id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [VR_DPID] VARCHAR(20) NULL,
    [VR_boid] VARCHAR(16) NULL,
    [VR_hldnm] VARCHAR(100) NULL,
    [VR_sechldnm] VARCHAR(100) NULL,
    [VR_thhldnm] VARCHAR(100) NULL,
    [VR_reqslip_fr] VARCHAR(30) NULL,
    [VR_reqslip_to] VARCHAR(30) NULL,
    [VR_old_bookno] VARCHAR(20) NULL,
    [VR_courier_name] VARCHAR(150) NULL,
    [VR_pod_no] VARCHAR(20) NULL,
    [VR_disp_date] VARCHAR(10) NULL,
    [VR_reqslip_no] VARCHAR(30) NULL,
    [VR_weight] NUMERIC(18, 2) NULL,
    [VR_created_dt] DATETIME NULL,
    [VR_created_by] VARCHAR(40) NULL,
    [VR_lst_upd_dt] DATETIME NULL,
    [VR_lst_upd_by] VARCHAR(40) NULL,
    [VR_deleted_ind] SMALLINT NULL,
    [VR_gen_id] VARCHAR(4) NULL,
    [VR_gen_dt] DATETIME NULL
);

GO
