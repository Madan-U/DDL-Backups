-- Object: TABLE citrus_usr.inward_doc_path_others
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[inward_doc_path_others]
(
    [indpo_id] NUMERIC(10, 0) IDENTITY(1,1) NOT NULL,
    [indpo_inward_id] NUMERIC(10, 0) NULL,
    [indpo_image] VARCHAR(30) NULL,
    [indpo_urls] VARCHAR(200) NULL,
    [indpo_image_binary] VARBINARY(MAX) NULL,
    [indpo_created_dt] DATETIME NULL,
    [indpo_created_by] VARCHAR(150) NULL,
    [indpo_updated_dt] DATETIME NULL,
    [indpo_updated_by] VARCHAR(150) NULL
);

GO
