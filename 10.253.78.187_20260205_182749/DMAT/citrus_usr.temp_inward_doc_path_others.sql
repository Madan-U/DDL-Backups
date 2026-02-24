-- Object: TABLE citrus_usr.temp_inward_doc_path_others
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[temp_inward_doc_path_others]
(
    [temp_indpo_id] NUMERIC(10, 0) IDENTITY(1,1) NOT NULL,
    [temp_indpo_inward_id] NUMERIC(10, 0) NULL,
    [temp_indpo_image] VARCHAR(30) NULL,
    [temp_indpo_urls] VARCHAR(200) NULL,
    [temp_indpo_image_binary] VARBINARY(MAX) NULL,
    [temp_indpo_created_dt] DATETIME NULL,
    [temp_indpo_created_by] VARCHAR(150) NULL,
    [temp_indpo_updated_dt] DATETIME NULL,
    [temp_indpo_updated_by] VARCHAR(150) NULL
);

GO
